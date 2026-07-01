/*
 * ReviewController.java
 * CRUD đánh giá phim — Yêu cầu đăng nhập
 * User: thêm/sửa/xóa review
 * Admin: xem tất cả, ẩn review vi phạm
 */
package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

public class ReviewController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "movie/detail.jsp";
        try {
            String action = request.getParameter("action");
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;
            ReviewDAO reviewDAO = new ReviewDAO();

            if ("addReview".equals(action)) {
                int movieId = Integer.parseInt(request.getParameter("movieId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                MovieDAO movieDAO = new MovieDAO();

                ReviewDTO existing = reviewDAO.searchByUserAndMovie(currentUser.getUserId(), movieId);
                if (existing != null) {
                    existing.setRating(rating);
                    existing.setComment(comment);
                    existing.setStatus("ACTIVE");
                    reviewDAO.update(existing);
                } else {
                    MovieDTO movie = movieDAO.searchByID(movieId);
                    ReviewDTO review = new ReviewDTO();
                    review.setUser(currentUser);
                    review.setMovie(movie);
                    review.setRating(rating);
                    review.setComment(comment);
                    review.setStatus("ACTIVE");
                    reviewDAO.add(review);
                }

                // Cập nhật rating trung bình của phim
                double avg = reviewDAO.getAverageRating(movieId);
                int count = reviewDAO.countByMovieId(movieId);
                movieDAO.updateRating(movieId, Math.round(avg * 10.0) / 10.0, count);

                response.sendRedirect(request.getContextPath()
                        + "/MovieController?action=movieDetail&id=" + movieId + "&msg=reviewed");
                return;

            } else if ("editReview".equals(action)) {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                ReviewDTO review = reviewDAO.searchByID(reviewId);
                if (review != null && review.getUser().getUserId() == currentUser.getUserId()) {
                    review.setRating(rating);
                    review.setComment(comment);
                    reviewDAO.update(review);
                }

                int movieId = review != null ? review.getMovie().getMovieId() : 0;
                response.sendRedirect(request.getContextPath()
                        + "/MovieController?action=movieDetail&id=" + movieId + "&msg=updated");
                return;

            } else if ("deleteReview".equals(action)) {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                ReviewDTO review = reviewDAO.searchByID(reviewId);
                int movieId = 0;
                if (review != null) {
                    movieId = review.getMovie().getMovieId();
                    if (review.getUser().getUserId() == currentUser.getUserId() || currentUser.isAdmin()) {
                        review.setStatus("HIDDEN");
                        reviewDAO.update(review);
                    }
                }
                response.sendRedirect(request.getContextPath()
                        + "/MovieController?action=movieDetail&id=" + movieId + "&msg=deleted");
                return;

            } else if ("adminReviewList".equals(action)) {
                // Admin xem tất cả reviews
                if (currentUser != null && currentUser.isAdmin()) {
                    ArrayList<ReviewDTO> reviews = reviewDAO.listAll();
                    request.setAttribute("reviews", reviews);
                    url = "admin/reviews/list.jsp";
                } else {
                    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                    return;
                }

            } else if ("hideReview".equals(action)) {
                // Admin ẩn review
                if (currentUser != null && currentUser.isAdmin()) {
                    int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                    ReviewDTO review = reviewDAO.searchByID(reviewId);
                    if (review != null) {
                        review.setStatus("HIDDEN");
                        reviewDAO.update(review);
                    }
                    response.sendRedirect(request.getContextPath()
                            + "/ReviewController?action=adminReviewList&msg=hidden");
                    return;
                }

            } else if ("showReview".equals(action)) {
                // Admin hiện lại review
                if (currentUser != null && currentUser.isAdmin()) {
                    int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                    ReviewDTO review = reviewDAO.searchByID(reviewId);
                    if (review != null) {
                        review.setStatus("ACTIVE");
                        reviewDAO.update(review);
                    }
                    response.sendRedirect(request.getContextPath()
                            + "/ReviewController?action=adminReviewList&msg=shown");
                    return;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        } finally {
            if (!response.isCommitted())
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
