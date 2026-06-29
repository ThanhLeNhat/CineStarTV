/*
 * UserController.java
 * CRUD User — chỉ ADMIN mới truy cập được
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

public class UserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "admin/users/list.jsp";
        try {
            String action = request.getParameter("action");
            UserDAO userDAO = new UserDAO();
            RoleDAO roleDAO = new RoleDAO();

            if ("userEdit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                UserDTO user = userDAO.searchByID(id);
                request.setAttribute("editUser", user);
                request.setAttribute("roles", roleDAO.listAll());
                url = "admin/users/form.jsp";

            } else if ("userDoEdit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("userId"));
                UserDTO user = userDAO.searchByID(id);
                if (user != null) {
                    int roleId = Integer.parseInt(request.getParameter("roleId"));
                    String status = request.getParameter("status");
                    user.setRole(roleDAO.searchByID(roleId));
                    user.setStatus(status);
                    String phone = request.getParameter("phone");
                    if (phone != null && !phone.trim().isEmpty()) {
                        user.setPhone(phone.trim());
                    }
                    userDAO.update(user);
                }
                response.sendRedirect(request.getContextPath() + "/UserController?action=userList&msg=updated");
                return;

            } else if ("userBan".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                userDAO.softDelete(id);
                response.sendRedirect(request.getContextPath() + "/UserController?action=userList&msg=banned");
                return;

            } else if ("userActivate".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                UserDTO user = userDAO.searchByID(id);
                if (user != null) {
                    user.setStatus("ACTIVE");
                    userDAO.update(user);
                }
                response.sendRedirect(request.getContextPath() + "/UserController?action=userList&msg=activated");
                return;

            } else {
                // userList — mặc định
                ArrayList<UserDTO> users = userDAO.listAll();
                request.setAttribute("users", users);
                url = "admin/users/list.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        } finally {
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
