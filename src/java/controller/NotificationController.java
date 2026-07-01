/*
 * NotificationController.java
 * Xem/đánh dấu đã đọc thông báo (User)
 * Gửi thông báo (Admin)
 */
package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

public class NotificationController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "notification/list.jsp";
        try {
            String action = request.getParameter("action");
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;
            NotificationDAO notifDAO = new NotificationDAO();

            if ("notificationList".equals(action) || action == null) {
                // User xem thông báo
                if (currentUser != null) {
                    ArrayList<NotificationDTO> notifications = notifDAO.listByUserId(currentUser.getUserId());
                    long unreadCount = notifDAO.countUnread(currentUser.getUserId());
                    request.setAttribute("notifications", notifications);
                    request.setAttribute("unreadCount", unreadCount);
                }
                url = "notification/list.jsp";

            } else if ("markRead".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                notifDAO.markAsRead(id);
                response.sendRedirect(request.getContextPath() + "/NotificationController?action=notificationList");
                return;

            } else if ("markAllRead".equals(action)) {
                if (currentUser != null) {
                    notifDAO.markAllAsRead(currentUser.getUserId());
                }
                response.sendRedirect(request.getContextPath() + "/NotificationController?action=notificationList");
                return;

            } else if ("deleteNotification".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                NotificationDTO notif = notifDAO.searchByID(id);
                if (notif != null && notif.getUser().getUserId() == currentUser.getUserId()) {
                    notifDAO.remove(notif);
                }
                response.sendRedirect(request.getContextPath() + "/NotificationController?action=notificationList");
                return;

            } else if ("adminSendForm".equals(action)) {
                // Admin: form gửi thông báo
                if (currentUser != null && currentUser.isAdmin()) {
                    UserDAO userDAO = new UserDAO();
                    request.setAttribute("users", userDAO.listAll());
                    url = "admin/notifications/send.jsp";
                } else {
                    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                    return;
                }

            } else if ("sendNotification".equals(action)) {
                // Admin gửi thông báo
                if (currentUser != null && currentUser.isAdmin()) {
                    String title = request.getParameter("title");
                    String message = request.getParameter("message");
                    String type = request.getParameter("type");
                    if (type == null || type.isEmpty()) type = "SYSTEM";

                    String targetUserId = request.getParameter("targetUserId");
                    UserDAO userDAO = new UserDAO();

                    if ("all".equals(targetUserId)) {
                        // Gửi cho tất cả user
                        ArrayList<UserDTO> allUsers = userDAO.listAll();
                        for (UserDTO u : allUsers) {
                            NotificationDTO notif = new NotificationDTO(u, title, message, type);
                            notifDAO.add(notif);
                        }
                    } else {
                        // Gửi cho 1 user
                        int uid = Integer.parseInt(targetUserId);
                        UserDTO targetUser = userDAO.searchByID(uid);
                        if (targetUser != null) {
                            NotificationDTO notif = new NotificationDTO(targetUser, title, message, type);
                            notifDAO.add(notif);
                        }
                    }

                    response.sendRedirect(request.getContextPath()
                            + "/NotificationController?action=adminSendForm&msg=sent");
                    return;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        } finally {
            if (!response.isCommitted())
                request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
