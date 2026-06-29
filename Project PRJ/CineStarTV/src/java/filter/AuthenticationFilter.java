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

/**
 * AuthenticationFilter — Kiểm tra user đã đăng nhập chưa.
 * Whitelist các URL public (login, register, static resources).
 * Nếu chưa login → redirect về /LoginController.
 * 
 * @author TRI VY
 */
public class AuthenticationFilter implements Filter {

    /**
     * Danh sách các servlet/path được phép truy cập mà KHÔNG cần đăng nhập.
     */
    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
            "/LoginController",
            "/RegisterController",
            "/LogoutController",
            "/HomeController",
            "/index.jsp",
            "/login.jsp",
            "/register.jsp",
            "/error.jsp"
    ));

    /**
     * Phần mở rộng của file tĩnh — luôn cho phép truy cập.
     */
    private static final Set<String> STATIC_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".svg",
            ".ico", ".woff", ".woff2", ".ttf", ".eot", ".map"
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
        // Lấy path relative (bỏ contextPath)
        String path = requestURI.substring(contextPath.length());

        // ── 1. Cho phép static resources (css, js, images, fonts) ──
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // ── 2. Cho phép các URL public (login, register, ...) ──
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // ── 3. Cho phép MainController với các action public ──
        if ("/MainController".equals(path)) {
            String action = httpReq.getParameter("action");
            if (action == null || "home".equals(action) 
                    || "login".equals(action) || "register".equals(action)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // ── 4. Kiểm tra session — đã đăng nhập chưa? ──
        HttpSession session = httpReq.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            // Đã login → cho qua
            chain.doFilter(request, response);
            return;
        }

        // ── 5. Chưa login → redirect về trang đăng nhập ──
        httpRes.sendRedirect(contextPath + "/LoginController");
    }

    /**
     * Kiểm tra path có phải là static resource không (dựa vào extension).
     */
    private boolean isStaticResource(String path) {
        if (path == null) return false;
        // Check folder paths cho static resources
        if (path.startsWith("/css/") || path.startsWith("/js/") 
                || path.startsWith("/images/") || path.startsWith("/fonts/")
                || path.startsWith("/assets/")) {
            return true;
        }
        // Check file extension
        String lowerPath = path.toLowerCase();
        for (String ext : STATIC_EXTENSIONS) {
            if (lowerPath.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Kiểm tra path có nằm trong whitelist không.
     */
    private boolean isPublicPath(String path) {
        if (path == null) return false;
        // Root path
        if ("/".equals(path) || path.isEmpty()) {
            return true;
        }
        return PUBLIC_PATHS.contains(path);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}