package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * EncodingFilter — Đặt encoding UTF-8 cho mọi request/response.
 * Phải được đặt FIRST trong filter chain (web.xml).
 * 
 * @author TRI VY
 */
public class EncodingFilter implements Filter {

    private static final String ENCODING = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        // Set encoding cho request (form data, parameters)
        request.setCharacterEncoding(ENCODING);

        // Set encoding cho response (HTML output)
        response.setCharacterEncoding(ENCODING);
        response.setContentType("text/html;charset=UTF-8");

        // Tiếp tục filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
