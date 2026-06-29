package utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * BCrypt password hashing utility
 */
public class PasswordUtil {

    // Hash password
    public static String hash(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(10));
    }

    // Verify password
    public static boolean verify(String password, String hash) {
        return BCrypt.checkpw(password, hash);
    }
}
