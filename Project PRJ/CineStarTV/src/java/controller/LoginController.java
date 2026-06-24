/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDAO;
import model.UserDTO;
import utils.PasswordUtil;

/**
 *
 * @author TRI VY
 */
@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {
 
    private final UserDAO userDAO = new UserDAO();
 
    // GET: Hiển thị trang đăng nhập
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        // Nếu đã login rồi thì redirect thẳng về home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            response.sendRedirect(request.getContextPath() + "/MainController");
            return;
        }
 
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
 
    // POST: Xử lý form đăng nhập
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
 
        // Validate input rỗng
        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ email và mật khẩu.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
 
        // Tìm user theo email
        UserDTO user = userDAO.searchByEmail(email.trim().toLowerCase());
 
        // Kiểm tra từng trường hợp — hiển thị lỗi cụ thể cho user
        if (user == null) {
            request.setAttribute("errorMessage", "Email chưa được đăng ký.");
            request.setAttribute("emailValue", email); // giữ lại giá trị đã nhập
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
 
        if ("BANNED".equals(user.getStatus())) {
            request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ hỗ trợ.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
 
        if (user.getPassword() == null) {
            // Tài khoản đăng ký qua Google, không có password
            request.setAttribute("errorMessage", "Tài khoản này đăng nhập bằng Google. Vui lòng dùng nút 'Đăng nhập với Google'.");
            request.setAttribute("emailValue", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
 
        if (!PasswordUtil.verify(password, user.getPassword())) {
            request.setAttribute("errorMessage", "Mật khẩu không đúng.");
            request.setAttribute("emailValue", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
 
        // Đăng nhập thành công — tạo session
        HttpSession session = request.getSession(true);
        session.setAttribute("loggedUser", user);
        session.setMaxInactiveInterval(60 * 60); // session hết hạn sau 1 giờ không hoạt động
 
        // Redirect theo role
        if (user.isAdmin() || user.isStaff()) {
            response.sendRedirect(request.getContextPath() + "/AdminController");
        } else {
            response.sendRedirect(request.getContextPath() + "/MainController");
        }
    }
}