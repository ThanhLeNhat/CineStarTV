/*
 * BookingController.java
 * Đặt vé: chọn suất chiếu → chọn ghế → xác nhận
 * Yêu cầu đăng nhập (AuthenticationFilter)
 */
package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

public class BookingController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "booking/select-showtime.jsp";
        try {
            String action = request.getParameter("action");
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;

            if ("selectShowtime".equals(action)) {
                // Bước 1: Chọn suất chiếu cho 1 phim
                int movieId = Integer.parseInt(request.getParameter("movieId"));
                MovieDAO movieDAO = new MovieDAO();
                ShowtimeDAO showtimeDAO = new ShowtimeDAO();

                MovieDTO movie = movieDAO.searchByID(movieId);
                ArrayList<ShowtimeDTO> showtimes = showtimeDAO.listByMovieId(movieId);

                request.setAttribute("movie", movie);
                request.setAttribute("showtimes", showtimes);
                url = "booking/select-showtime.jsp";

            } else if ("selectSeat".equals(action)) {
                // Bước 2: Hiển thị sơ đồ ghế
                int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
                ShowtimeDAO showtimeDAO = new ShowtimeDAO();
                SeatDAO seatDAO = new SeatDAO();

                ShowtimeDTO showtime = showtimeDAO.searchByID(showtimeId);
                if (showtime == null) {
                    request.setAttribute("error", "Suất chiếu không tồn tại.");
                    url = "error/404.jsp";
                } else {
                    int screenId = showtime.getScreen().getScreenId();
                    ArrayList<SeatDTO> seats = seatDAO.listByScreenId(screenId);
                    ArrayList<Integer> bookedSeatIds = seatDAO.listBookedSeatIds(showtimeId);

                    // Đánh dấu ghế đã đặt
                    for (SeatDTO seat : seats) {
                        seat.setBooked(bookedSeatIds.contains(seat.getSeatId()));
                    }

                    request.setAttribute("showtime", showtime);
                    request.setAttribute("seats", seats);
                    url = "booking/select-seat.jsp";
                }

            } else if ("confirmBooking".equals(action)) {
                // Bước 3: Xác nhận đặt vé
                int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
                String[] seatIds = request.getParameterValues("seatIds");

                if (seatIds == null || seatIds.length == 0) {
                    request.setAttribute("error", "Vui lòng chọn ít nhất 1 ghế.");
                    // Redirect lại trang chọn ghế
                    response.sendRedirect(request.getContextPath()
                            + "/BookingController?action=selectSeat&showtimeId=" + showtimeId);
                    return;
                }

                ShowtimeDAO showtimeDAO = new ShowtimeDAO();
                SeatDAO seatDAO = new SeatDAO();
                BookingDAO bookingDAO = new BookingDAO();
                BookingDetailDAO detailDAO = new BookingDetailDAO();
                VoucherDAO voucherDAO = new VoucherDAO();

                ShowtimeDTO showtime = showtimeDAO.searchByID(showtimeId);

                // Tính tổng tiền
                long totalAmount = 0;
                ArrayList<SeatDTO> selectedSeats = new ArrayList<>();
                for (String sid : seatIds) {
                    SeatDTO seat = seatDAO.searchByID(Integer.parseInt(sid));
                    if (seat != null) {
                        selectedSeats.add(seat);
                        long seatPrice = (long) (showtime.getBasePrice() * seat.getPriceMultiplier());
                        totalAmount += seatPrice;
                    }
                }

                // Xử lý voucher nếu có
                String voucherCode = request.getParameter("voucherCode");
                long discountAmount = 0;
                VoucherDTO voucher = null;
                if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                    voucher = voucherDAO.searchByCode(voucherCode.trim());
                    if (voucher != null && voucher.isValid()) {
                        discountAmount = voucher.calculateDiscount(totalAmount);
                    }
                }

                long finalAmount = totalAmount - discountAmount;

                // Tạo booking
                BookingDTO booking = new BookingDTO();
                booking.setUser(currentUser);
                booking.setShowtime(showtime);
                booking.setVoucher(voucher);
                booking.setTotalAmount(totalAmount);
                booking.setDiscountAmount(discountAmount);
                booking.setFinalAmount(finalAmount);
                booking.setBookingCode(bookingDAO.generateBookingCode());
                booking.setStatus("PENDING");

                bookingDAO.add(booking);

                // Tạo booking details
                for (SeatDTO seat : selectedSeats) {
                    long seatPrice = (long) (showtime.getBasePrice() * seat.getPriceMultiplier());
                    BookingDetailDTO detail = new BookingDetailDTO(booking, seat, seatPrice, seat.getLabel());
                    detailDAO.add(detail);
                }

                // Cập nhật usedCount voucher
                if (voucher != null && discountAmount > 0) {
                    voucherDAO.incrementUsedCount(voucher.getVoucherId());
                }

                // Tạo payment
                PaymentDAO paymentDAO = new PaymentDAO();
                PaymentDTO payment = new PaymentDTO();
                payment.setBooking(booking);
                payment.setAmount(finalAmount);
                payment.setPaymentMethod("VNPAY");
                payment.setStatus("PENDING");
                paymentDAO.add(payment);

                // Gửi thông báo cho user
                NotificationDAO notifDAO = new NotificationDAO();
                NotificationDTO notif = new NotificationDTO(
                        currentUser,
                        "Đặt vé thành công!",
                        "Mã đặt vé: " + booking.getBookingCode() + ". Vui lòng thanh toán để hoàn tất.",
                        "BOOKING"
                );
                notifDAO.add(notif);

                request.setAttribute("booking", booking);
                request.setAttribute("selectedSeats", selectedSeats);
                request.setAttribute("showtime", showtime);
                url = "booking/confirm.jsp";

            } else if ("bookingHistory".equals(action)) {
                // Lịch sử đặt vé của user
                if (currentUser != null) {
                    BookingDAO bookingDAO = new BookingDAO();
                    ArrayList<BookingDTO> bookings = bookingDAO.listByUserId(currentUser.getUserId());
                    request.setAttribute("bookings", bookings);
                }
                url = "booking/history.jsp";

            } else if ("adminBookingList".equals(action)) {
                // Admin xem tất cả bookings
                if (currentUser != null && currentUser.isAdmin()) {
                    BookingDAO bookingDAO = new BookingDAO();
                    ArrayList<BookingDTO> bookings = bookingDAO.listAll();
                    request.setAttribute("bookings", bookings);
                    url = "admin/bookings/list.jsp";
                } else {
                    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                    return;
                }

            } else if ("cancelBooking".equals(action)) {
                // Hủy booking (user hoặc admin)
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                BookingDAO bookingDAO = new BookingDAO();
                BookingDTO booking = bookingDAO.searchByID(bookingId);
                if (booking != null && booking.isPending()) {
                    if (currentUser.isAdmin() || booking.getUser().getUserId() == currentUser.getUserId()) {
                        booking.setStatus("CANCELLED");
                        bookingDAO.update(booking);
                    }
                }
                if (currentUser.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/BookingController?action=adminBookingList&msg=cancelled");
                } else {
                    response.sendRedirect(request.getContextPath() + "/BookingController?action=bookingHistory&msg=cancelled");
                }
                return;
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
