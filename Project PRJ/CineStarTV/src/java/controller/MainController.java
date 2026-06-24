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

/**
 *
 * @author TRI VY
 */
public class MainController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "index.jsp";
        try {
            String action = request.getParameter("action");

            if ("home".equals(action)) {
                url = "index.jsp";
            } else if ("login".equals(action)) {
                url = "login.jsp";
            } else if ("doLogin".equals(action)) {
                url = "LoginController";
            } else if ("register".equals(action)) {
                url = "register.jsp";
            } else if ("doRegister".equals(action)) {
                url = "RegisterController";
            } else if ("logout".equals(action)) {
                url = "LogoutController";
            } else if ("movieList".equals(action)) {
                url = "MovieController";
            } else if ("movieDetail".equals(action)) {
                url = "MovieController";
            } else if ("searchMovie".equals(action)) {
                url = "MovieController";
            } else if ("cinemaList".equals(action)) {
                url = "CinemaController";
            } else if ("selectShowtime".equals(action)) {
                url = "BookingController";
            } else if ("selectSeat".equals(action)) {
                url = "BookingController";
            } else if ("confirmBooking".equals(action)) {
                url = "BookingController";
            } else if ("blogList".equals(action)) {
                url = "BlogController";
            } else if ("blogDetail".equals(action)) {
                url = "BlogController";
            } else if ("profile".equals(action)) {
                url = "ProfileController";
            } else if ("bookingHistory".equals(action)) {
                url = "ProfileController";
            } else if ("adminDashboard".equals(action)) {
                url = "AdminController";
            } else if ("adminMovies".equals(action)) {
                url = "AdminController";
            } else if ("adminAddMovie".equals(action)) {
                url = "AdminController";
            } else if ("adminEditMovie".equals(action)) {
                url = "AdminController";
            } else if ("adminDeleteMovie".equals(action)) {
                url = "AdminController";
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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