package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.*;
import utils.ImageUtils;

@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 5 * 1024 * 1024)
public class MovieController extends HttpServlet {

    private static final java.util.Set<String> ADMIN_ACTIONS = new java.util.HashSet<>(
            java.util.Arrays.asList(
                    "movieList", "movieAdd", "movieDoAdd",
                    "movieEdit", "movieDoEdit", "movieDelete",
                    "genreList", "genreDoAdd", "genreDelete"
            )
    );

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "movie/list.jsp";
        try {
            String action = request.getParameter("action");
            MovieDAO movieDAO = new MovieDAO();
            GenreDAO genreDAO = new GenreDAO();
            MovieGenreDAO movieGenreDAO = new MovieGenreDAO();

            if (action != null && ADMIN_ACTIONS.contains(action)) {
                if (!isAdminOrStaff(request)) {
                    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                    return;
                }
            }

            if ("movieDetail".equals(action)) {
                int movieId = Integer.parseInt(request.getParameter("id"));
                MovieDTO movie = movieDAO.searchByID(movieId);
                if (movie == null) {
                    response.sendRedirect(request.getContextPath() + "/error/404.jsp");
                    return;
                }
                ReviewDAO reviewDAO = new ReviewDAO();
                ShowtimeDAO showtimeDAO = new ShowtimeDAO();
                request.setAttribute("movie", movie);
                request.setAttribute("reviews", reviewDAO.listByMovieId(movieId));
                request.setAttribute("showtimes", showtimeDAO.listByMovieId(movieId));
                request.setAttribute("genres", movieGenreDAO.listGenresByMovieId(movieId));
                url = "movie/detail.jsp";

            } else if ("searchMovie".equals(action)) {
                String keyword = request.getParameter("keyword");
                String genreIdStr = request.getParameter("genreId");
                ArrayList<MovieDTO> movies;
                if (keyword != null && !keyword.trim().isEmpty()) {
                    movies = movieDAO.searchByTitle(keyword.trim());
                } else if (genreIdStr != null && !genreIdStr.isEmpty()) {
                    movies = movieDAO.listByGenreId(Integer.parseInt(genreIdStr));
                } else {
                    movies = movieDAO.listAll();
                }
                request.setAttribute("movies", movies);
                request.setAttribute("genres", genreDAO.listAll());
                request.setAttribute("keyword", keyword);
                request.setAttribute("selectedGenreId", genreIdStr);
                url = "movie/list.jsp";

            } else if ("movieList".equals(action)) {
                request.setAttribute("movies", movieDAO.listAll());
                request.setAttribute("msg", request.getParameter("msg"));
                url = "admin/movies/list.jsp";

            } else if ("movieAdd".equals(action)) {
                request.setAttribute("genres", genreDAO.listAll());
                url = "admin/movies/form.jsp";

            } else if ("movieDoAdd".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String trailerUrl = request.getParameter("trailerUrl");
                String durationStr = request.getParameter("duration");
                String releaseDate = request.getParameter("releaseDate");
                String status = request.getParameter("status");
                String genreIdStr = request.getParameter("genreId");

                if (title == null || title.trim().isEmpty()) {
                    request.setAttribute("error", "Ten phim khong duoc de trong.");
                    request.setAttribute("genres", genreDAO.listAll());
                    url = "admin/movies/form.jsp";
                } else {
                    MovieDTO movie = new MovieDTO();
                    movie.setTitle(title.trim());
                    movie.setDescription(description);
                    movie.setTrailerUrl(trailerUrl);
                    movie.setStatus(status != null ? status : "COMING_SOON");
                    try { movie.setDuration(Integer.parseInt(durationStr)); }
                    catch (NumberFormatException ex) { movie.setDuration(90); }
                    if (releaseDate != null && !releaseDate.isEmpty()) {
                        try { movie.setReleaseDate(new java.text.SimpleDateFormat("yyyy-MM-dd").parse(releaseDate)); }
                        catch (Exception ex) {}
                    }
                    try {
                        Part posterPart = request.getPart("posterFile");
                        if (ImageUtils.hasFile(posterPart)) {
                            movie.setPosterUrl(ImageUtils.saveImage(posterPart, "posters"));
                        }
                    } catch (IllegalArgumentException ex) {
                        request.setAttribute("error", ex.getMessage());
                        request.setAttribute("genres", genreDAO.listAll());
                        url = "admin/movies/form.jsp";
                        return;
                    }
                    movieDAO.add(movie);
                    if (genreIdStr != null && !genreIdStr.isEmpty()) {
                        try {
                            MovieGenreDTO mg = new MovieGenreDTO();
                            mg.setMovieId(movie.getMovieId());
                            mg.setGenreId(Integer.parseInt(genreIdStr));
                            movieGenreDAO.add(mg);
                        } catch (NumberFormatException ex) {}
                    }
                    response.sendRedirect(request.getContextPath() + "/MovieController?action=movieList&msg=added");
                    return;
                }

            } else if ("movieEdit".equals(action)) {
                int movieId = Integer.parseInt(request.getParameter("id"));
                MovieDTO movie = movieDAO.searchByID(movieId);
                if (movie == null) {
                    response.sendRedirect(request.getContextPath() + "/error/404.jsp");
                    return;
                }
                request.setAttribute("movie", movie);
                request.setAttribute("genres", genreDAO.listAll());
                request.setAttribute("movieGenres", movieGenreDAO.listByMovieId(movieId));
                url = "admin/movies/form.jsp";

            } else if ("movieDoEdit".equals(action)) {
                int movieId = Integer.parseInt(request.getParameter("movieId"));
                MovieDTO movie = movieDAO.searchByID(movieId);
                if (movie == null) {
                    response.sendRedirect(request.getContextPath() + "/error/404.jsp");
                    return;
                }
                String title = request.getParameter("title");
                if (title == null || title.trim().isEmpty()) {
                    request.setAttribute("error", "Ten phim khong duoc de trong.");
                    request.setAttribute("movie", movie);
                    request.setAttribute("genres", genreDAO.listAll());
                    url = "admin/movies/form.jsp";
                } else {
                    movie.setTitle(title.trim());
                    movie.setDescription(request.getParameter("description"));
                    movie.setTrailerUrl(request.getParameter("trailerUrl"));
                    movie.setStatus(request.getParameter("status"));
                    try { movie.setDuration(Integer.parseInt(request.getParameter("duration"))); }
                    catch (NumberFormatException ex) {}
                    String releaseDate = request.getParameter("releaseDate");
                    if (releaseDate != null && !releaseDate.isEmpty()) {
                        try { movie.setReleaseDate(new java.text.SimpleDateFormat("yyyy-MM-dd").parse(releaseDate)); }
                        catch (Exception ex) {}
                    }
                    try {
                        Part posterPart = request.getPart("posterFile");
                        if (ImageUtils.hasFile(posterPart)) {
                            movie.setPosterUrl(ImageUtils.saveImage(posterPart, "posters"));
                        }
                    } catch (IllegalArgumentException ex) {
                        request.setAttribute("error", ex.getMessage());
                        request.setAttribute("movie", movie);
                        request.setAttribute("genres", genreDAO.listAll());
                        url = "admin/movies/form.jsp";
                        return;
                    }
                    movieDAO.update(movie);
                    String genreIdStr = request.getParameter("genreId");
                    if (genreIdStr != null && !genreIdStr.isEmpty()) {
                        try {
                            movieGenreDAO.removeAllByMovieId(movieId);
                            MovieGenreDTO mg = new MovieGenreDTO();
                            mg.setMovieId(movieId);
                            mg.setGenreId(Integer.parseInt(genreIdStr));
                            movieGenreDAO.add(mg);
                        } catch (NumberFormatException ex) {}
                    }
                    response.sendRedirect(request.getContextPath() + "/MovieController?action=movieList&msg=updated");
                    return;
                }

            } else if ("movieDelete".equals(action)) {
                int movieId = Integer.parseInt(request.getParameter("id"));
                MovieDTO movie = movieDAO.searchByID(movieId);
                if (movie != null) {
                    movieGenreDAO.removeAllByMovieId(movieId);
                    movieDAO.remove(movie);
                }
                response.sendRedirect(request.getContextPath() + "/MovieController?action=movieList&msg=deleted");
                return;

            } else if ("genreList".equals(action)) {
                request.setAttribute("genres", genreDAO.listAll());
                request.setAttribute("msg", request.getParameter("msg"));
                url = "admin/movies/genres.jsp";

            } else if ("genreDoAdd".equals(action)) {
                String genreName = request.getParameter("genreName");
                if (genreName != null && !genreName.trim().isEmpty()) {
                    GenreDTO genre = new GenreDTO();
                    genre.setGenreName(genreName.trim());
                    genreDAO.add(genre);
                }
                response.sendRedirect(request.getContextPath() + "/MovieController?action=genreList&msg=added");
                return;

            } else if ("genreDelete".equals(action)) {
                int genreId = Integer.parseInt(request.getParameter("id"));
                GenreDTO genre = genreDAO.searchByID(genreId);
                if (genre != null) {
                    genreDAO.remove(genre);
                }
                response.sendRedirect(request.getContextPath() + "/MovieController?action=genreList&msg=deleted");
                return;

            } else {
                // Lọc theo status nếu có (tab Đang chiếu / Sắp chiếu)
                String status = request.getParameter("status");
                java.util.ArrayList<MovieDTO> movies;
                if ("NOW_SHOWING".equals(status)) {
                    movies = movieDAO.listByStatus("NOW_SHOWING");
                } else if ("COMING_SOON".equals(status)) {
                    movies = movieDAO.listByStatus("COMING_SOON");
                } else {
                    movies = movieDAO.listAll();
                }
                request.setAttribute("movies", movies);
                request.setAttribute("genres", genreDAO.listAll());
                request.setAttribute("currentStatus", status);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/error/404.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Da xay ra loi. Vui long thu lai.");
        } finally {
            if (!response.isCommitted()) {
                request.getRequestDispatcher(url).forward(request, response);
            }
        }
    }

    private boolean isAdminOrStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        UserDTO user = (UserDTO) session.getAttribute("user");
        return user != null && (user.isAdmin() || user.isStaff());
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
