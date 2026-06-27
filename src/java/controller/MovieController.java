package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.*;

public class MovieController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "movie/list.jsp";
        try {
            String action = request.getParameter("action");
            MovieDAO movieDAO = new MovieDAO();
            GenreDAO genreDAO = new GenreDAO();

            if ("movieDetail".equals(action)) {
                // Chi tiết phim
                int movieId = Integer.parseInt(request.getParameter("id"));
                MovieDTO movie = movieDAO.searchByID(movieId);
                ReviewDAO reviewDAO = new ReviewDAO();
                ShowtimeDAO showtimeDAO = new ShowtimeDAO();

                ArrayList<ShowtimeDTO> showtimes = showtimeDAO.listByMovieId(movieId);
                ArrayList<ReviewDTO> reviews = reviewDAO.listByMovieId(movieId);
                double avgRating = reviewDAO.getAverageRating(movieId);

                request.setAttribute("movie", movie);
                request.setAttribute("showtimes", showtimes);
                request.setAttribute("reviews", reviews);
                request.setAttribute("avgRating", avgRating);
                url = "movie/detail.jsp";

            } else if ("searchMovie".equals(action)) {
                // Tìm kiếm phim
                String keyword = request.getParameter("keyword");
                ArrayList<MovieDTO> movies = movieDAO.searchByTitle(keyword);
                request.setAttribute("movies", movies);
                request.setAttribute("keyword", keyword);
                request.setAttribute("genres", genreDAO.listAll());

            } else {
                // Danh sách phim
                ArrayList<MovieDTO> movies = movieDAO.listAll();
                request.setAttribute("movies", movies);
                request.setAttribute("genres", genreDAO.listAll());
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
}
