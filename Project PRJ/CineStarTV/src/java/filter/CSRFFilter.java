package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utils.SecurityUtils;

/**
 * CSRFFilter — Bảo vệ chống Cross-Site Request Forgery.
 * - GET requests: tự động tạo/refresh CSRF token vào session
 * - POST requests: validate token từ hidden field "_csrf"
 * 
 * Sử dụng trong form JSP:
 *   <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
 * 
 * @author TRI VY
 */
public class CSRFFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpRes = (HttpServletResponse) response;

        String method = httpReq.getMethod();

        // ── GET request → đảm bảo có CSRF token trong session ──
        if ("GET".equalsIgnoreCase(method)) {
            HttpSession session = httpReq.getSession(true);
            SecurityUtils.getOrCreateToken(session);
            chain.doFilter(request, response);
            return;
        }

        // ── POST request → validate CSRF token ──
        if ("POST".equalsIgnoreCase(method)) {
            HttpSession session = httpReq.getSession(false);

            // Nếu chưa có session → không có token → block
            if (session == null) {
                httpRes.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Phiên làm việc hết hạn. Vui lòng tải lại trang.");
                return;
            }

            String formToken = httpReq.getParameter("_csrf");
            
            // Validate token
            if (SecurityUtils.validateToken(session, formToken)) {
                // Token hợp lệ → tạo token mới (one-time use) và cho qua
                SecurityUtils.refreshToken(session);
                chain.doFilter(request, response);
            } else {
                // Token không hợp lệ → 403 Forbidden
                httpRes.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "CSRF token không hợp lệ. Vui lòng tải lại trang.");
            }
            return;
        }

        // ── Các method khác (PUT, DELETE...) → cho qua ──
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
