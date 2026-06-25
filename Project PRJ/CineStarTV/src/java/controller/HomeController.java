package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.MovieDAO;
import model.MovieDTO;

/**
 * HomeController — Load dữ liệu phim cho trang chủ.
 * - Phim đang chiếu (NOW_SHOWING)
 * - Phim sắp chiếu (COMING_SOON)
 * Forward đến index.jsp
 * 
 * @author TRI VY
 */
public class HomeController extends HttpServlet {

    private final MovieDAO movieDAO = new MovieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            // Load phim đang chiếu
            ArrayList<MovieDTO> nowShowing = movieDAO.listNowShowing();
            request.setAttribute("nowShowing", nowShowing);

            // Load phim sắp chiếu
            ArrayList<MovieDTO> comingSoon = movieDAO.listComingSoon();
            request.setAttribute("comingSoon", comingSoon);

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi DB → vẫn forward với list rỗng
            request.setAttribute("nowShowing", new ArrayList<>());
            request.setAttribute("comingSoon", new ArrayList<>());
        }

        // Forward đến trang chủ
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "HomeController - Load movie data for homepage";
    }
}
