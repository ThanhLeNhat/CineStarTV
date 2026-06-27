package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

public class LoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "auth/login.jsp";
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            UserDAO userDAO = new UserDAO();
            UserDTO user = userDAO.searchByEmail(email);

            if (user != null && utils.PasswordUtil.checkPassword(password, user.getPassword())) {
                if ("INACTIVE".equals(user.getStatus())) {
                    request.setAttribute("error", "Tài khoản đã bị khóa.");
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("role", user.getRole().getRoleName());
                    url = "MainController?action=home";
                }
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại.");
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
