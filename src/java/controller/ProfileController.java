package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.*;
import utils.ImageUtils;
import utils.PasswordUtil;

@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 5 * 1024 * 1024)

/**
 * ProfileController — Xem và sửa thông tin cá nhân.
 *
 * Actions:
 *   - (default)       : Xem profile
 *   - profileEdit     : Form sửa thông tin
 *   - profileDoEdit   : Lưu thông tin [POST]
 *   - changePassword  : Form đổi mật khẩu
 *   - doChangePassword: Xử lý đổi mật khẩu [POST]
 */
public class ProfileController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "user/profile.jsp";
        try {
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;

            // AuthenticationFilter đã chặn nếu chưa login, nhưng vẫn guard thêm
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/LoginController");
                return;
            }

            String action = request.getParameter("action");
            UserDAO userDAO = new UserDAO();

            if ("profileEdit".equals(action)) {
                // Load user mới nhất từ DB
                UserDTO fresh = userDAO.searchByID(currentUser.getUserId());
                request.setAttribute("editUser", fresh != null ? fresh : currentUser);
                url = "user/profile-edit.jsp";

            } else if ("profileDoEdit".equals(action)) {
                String fullName = request.getParameter("fullName");
                String phone    = request.getParameter("phone");

                if (fullName == null || fullName.trim().isEmpty()) {
                    request.setAttribute("error", "Họ tên không được để trống.");
                    request.setAttribute("editUser", currentUser);
                    url = "user/profile-edit.jsp";
                } else {
                    UserDTO user = userDAO.searchByID(currentUser.getUserId());
                    if (user != null) {
                        user.setFullName(fullName.trim());
                        user.setPhone(phone != null ? phone.trim() : "");
                        // Xử lý upload avatar
                        try {
                            Part avatarPart = request.getPart("avatarFile");
                            if (ImageUtils.hasFile(avatarPart)) {
                                user.setAvatar(ImageUtils.saveImage(avatarPart, "avatars"));
                            }
                        } catch (IllegalArgumentException ex) {
                            request.setAttribute("error", ex.getMessage());
                            request.setAttribute("editUser", user);
                            url = "user/profile-edit.jsp";
                            return;
                        }
                        userDAO.update(user);
                        // Cập nhật lại session
                        session.setAttribute("user", user);
                    }
                    response.sendRedirect(request.getContextPath()
                            + "/ProfileController?msg=updated");
                    return;
                }

            } else if ("changePassword".equals(action)) {
                url = "user/change-password.jsp";

            } else if ("doChangePassword".equals(action)) {
                String oldPass  = request.getParameter("oldPassword");
                String newPass  = request.getParameter("newPassword");
                String confirm  = request.getParameter("confirmPassword");

                UserDTO user = userDAO.searchByID(currentUser.getUserId());

                if (user == null || !PasswordUtil.verify(oldPass, user.getPassword())) {
                    request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
                    url = "user/change-password.jsp";
                } else if (newPass == null || newPass.length() < 6) {
                    request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
                    url = "user/change-password.jsp";
                } else if (!newPass.equals(confirm)) {
                    request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
                    url = "user/change-password.jsp";
                } else {
                    user.setPassword(PasswordUtil.hashPassword(newPass));
                    userDAO.update(user);
                    session.setAttribute("user", user);
                    response.sendRedirect(request.getContextPath()
                            + "/ProfileController?msg=pwchanged");
                    return;
                }

            } else {
                // Mặc định: xem profile
                UserDTO fresh = userDAO.searchByID(currentUser.getUserId());
                request.setAttribute("profileUser", fresh != null ? fresh : currentUser);
                request.setAttribute("msg", request.getParameter("msg"));
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/error/404.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại.");
        } finally {
            if (!response.isCommitted()) {
                request.getRequestDispatcher(url).forward(request, response);
            }
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
