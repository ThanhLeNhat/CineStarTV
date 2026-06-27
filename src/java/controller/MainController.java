/*
 * MainController.java
 * Front Controller (MVC-V2) — Chỉ điều phối, không chứa logic
 * Nhận action → forward đến Controller tương ứng
 */
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "index.jsp";
        try {
            String action = request.getParameter("action");

            if ("home".equals(action)) {
                url = "HomeController";
            } else if ("login".equals(action)) {
                url = "auth/login.jsp";
            } else if ("doLogin".equals(action)) {
                url = "LoginController";
            } else if ("register".equals(action)) {
                url = "auth/register.jsp";
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

    @Override
    public String getServletInfo() {
        return "CineStarTV Main Controller - Front Controller Pattern";
    }
}
