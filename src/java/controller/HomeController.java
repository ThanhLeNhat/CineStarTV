package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.*;

public class HomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "index.jsp";
        try {
            MovieDAO movieDAO = new MovieDAO();
            BlogPostDAO blogPostDAO = new BlogPostDAO();

            ArrayList<MovieDTO> nowShowing = movieDAO.listByStatus("NOW_SHOWING");
            ArrayList<MovieDTO> comingSoon = movieDAO.listByStatus("COMING_SOON");
            ArrayList<BlogPostDTO> latestBlogs = blogPostDAO.listPublished();

            request.setAttribute("nowShowing", nowShowing);
            request.setAttribute("comingSoon", comingSoon);
            request.setAttribute("latestBlogs", latestBlogs);
        } catch (Throwable e) {
            e.printStackTrace();
            // Set empty lists để trang không bị null pointer
            if (request.getAttribute("nowShowing") == null)
                request.setAttribute("nowShowing", new ArrayList<MovieDTO>());
            if (request.getAttribute("comingSoon") == null)
                request.setAttribute("comingSoon", new ArrayList<MovieDTO>());
            if (request.getAttribute("latestBlogs") == null)
                request.setAttribute("latestBlogs", new ArrayList<BlogPostDTO>());
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
