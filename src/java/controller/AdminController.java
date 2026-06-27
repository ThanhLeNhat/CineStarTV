/*
 * AdminController.java
 * CRUD Movies (Admin)
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

public class AdminController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "admin/dashboard.jsp";
        try {
            // Kiểm tra quyền admin
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=login");
                return;
            }
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (!user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                return;
            }

            String action = request.getParameter("action");
            MovieDAO movieDAO = new MovieDAO();
            GenreDAO genreDAO = new GenreDAO();
            UserDAO userDAO = new UserDAO();

            if ("movieList".equals(action)) {
                ArrayList<MovieDTO> movies = movieDAO.listAll();
                request.setAttribute("movies", movies);
                url = "admin/movies/list.jsp";

            } else if ("movieAdd".equals(action)) {
                request.setAttribute("genres", genreDAO.listAll());
                url = "admin/movies/form.jsp";

            } else if ("movieDoAdd".equals(action)) {
                MovieDTO movie = buildMovieFromRequest(request);
                movieDAO.add(movie);
                response.sendRedirect(request.getContextPath() + "/AdminController?action=movieList&msg=added");
                return;

            } else if ("movieEdit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("movie", movieDAO.searchByID(id));
                request.setAttribute("genres", genreDAO.listAll());
                url = "admin/movies/form.jsp";

            } else if ("movieDoEdit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("movieId"));
                MovieDTO movie = movieDAO.searchByID(id);
                updateMovieFromRequest(movie, request);
                movieDAO.update(movie);
                response.sendRedirect(request.getContextPath() + "/AdminController?action=movieList&msg=updated");
                return;

            } else if ("movieDelete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                MovieDTO movie = movieDAO.searchByID(id);
                movieDAO.remove(movie);
                response.sendRedirect(request.getContextPath() + "/AdminController?action=movieList&msg=deleted");
                return;

            } else {
                // Dashboard
                request.setAttribute("totalMovies", movieDAO.countAll());
                request.setAttribute("totalUsers", userDAO.countAll());
                url = "admin/dashboard.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private MovieDTO buildMovieFromRequest(HttpServletRequest request) {
        MovieDTO m = new MovieDTO();
        updateMovieFromRequest(m, request);
        return m;
    }

    private void updateMovieFromRequest(MovieDTO m, HttpServletRequest request) {
        m.setTitle(request.getParameter("title"));
        m.setTitleEn(request.getParameter("titleEn"));
        m.setDescription(request.getParameter("description"));
        m.setPosterUrl(request.getParameter("posterUrl"));
        m.setTrailerUrl(request.getParameter("trailerUrl"));
        m.setDirector(request.getParameter("director"));
        m.setActors(request.getParameter("actors"));
        m.setAgeRating(request.getParameter("ageRating"));
        m.setLanguage(request.getParameter("language"));
        m.setStatus(request.getParameter("status"));
        try { m.setDuration(Integer.parseInt(request.getParameter("duration"))); } catch (Exception ex) { m.setDuration(90); }
        try { m.setRating(Double.parseDouble(request.getParameter("rating"))); } catch (Exception ex) { m.setRating(0); }
        // Ngày chiếu
        try {
            String rd = request.getParameter("releaseDate");
            if (rd != null && !rd.isEmpty()) {
                m.setReleaseDate(new java.text.SimpleDateFormat("yyyy-MM-dd").parse(rd));
            }
        } catch (Exception ex) {}
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
