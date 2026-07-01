package utils;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class MailUtil {

    private static final String FROM_EMAIL = "nguyentrivy20012006@gmail.com";
    private static final String APP_PASSWORD = "bciysqnvyqntvckj";

    private static Session createSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            "smtp.gmail.com");
        props.put("mail.smtp.port",            "587");
        props.put("mail.smtp.ssl.trust",       "smtp.gmail.com");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });
    }

    /**
     * Gửi email xác nhận đặt vé
     */
    public static void sendBookingConfirmation(String toEmail, String fullName,
            String bookingCode, String movieTitle,
            String showDate, String showTime,
            String cinemaName, String screenName,
            String seats, String finalAmount) {
        new Thread(() -> {
            try {
                Session session = createSession();
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(FROM_EMAIL, "CineStarTV", "UTF-8"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("[CineStarTV] Xác nhận đặt vé - " + bookingCode, "UTF-8");

                String html = buildBookingEmail(fullName, bookingCode, movieTitle,
                        showDate, showTime, cinemaName, screenName, seats, finalAmount);
                message.setContent(html, "text/html; charset=UTF-8");
                Transport.send(message);
                System.out.println("[MailUtil] Sent booking confirmation to " + toEmail);
            } catch (Exception e) {
                System.err.println("[MailUtil] Failed to send email: " + e.getMessage());
            }
        }).start();
    }

    /**
     * Gửi email thông báo đổi mật khẩu thành công
     */
    public static void sendPasswordChanged(String toEmail, String fullName) {
        new Thread(() -> {
            try {
                Session session = createSession();
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(FROM_EMAIL, "CineStarTV", "UTF-8"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("[CineStarTV] Mật khẩu của bạn vừa được thay đổi", "UTF-8");

                String html = "<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;background:#111;color:#f0f0f0;padding:30px;border-radius:10px;'>"
                        + "<h1 style='color:#e50914;'>🎬 CineStarTV</h1>"
                        + "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                        + "<p>Mật khẩu tài khoản của bạn vừa được thay đổi thành công.</p>"
                        + "<p style='color:#aaa;'>Nếu bạn không thực hiện thao tác này, vui lòng liên hệ hỗ trợ ngay lập tức.</p>"
                        + "<p style='margin-top:30px;color:#555;font-size:12px;'>© CineStarTV — Email tự động, vui lòng không reply.</p>"
                        + "</div>";
                message.setContent(html, "text/html; charset=UTF-8");
                Transport.send(message);
                System.out.println("[MailUtil] Sent password-changed email to " + toEmail);
            } catch (Exception e) {
                System.err.println("[MailUtil] Failed to send password-changed email: " + e.getMessage());
            }
        }).start();
    }

    /**
     * Gửi email chào mừng sau đăng ký
     */
    public static void sendWelcome(String toEmail, String fullName) {
        new Thread(() -> {
            try {
                Session session = createSession();
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(FROM_EMAIL, "CineStarTV", "UTF-8"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("[CineStarTV] Chào mừng bạn đến với CineStarTV!", "UTF-8");

                String html = "<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;background:#111;color:#f0f0f0;padding:30px;border-radius:10px;'>"
                        + "<h1 style='color:#e50914;'>🎬 CineStarTV</h1>"
                        + "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                        + "<p>Chào mừng bạn đã đăng ký tài khoản CineStarTV!</p>"
                        + "<p>Bây giờ bạn có thể đặt vé xem phim, đánh giá phim yêu thích và nhận nhiều ưu đãi hấp dẫn.</p>"
                        + "<a href='http://localhost:8080/CineStarTV' style='display:inline-block;margin-top:20px;padding:12px 24px;background:#e50914;color:#fff;border-radius:6px;text-decoration:none;font-weight:bold;'>Khám phá ngay</a>"
                        + "<p style='margin-top:30px;color:#888;font-size:12px;'>CineStarTV — Trải nghiệm điện ảnh đỉnh cao</p>"
                        + "</div>";
                message.setContent(html, "text/html; charset=UTF-8");
                Transport.send(message);
                System.out.println("[MailUtil] Sent welcome email to " + toEmail);
            } catch (Exception e) {
                System.err.println("[MailUtil] Failed to send welcome email: " + e.getMessage());
            }
        }).start();
    }

    private static String buildBookingEmail(String fullName, String bookingCode,
            String movieTitle, String showDate, String showTime,
            String cinemaName, String screenName, String seats, String finalAmount) {
        return "<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;background:#111;color:#f0f0f0;padding:30px;border-radius:10px;'>"
                + "<h1 style='color:#e50914;margin-bottom:4px;'>🎬 CineStarTV</h1>"
                + "<p style='color:#888;margin-top:0;'>Xác nhận đặt vé thành công</p>"
                + "<hr style='border-color:#333;'>"
                + "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                + "<p>Đơn đặt vé của bạn đã được ghi nhận. Chi tiết như sau:</p>"
                + "<div style='background:#1a1a1a;border-radius:8px;padding:20px;margin:20px 0;'>"
                + "  <table style='width:100%;border-collapse:collapse;'>"
                + "    <tr><td style='color:#888;padding:6px 0;'>Mã đặt vé</td>"
                + "        <td style='color:#ffc107;font-weight:bold;'>" + bookingCode + "</td></tr>"
                + "    <tr><td style='color:#888;padding:6px 0;'>Phim</td>"
                + "        <td style='color:#fff;font-weight:bold;'>" + movieTitle + "</td></tr>"
                + "    <tr><td style='color:#888;padding:6px 0;'>Ngày chiếu</td>"
                + "        <td style='color:#fff;'>" + showDate + "</td></tr>"
                + "    <tr><td style='color:#888;padding:6px 0;'>Giờ chiếu</td>"
                + "        <td style='color:#fff;'>" + showTime + "</td></tr>"
                + "    <tr><td style='color:#888;padding:6px 0;'>Rạp</td>"
                + "        <td style='color:#fff;'>" + cinemaName + "</td></tr>"
                + "    <tr><td style='color:#888;padding:6px 0;'>Phòng</td>"
                + "        <td style='color:#fff;'>" + screenName + "</td></tr>"
                + "    <tr><td style='color:#888;padding:6px 0;'>Ghế</td>"
                + "        <td style='color:#fff;'>" + seats + "</td></tr>"
                + "    <tr><td style='color:#888;padding:6px 0;border-top:1px solid #333;padding-top:12px;'>Tổng thanh toán</td>"
                + "        <td style='color:#e50914;font-weight:bold;font-size:1.2em;border-top:1px solid #333;padding-top:12px;'>" + finalAmount + "đ</td></tr>"
                + "  </table>"
                + "</div>"
                + "<p style='color:#aaa;'>Vui lòng đến rạp trước <strong>15 phút</strong> và xuất trình mã đặt vé khi vào cổng.</p>"
                + "<p style='margin-top:30px;color:#555;font-size:12px;'>© CineStarTV — Email tự động, vui lòng không reply.</p>"
                + "</div>";
    }
}
