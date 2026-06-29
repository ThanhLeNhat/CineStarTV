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

            // === MOVIE ===
            } else if ("movieList".equals(action)) {
                url = "MovieController";
            } else if ("movieDetail".equals(action)) {
                url = "MovieController";
            } else if ("searchMovie".equals(action)) {
                url = "MovieController";
            } else if ("cinemaList".equals(action)) {
                url = "CinemaController";

            // === BOOKING ===
            } else if ("selectShowtime".equals(action)) {
                url = "BookingController";
            } else if ("selectSeat".equals(action)) {
                url = "BookingController";
            } else if ("confirmBooking".equals(action)) {
                url = "BookingController";
            } else if ("bookingHistory".equals(action)) {
                url = "BookingController";
            } else if ("cancelBooking".equals(action)) {
                url = "BookingController";

            // === PAYMENT ===
            } else if ("processPayment".equals(action)) {
                url = "PaymentController";
            } else if ("doPayment".equals(action)) {
                url = "PaymentController";
            } else if ("paymentResult".equals(action)) {
                url = "PaymentController";

            // === REVIEW ===
            } else if ("addReview".equals(action)) {
                url = "ReviewController";
            } else if ("editReview".equals(action)) {
                url = "ReviewController";
            } else if ("deleteReview".equals(action)) {
                url = "ReviewController";

            // === VOUCHER (user) ===
            } else if ("applyVoucher".equals(action)) {
                url = "VoucherController";

            // === NOTIFICATION (user) ===
            } else if ("notificationList".equals(action)) {
                url = "NotificationController";
            } else if ("markRead".equals(action)) {
                url = "NotificationController";
            } else if ("markAllRead".equals(action)) {
                url = "NotificationController";
            } else if ("deleteNotification".equals(action)) {
                url = "NotificationController";

            // === BLOG (public) ===
            } else if ("blogList".equals(action)) {
                url = "BlogPostController";
            } else if ("blogDetail".equals(action)) {
                url = "BlogPostController";

            // === PROFILE ===
            } else if ("profile".equals(action)) {
                url = "ProfileController";

            // === ADMIN ===
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
            // Admin Users
            } else if ("adminUsers".equals(action)) {
                url = "UserController";
            // Admin Bookings
            } else if ("adminBookingList".equals(action)) {
                url = "BookingController";
            // Admin Vouchers
            } else if ("adminVouchers".equals(action)) {
                url = "VoucherController";
            // Admin Blogs
            } else if ("adminBlogList".equals(action)) {
                url = "BlogPostController";
            } else if ("blogAdd".equals(action)) {
                url = "BlogPostController";
            } else if ("blogDoAdd".equals(action)) {
                url = "BlogPostController";
            } else if ("blogEdit".equals(action)) {
                url = "BlogPostController";
            } else if ("blogDoEdit".equals(action)) {
                url = "BlogPostController";
            } else if ("blogDelete".equals(action)) {
                url = "BlogPostController";
            // Admin Reviews
            } else if ("adminReviewList".equals(action)) {
                url = "ReviewController";
            } else if ("hideReview".equals(action)) {
                url = "ReviewController";
            } else if ("showReview".equals(action)) {
                url = "ReviewController";
            // Admin Notifications
            } else if ("adminSendForm".equals(action)) {
                url = "NotificationController";
            } else if ("sendNotification".equals(action)) {
                url = "NotificationController";
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
