package utils;

import java.security.SecureRandom;
import java.util.Base64;
import javax.servlet.http.HttpSession;

/**
 * SecurityUtils — Tiện ích bảo mật cho CSRF token.
 * Sử dụng SecureRandom + Base64 để tạo token an toàn.
 * 
 * @author TRI VY
 */
public class SecurityUtils {

    private static final String CSRF_TOKEN_ATTR = "csrfToken";
    private static final int TOKEN_LENGTH = 32; // 32 bytes = 256 bits
    private static final SecureRandom secureRandom = new SecureRandom();

    /**
     * Tạo CSRF token mới (32 bytes, Base64 encoded).
     * @return Token string
     */
    public static String generateToken() {
        byte[] bytes = new byte[TOKEN_LENGTH];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /**
     * Lấy CSRF token từ session. Nếu chưa có → tạo mới.
     * @param session HttpSession
     * @return CSRF token
     */
    public static String getOrCreateToken(HttpSession session) {
        String token = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        if (token == null || token.isEmpty()) {
            token = generateToken();
            session.setAttribute(CSRF_TOKEN_ATTR, token);
        }
        return token;
    }

    /**
     * Tạo token mới và ghi đè vào session (dùng sau khi validate thành công).
     * @param session HttpSession
     * @return Token mới
     */
    public static String refreshToken(HttpSession session) {
        String token = generateToken();
        session.setAttribute(CSRF_TOKEN_ATTR, token);
        return token;
    }

    /**
     * Validate CSRF token từ form so với token trong session.
     * @param session HttpSession
     * @param formToken Token gửi từ form (parameter "_csrf")
     * @return true nếu token khớp
     */
    public static boolean validateToken(HttpSession session, String formToken) {
        if (session == null || formToken == null || formToken.isEmpty()) {
            return false;
        }
        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        if (sessionToken == null || sessionToken.isEmpty()) {
            return false;
        }
        return sessionToken.equals(formToken);
    }
}
