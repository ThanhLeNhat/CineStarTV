/*
 * PaymentController.java
 * Thanh toán — simulate payment (không tích hợp VNPay thực tế)
 * Yêu cầu đăng nhập
 */
package controller;

import java.io.IOException;
import java.util.Date;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

public class PaymentController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "booking/payment.jsp";
        try {
            String action = request.getParameter("action");
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;

            if ("processPayment".equals(action)) {
                // Hiển thị trang thanh toán
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                BookingDAO bookingDAO = new BookingDAO();
                BookingDTO booking = bookingDAO.searchByID(bookingId);

                if (booking == null) {
                    request.setAttribute("error", "Không tìm thấy đơn đặt vé.");
                    url = "error/404.jsp";
                } else if (!booking.isPending()) {
                    request.setAttribute("error", "Đơn đặt vé đã được xử lý.");
                    request.setAttribute("booking", booking);
                    url = "booking/payment-result.jsp";
                } else {
                    request.setAttribute("booking", booking);
                    url = "booking/payment.jsp";
                }

            } else if ("doPayment".equals(action)) {
                // Simulate thanh toán thành công
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String paymentMethod = request.getParameter("paymentMethod");
                if (paymentMethod == null || paymentMethod.isEmpty()) {
                    paymentMethod = "VNPAY";
                }

                BookingDAO bookingDAO = new BookingDAO();
                PaymentDAO paymentDAO = new PaymentDAO();
                BookingDTO booking = bookingDAO.searchByID(bookingId);

                if (booking != null && booking.isPending()) {
                    // Cập nhật booking status
                    booking.setStatus("CONFIRMED");
                    bookingDAO.update(booking);

                    // Cập nhật payment
                    PaymentDTO payment = paymentDAO.searchByBookingId(bookingId);
                    if (payment != null) {
                        payment.setStatus("SUCCESS");
                        payment.setPaymentMethod(paymentMethod);
                        payment.setTransactionId("TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                        payment.setVnpayResponseCode("00");
                        payment.setPaidAt(new Date());
                        paymentDAO.update(payment);
                    }

                    // Gửi thông báo
                    NotificationDAO notifDAO = new NotificationDAO();
                    NotificationDTO notif = new NotificationDTO(
                            currentUser,
                            "Thanh toán thành công!",
                            "Đơn " + booking.getBookingCode() + " đã thanh toán "
                            + String.format("%,d", booking.getFinalAmount()) + "đ. Chúc bạn xem phim vui vẻ!",
                            "PAYMENT"
                    );
                    notifDAO.add(notif);

                    request.setAttribute("booking", booking);
                    request.setAttribute("payment", payment);
                    request.setAttribute("success", true);
                } else {
                    request.setAttribute("success", false);
                    request.setAttribute("error", "Không thể thanh toán đơn này.");
                }
                url = "booking/payment-result.jsp";

            } else if ("paymentResult".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                BookingDAO bookingDAO = new BookingDAO();
                PaymentDAO paymentDAO = new PaymentDAO();
                BookingDTO booking = bookingDAO.searchByID(bookingId);
                PaymentDTO payment = paymentDAO.searchByBookingId(bookingId);
                request.setAttribute("booking", booking);
                request.setAttribute("payment", payment);
                request.setAttribute("success", booking != null && booking.isConfirmed());
                url = "booking/payment-result.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
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
