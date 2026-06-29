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
import java.util.Date;
import model.RoleDAO;
import model.RoleDTO;
import model.UserDAO;
import model.UserDTO;
import utils.PasswordUtil;

/**
 *
 * @author TRI VY
 */
public class RegisterController extends HttpServlet {

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
    private final RoleDAO roleDAO = new RoleDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String method = request.getMethod();

        // GET → hiển thị trang đăng ký
        if ("GET".equalsIgnoreCase(method)) {
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // POST → xử lý form đăng ký
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // ── 1. Validate phía server (phòng trường hợp bypass JS) ──
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập họ tên.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập email.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("errorMessage", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // ── 2. Kiểm tra email đã tồn tại chưa ──
        if (userDAO.searchByEmail(email.trim().toLowerCase()) != null) {
            request.setAttribute("errorMessage", "Email này đã được đăng ký. Vui lòng dùng email khác.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // ── 3. Lấy role USER mặc định (roleId = 2) ──
        RoleDTO userRole = roleDAO.searchByID(2);
        if (userRole == null) {
            // Fallback: tìm theo tên nếu ID thay đổi
            userRole = roleDAO.searchByName("USER");
        }
        if (userRole == null) {
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // ── 4. Tạo user mới ──
        UserDTO newUser = new UserDTO();
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPassword(PasswordUtil.hash(password)); // BCrypt hash
        newUser.setPhone(phone != null ? phone.trim() : null);
        newUser.setRole(userRole);
        newUser.setStatus("ACTIVE");
        newUser.setAvatar("default-avatar.png");

        // ── 5. Lưu vào DB ──
        boolean success = userDAO.add(newUser);

        if (!success) {
            request.setAttribute("errorMessage", "Đăng ký thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // ── 6. Đăng ký thành công → redirect login kèm thông báo ──
        response.sendRedirect(request.getContextPath() + "/LoginController?registered=success");
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
