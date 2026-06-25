package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDTO;

/**
 * AuthorizationFilter — Kiểm tra role (ADMIN/USER) cho các URL bảo vệ.
 * Chặn truy cập admin pages nếu user không phải ADMIN.
 * 
 * @author TRI VY
 */
public class AuthorizationFilter implements Filter {

    /**
     * Danh sách các servlet/path chỉ ADMIN mới được truy cập.
     */
    private static final Set<String> ADMIN_PATHS = new HashSet<>(Arrays.asList(
            "/AdminController"
    ));

    /**
     * Danh sách action (parameter) chỉ ADMIN mới được dùng trong MainController.
     */
    private static final Set<String> ADMIN_ACTIONS = new HashSet<>(Arrays.asList(
            "adminDashboard",
            "adminMovies",
            "adminAddMovie",
            "adminEditMovie",
            "adminDeleteMovie"
    ));

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpRes = (HttpServletResponse) response;

        String contextPath = httpReq.getContextPath();
        String requestURI = httpReq.getRequestURI();
        String path = requestURI.substring(contextPath.length());

        // ── 1. Kiểm tra có phải admin path không ──
        boolean requiresAdmin = false;

        // Check direct admin paths
        if (ADMIN_PATHS.contains(path)) {
            requiresAdmin = true;
        }

        // Check admin paths dạng /admin/*
        if (path.startsWith("/admin/")) {
            requiresAdmin = true;
        }

        // Check admin actions trong MainController
        if ("/MainController".equals(path)) {
            String action = httpReq.getParameter("action");
            if (action != null && ADMIN_ACTIONS.contains(action)) {
                requiresAdmin = true;
            }
        }

        // ── 2. Nếu không cần admin → cho qua ──
        if (!requiresAdmin) {
            chain.doFilter(request, response);
            return;
        }

        // ── 3. Cần admin → kiểm tra role ──
        HttpSession session = httpReq.getSession(false);
        if (session != null) {
            UserDTO user = (UserDTO) session.getAttribute("loggedUser");
            if (user != null && (user.isAdmin() || user.isStaff())) {
                // User là ADMIN hoặc STAFF → cho qua
                chain.doFilter(request, response);
                return;
            }
        }

        // ── 4. Không có quyền → redirect về trang chủ ──
        httpReq.getSession(true).setAttribute("errorMessage", 
                "Bạn không có quyền truy cập trang này.");
        httpRes.sendRedirect(contextPath + "/HomeController");
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
