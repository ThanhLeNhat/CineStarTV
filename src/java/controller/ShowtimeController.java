package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

/**
 * ShowtimeController — Quản lý lịch chiếu và ghế ngồi.
 *
 * Public actions (USER):
 *   - (default)        : Danh sách lịch chiếu hôm nay
 *   - showtimeByMovie  : Lịch chiếu theo phim
 *
 * Admin actions (ADMIN/STAFF):
 *   - showtimeList     : Danh sách lịch chiếu (admin)
 *   - showtimeAdd      : Form thêm lịch chiếu
 *   - showtimeDoAdd    : Xử lý thêm lịch chiếu [POST]
 *   - showtimeDelete   : Xoá lịch chiếu
 *   - seatList         : Danh sách ghế theo phòng
 *   - seatGenerate     : Tự động tạo ghế cho phòng [POST]
 *   - seatDelete       : Xoá ghế
 */
public class ShowtimeController extends HttpServlet {

    private static final java.util.Set<String> ADMIN_ACTIONS = new java.util.HashSet<>(
            java.util.Arrays.asList(
                    "showtimeList", "showtimeAdd", "showtimeDoAdd", "showtimeDelete",
                    "seatList", "seatGenerate", "seatDelete"
            )
    );

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "showtime/list.jsp";
        try {
            String action = request.getParameter("action");
            ShowtimeDAO showtimeDAO = new ShowtimeDAO();
            MovieDAO movieDAO = new MovieDAO();
            CinemaDAO cinemaDAO = new CinemaDAO();
            ScreenDAO screenDAO = new ScreenDAO();

            // Kiểm tra quyền cho admin actions
            if (action != null && ADMIN_ACTIONS.contains(action)) {
                if (!isAdminOrStaff(request)) {
                    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
                    return;
                }
            }

            // ── PUBLIC ACTIONS ────────────────────────────────────────────
            if ("showtimeByMovie".equals(action)) {
                int movieId = Integer.parseInt(request.getParameter("movieId"));
                MovieDTO movie = movieDAO.searchByID(movieId);
                if (movie == null) {
                    response.sendRedirect(request.getContextPath() + "/error/404.jsp");
                    return;
                }
                request.setAttribute("movie", movie);
                request.setAttribute("showtimes", showtimeDAO.listByMovieId(movieId));
                url = "showtime/by-movie.jsp";

            // ── ADMIN: SHOWTIME CRUD ──────────────────────────────────────
            } else if ("showtimeList".equals(action)) {
                request.setAttribute("showtimes", showtimeDAO.listAll());
                request.setAttribute("movies", movieDAO.listAll());
                request.setAttribute("msg", request.getParameter("msg"));
                url = "admin/showtimes/list.jsp";

            } else if ("showtimeAdd".equals(action)) {
                request.setAttribute("movies", movieDAO.listByStatus("NOW_SHOWING"));
                request.setAttribute("cinemas", cinemaDAO.listActive());
                url = "admin/showtimes/form.jsp";

            } else if ("showtimeDoAdd".equals(action)) {
                String movieIdStr   = request.getParameter("movieId");
                String screenIdStr  = request.getParameter("screenId");
                String showDateStr  = request.getParameter("showDate");
                String startTime    = request.getParameter("startTime");
                String basePriceStr = request.getParameter("basePrice");

                if (movieIdStr == null || screenIdStr == null
                        || showDateStr == null || startTime == null
                        || showDateStr.isEmpty() || startTime.isEmpty()) {
                    request.setAttribute("error", "Vui lòng điền đầy đủ thông tin lịch chiếu.");
                    request.setAttribute("movies", movieDAO.listByStatus("NOW_SHOWING"));
                    request.setAttribute("cinemas", cinemaDAO.listActive());
                    url = "admin/showtimes/form.jsp";
                } else {
                    MovieDTO movie   = movieDAO.searchByID(Integer.parseInt(movieIdStr));
                    ScreenDTO screen = screenDAO.searchByID(Integer.parseInt(screenIdStr));
                    Date showDate    = new SimpleDateFormat("yyyy-MM-dd").parse(showDateStr);

                    // Tính endTime từ startTime + duration phim
                    String endTime = calcEndTime(startTime, movie != null ? movie.getDuration() : 90);

                    ShowtimeDTO showtime = new ShowtimeDTO();
                    showtime.setMovie(movie);
                    showtime.setScreen(screen);
                    showtime.setShowDate(showDate);
                    showtime.setStartTime(startTime);
                    showtime.setEndTime(endTime);
                    showtime.setStatus("ACTIVE");
                    try {
                        showtime.setBasePrice(Long.parseLong(basePriceStr));
                    } catch (NumberFormatException ex) {
                        showtime.setBasePrice(75000);
                    }
                    // availableSeats = sức chứa phòng
                    if (screen != null) {
                        showtime.setAvailableSeats(screen.getCapacity());
                    }
                    showtimeDAO.add(showtime);
                    response.sendRedirect(request.getContextPath()
                            + "/ShowtimeController?action=showtimeList&msg=added");
                    return;
                }

            } else if ("showtimeDelete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                ShowtimeDTO showtime = showtimeDAO.searchByID(id);
                if (showtime != null) {
                    showtimeDAO.remove(showtime);
                }
                response.sendRedirect(request.getContextPath()
                        + "/ShowtimeController?action=showtimeList&msg=deleted");
                return;

            // ── ADMIN: SEAT MANAGEMENT ────────────────────────────────────
            } else if ("seatList".equals(action)) {
                int screenId = Integer.parseInt(request.getParameter("screenId"));
                ScreenDTO screen = screenDAO.searchByID(screenId);
                if (screen == null) {
                    response.sendRedirect(request.getContextPath()
                            + "/CinemaController?action=cinemaList");
                    return;
                }
                SeatDAO seatDAO = new SeatDAO();
                request.setAttribute("screen", screen);
                request.setAttribute("seats", seatDAO.listByScreenId(screenId));
                request.setAttribute("msg", request.getParameter("msg"));
                url = "admin/showtimes/seats.jsp";

            } else if ("seatGenerate".equals(action)) {
                // Tự động tạo ghế theo rows x cols
                int screenId = Integer.parseInt(request.getParameter("screenId"));
                ScreenDTO screen = screenDAO.searchByID(screenId);
                int rows = Integer.parseInt(request.getParameter("rows"));
                int cols = Integer.parseInt(request.getParameter("cols"));

                SeatDAO seatDAO = new SeatDAO();
                ArrayList<SeatDTO> seats = new ArrayList<>();
                String[] rowLabels = {"A","B","C","D","E","F","G","H","I","J","K","L"};
                for (int r = 0; r < rows && r < rowLabels.length; r++) {
                    for (int c = 1; c <= cols; c++) {
                        SeatDTO seat = new SeatDTO();
                        seat.setScreen(screen);
                        seat.setSeatRow(rowLabels[r]);
                        seat.setSeatNumber(c);
                        // Hàng cuối là VIP
                        seat.setSeatType(r == rows - 1 ? "VIP" : "STANDARD");
                        seat.setStatus("ACTIVE");
                        seats.add(seat);
                    }
                }
                seatDAO.addBulk(seats);
                response.sendRedirect(request.getContextPath()
                        + "/ShowtimeController?action=seatList&screenId=" + screenId + "&msg=generated");
                return;

            } else if ("seatDelete".equals(action)) {
                int seatId   = Integer.parseInt(request.getParameter("id"));
                int screenId = Integer.parseInt(request.getParameter("screenId"));
                SeatDAO seatDAO = new SeatDAO();
                SeatDTO seat = seatDAO.searchByID(seatId);
                if (seat != null) {
                    seatDAO.remove(seat);
                }
                response.sendRedirect(request.getContextPath()
                        + "/ShowtimeController?action=seatList&screenId=" + screenId + "&msg=deleted");
                return;

            } else {
                // Mặc định: lịch chiếu hôm nay
                request.setAttribute("showtimes", showtimeDAO.listAll());
                request.setAttribute("movies", movieDAO.listByStatus("NOW_SHOWING"));
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/error/404.jsp");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại.");
        } finally {
            if (!response.isCommitted()) {
                request.getRequestDispatcher(url).forward(request, response);
            }
        }
    }

    /**
     * Tính giờ kết thúc từ giờ bắt đầu + thời lượng phim (phút).
     * Ví dụ: startTime="19:30", duration=120 → "21:30"
     */
    private String calcEndTime(String startTime, int durationMinutes) {
        try {
            String[] parts = startTime.split(":");
            int h = Integer.parseInt(parts[0]);
            int m = Integer.parseInt(parts[1]);
            int totalMinutes = h * 60 + m + durationMinutes;
            return String.format("%02d:%02d", (totalMinutes / 60) % 24, totalMinutes % 60);
        } catch (Exception e) {
            return startTime;
        }
    }

    private boolean isAdminOrStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        UserDTO user = (UserDTO) session.getAttribute("user");
        return user != null && (user.isAdmin() || user.isStaff());
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
