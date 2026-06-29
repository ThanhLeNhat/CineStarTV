/*
 * AdminController.java
 * Dashboard thống kê (Admin)
 */
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.*;

public class AdminController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "admin/dashboard.jsp";
        try {
            MovieDAO movieDAO = new MovieDAO();
            UserDAO userDAO = new UserDAO();
            BookingDAO bookingDAO = new BookingDAO();

            request.setAttribute("totalMovies", movieDAO.countAll());
            request.setAttribute("totalUsers", userDAO.countAll());
            request.setAttribute("totalBookings", bookingDAO.countAll());
            request.setAttribute("totalRevenue", bookingDAO.sumRevenue());

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
