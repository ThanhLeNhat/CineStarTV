package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.*;

public class RegisterController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "auth/register.jsp";
        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            UserDAO userDAO = new UserDAO();

            // Kiểm tra email đã tồn tại
            if (userDAO.searchByEmail(email) != null) {
                request.setAttribute("error", "Email đã được sử dụng.");
            } else {
                UserDTO user = new UserDTO();
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPassword(utils.PasswordUtil.hashPassword(password));
                user.setPhone(phone);
                user.setRole(new RoleDAO().searchByID(2)); // Role USER
                user.setStatus("ACTIVE");

                if (userDAO.add(user)) {
                    request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                    url = "auth/login.jsp";
                } else {
                    request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                }
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
