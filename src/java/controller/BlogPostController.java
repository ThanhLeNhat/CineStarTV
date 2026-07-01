/*
 * BlogPostController.java
 * Public: xem danh sách + chi tiết blog
 * Admin: CRUD blog posts
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

public class BlogPostController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "blog/list.jsp";
        try {
            String action = request.getParameter("action");
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;
            BlogPostDAO blogDAO = new BlogPostDAO();

            // === PUBLIC ACTIONS ===
            if ("blogList".equals(action) || action == null) {
                String category = request.getParameter("category");
                ArrayList<BlogPostDTO> posts;
                if (category != null && !category.isEmpty()) {
                    posts = blogDAO.listByCategory(category);
                } else {
                    posts = blogDAO.listPublished();
                }
                request.setAttribute("posts", posts);
                request.setAttribute("selectedCategory", category);
                url = "blog/list.jsp";

            } else if ("blogDetail".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                BlogPostDTO post = blogDAO.searchByID(id);
                request.setAttribute("post", post);

                // Bài viết liên quan
                if (post != null) {
                    ArrayList<BlogPostDTO> related = blogDAO.listByCategory(post.getCategory());
                    related.removeIf(p -> p.getPostId() == post.getPostId());
                    request.setAttribute("relatedPosts", related);
                }
                url = "blog/detail.jsp";

            // === ADMIN ACTIONS ===
            } else if ("adminBlogList".equals(action)) {
                if (currentUser != null && currentUser.isAdmin()) {
                    ArrayList<BlogPostDTO> posts = blogDAO.listAll();
                    request.setAttribute("posts", posts);
                    url = "admin/blogs/list.jsp";
                } else {
                    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                    return;
                }

            } else if ("blogAdd".equals(action)) {
                if (currentUser != null && currentUser.isAdmin()) {
                    url = "admin/blogs/form.jsp";
                } else {
                    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                    return;
                }

            } else if ("blogDoAdd".equals(action)) {
                if (currentUser != null && currentUser.isAdmin()) {
                    BlogPostDTO post = buildPostFromRequest(request, currentUser);
                    blogDAO.add(post);
                    response.sendRedirect(request.getContextPath()
                            + "/BlogPostController?action=adminBlogList&msg=added");
                    return;
                }

            } else if ("blogEdit".equals(action)) {
                if (currentUser != null && currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("post", blogDAO.searchByID(id));
                    url = "admin/blogs/form.jsp";
                } else {
                    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                    return;
                }

            } else if ("blogDoEdit".equals(action)) {
                if (currentUser != null && currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("postId"));
                    BlogPostDTO post = blogDAO.searchByID(id);
                    if (post != null) {
                        updatePostFromRequest(post, request);
                        blogDAO.update(post);
                    }
                    response.sendRedirect(request.getContextPath()
                            + "/BlogPostController?action=adminBlogList&msg=updated");
                    return;
                }

            } else if ("blogDelete".equals(action)) {
                if (currentUser != null && currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    BlogPostDTO post = blogDAO.searchByID(id);
                    if (post != null) {
                        blogDAO.remove(post);
                    }
                    response.sendRedirect(request.getContextPath()
                            + "/BlogPostController?action=adminBlogList&msg=deleted");
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

    private BlogPostDTO buildPostFromRequest(HttpServletRequest request, UserDTO author) {
        BlogPostDTO post = new BlogPostDTO();
        post.setUser(author);
        updatePostFromRequest(post, request);
        return post;
    }

    private void updatePostFromRequest(BlogPostDTO post, HttpServletRequest request) {
        post.setTitle(request.getParameter("title"));
        post.setContent(request.getParameter("content"));
        post.setThumbnailUrl(request.getParameter("thumbnailUrl"));
        String category = request.getParameter("category");
        post.setCategory(category != null ? category : "NEWS");
        String status = request.getParameter("status");
        post.setStatus(status != null ? status : "PUBLISHED");
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
