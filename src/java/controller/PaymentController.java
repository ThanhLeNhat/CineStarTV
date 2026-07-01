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

            } else if ("vnpayCheckout".equals(action)) {
                // Tạo URL VNPay và redirect
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                BookingDAO bookingDAO = new BookingDAO();
                BookingDTO booking = bookingDAO.searchByID(bookingId);

                if (booking != null && booking.isPending()) {
                    String orderInfo = "Thanh toan ve xem phim - " + booking.getBookingCode();
                    String ipAddr = utils.VNPayUtil.getIpAddress(request);
                    String payUrl = utils.VNPayUtil.buildPaymentUrl(
                            bookingId, booking.getFinalAmount(), orderInfo, ipAddr);
                    response.sendRedirect(payUrl);
                    return;
                } else {
                    request.setAttribute("error", "Đơn đặt vé không hợp lệ.");
                    url = "booking/payment-result.jsp";
                }

            } else if ("vnpayReturn".equals(action)) {
                // VNPay callback sau thanh toán
                String vnpResponseCode = request.getParameter("vnp_ResponseCode");
                String vnpTxnRef       = request.getParameter("vnp_TxnRef");
                boolean valid = utils.VNPayUtil.verifySignature(request.getParameterMap());

                int bookingId = -1;
                if (vnpTxnRef != null && vnpTxnRef.contains("-")) {
                    try { bookingId = Integer.parseInt(vnpTxnRef.split("-")[0]); } catch (Exception ex) {}
                }

                BookingDAO bookingDAO = new BookingDAO();
                PaymentDAO paymentDAO = new PaymentDAO();
                BookingDTO booking = bookingId > 0 ? bookingDAO.searchByID(bookingId) : null;

                if (valid && "00".equals(vnpResponseCode) && booking != null && booking.isPending()) {
                    booking.setStatus("CONFIRMED");
                    bookingDAO.update(booking);

                    PaymentDTO payment = paymentDAO.searchByBookingId(bookingId);
                    if (payment != null) {
                        payment.setStatus("SUCCESS");
                        payment.setPaymentMethod("VNPAY");
                        payment.setTransactionId(request.getParameter("vnp_TransactionNo"));
                        payment.setVnpayResponseCode("00");
                        payment.setPaidAt(new Date());
                        paymentDAO.update(payment);
                    }

                    if (currentUser != null) {
                        NotificationDAO notifDAO = new NotificationDAO();
                        notifDAO.add(new NotificationDTO(currentUser,
                                "Thanh toán thành công!",
                                "Đơn " + booking.getBookingCode() + " đã thanh toán thành công qua VNPay.",
                                "PAYMENT"));
                    }

                    // Gửi email xác nhận SAU KHI thanh toán thành công
                    try {
                        String userEmail  = booking.getUser().getEmail();
                        String userName   = booking.getUser().getFullName();
                        String bCode      = booking.getBookingCode();
                        String movieTitle = booking.getShowtime().getMovie().getTitle();
                        java.text.SimpleDateFormat dateFmt = new java.text.SimpleDateFormat("dd/MM/yyyy");
                        String showDateStr = dateFmt.format(booking.getShowtime().getShowDate());
                        String showTimeStr = booking.getShowtime().getStartTime() + " — " + booking.getShowtime().getEndTime();
                        String cinemaName  = booking.getShowtime().getScreen().getCinema().getCinemaName();
                        String screenName  = booking.getShowtime().getScreen().getScreenName();

                        BookingDetailDAO detailDAO = new BookingDetailDAO();
                        java.util.ArrayList<BookingDetailDTO> details = detailDAO.listByBookingId(bookingId);
                        StringBuilder seatLabels = new StringBuilder();
                        for (BookingDetailDTO d : details) {
                            if (seatLabels.length() > 0) seatLabels.append(", ");
                            seatLabels.append(d.getSeatLabel());
                        }

                        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                        String amountStr = nf.format(booking.getFinalAmount());

                        utils.MailUtil.sendBookingConfirmation(userEmail, userName, bCode, movieTitle,
                                showDateStr, showTimeStr, cinemaName, screenName, seatLabels.toString(), amountStr);
                    } catch (Exception ex) {
                        System.err.println("[PaymentController] Email error: " + ex.getMessage());
                    }

                    request.setAttribute("booking", booking);
                    request.setAttribute("payment", paymentDAO.searchByBookingId(bookingId));
                    request.setAttribute("success", true);
                } else {
                    PaymentDTO failedPayment = null;
                    if (valid && booking != null && booking.isPending()) {
                        // Chữ ký hợp lệ nhưng user hủy hoặc ngân hàng từ chối → cập nhật DB
                        failedPayment = paymentDAO.searchByBookingId(bookingId);
                        if (failedPayment != null) {
                            failedPayment.setStatus("FAILED");
                            failedPayment.setPaymentMethod("VNPAY");
                            failedPayment.setVnpayResponseCode(vnpResponseCode != null ? vnpResponseCode : "99");
                            paymentDAO.update(failedPayment);
                        }
                        // Hủy booking để giải phóng ghế
                        booking.setStatus("CANCELLED");
                        bookingDAO.update(booking);

                        if (currentUser != null) {
                            NotificationDAO notifDAO = new NotificationDAO();
                            notifDAO.add(new NotificationDTO(currentUser,
                                    "Thanh toán thất bại",
                                    "Đơn " + booking.getBookingCode() + " đã bị hủy do thanh toán không thành công (mã: " + vnpResponseCode + ").",
                                    "PAYMENT"));
                        }
                        request.setAttribute("payment", failedPayment);
                    }
                    // Nếu chữ ký không hợp lệ → không đụng DB, chỉ báo lỗi
                    if (booking != null) request.setAttribute("booking", booking);
                    request.setAttribute("success", false);
                    request.setAttribute("error", "Thanh toán thất bại hoặc bị hủy (mã: " + vnpResponseCode + ")");
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
            // Không forward nếu response đã committed (ví dụ: sendRedirect trong vnpayCheckout)
            if (!response.isCommitted()) {
                request.getRequestDispatcher(url).forward(request, response);
            }
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
