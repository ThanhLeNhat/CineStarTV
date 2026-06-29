/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
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
public class LoginController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private final UserDAO userDAO = new UserDAO();
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
 
    response.setContentType("text/html;charset=UTF-8");
    String method = request.getMethod();
 
    // GET → hiển thị trang login
    if ("GET".equalsIgnoreCase(method)) {
 
        // Nếu đã login rồi thì không cần vào trang login nữa
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            response.sendRedirect(request.getContextPath() + "/MainController");
            return;
        }
 
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;
    }
 
    // POST → xử lý form đăng nhập
    String email    = request.getParameter("email");
    String password = request.getParameter("password");
 
    // Validate rỗng
    if (email == null || email.trim().isEmpty()
            || password == null || password.trim().isEmpty()) {
        request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ email và mật khẩu.");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;
    }
 
    // Tìm user theo email
    UserDTO user = userDAO.searchByEmail(email.trim().toLowerCase());
 
    // Email không tồn tại
    if (user == null) {
        request.setAttribute("errorMessage", "Email chưa được đăng ký.");
        request.setAttribute("emailValue", email.trim());
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;
    }
 
    // Tài khoản bị khóa
    if ("BANNED".equals(user.getStatus())) {
        request.setAttribute("errorMessage", "Tài khoản đã bị khóa. Vui lòng liên hệ hỗ trợ.");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;
    }
 
    // Tài khoản Google (không có password)
    if (user.getPassword() == null) {
        request.setAttribute("errorMessage", "Tài khoản này đăng nhập bằng Google.");
        request.setAttribute("emailValue", email.trim());
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;
    }
 
    // Sai mật khẩu
    if (!PasswordUtil.verify(password, user.getPassword())) {
        request.setAttribute("errorMessage", "Mật khẩu không đúng.");
        request.setAttribute("emailValue", email.trim());
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;
    }
 
    // Đăng nhập thành công → tạo session
    HttpSession session = request.getSession(true);
    session.setAttribute("loggedUser", user);
    session.setMaxInactiveInterval(60 * 60); // 1 giờ
 
    // Redirect theo role
    if (user.isAdmin() || user.isStaff()) {
        response.sendRedirect(request.getContextPath() + "/AdminController");
    } else {
        response.sendRedirect(request.getContextPath() + "/MainController");
    }
}

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
