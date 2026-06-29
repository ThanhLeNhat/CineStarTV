package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

/**
 * CinemaController — Quản lý rạp chiếu và phòng chiếu.
 *
 * Public actions (USER):
 *   - (default)      : Danh sách rạp
 *   - cinemaDetail   : Chi tiết rạp + danh sách phòng
 *
 * Admin actions (ADMIN/STAFF):
 *   - cinemaList     : Danh sách rạp (admin)
 *   - cinemaAdd      : Form thêm rạp
 *   - cinemaDoAdd    : Xử lý thêm rạp [POST]
 *   - cinemaEdit     : Form sửa rạp
 *   - cinemaDoEdit   : Xử lý sửa rạp [POST]
 *   - cinemaDelete   : Xoá rạp [POST]
 *   - screenList     : Danh sách phòng theo rạp
 *   - screenDoAdd    : Thêm phòng chiếu [POST]
 *   - screenDelete   : Xoá phòng chiếu [POST]
 */
public class CinemaController extends HttpServlet {

    private static final java.util.Set<String> ADMIN_ACTIONS = new java.util.HashSet<>(
            java.util.Arrays.asList(
                    "cinemaList", "cinemaAdd", "cinemaDoAdd",
                    "cinemaEdit", "cinemaDoEdit", "cinemaDelete",
                    "screenList", "screenDoAdd", "screenDelete"
            )
    );

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "cinema/list.jsp";
        try {
            String action = request.getParameter("action");
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
            if ("cinemaDetail".equals(action)) {
                int cinemaId = Integer.parseInt(request.getParameter("id"));
                CinemaDTO cinema = cinemaDAO.searchByID(cinemaId);
                if (cinema == null) {
                    response.sendRedirect(request.getContextPath() + "/error/404.jsp");
                    return;
                }
                request.setAttribute("cinema", cinema);
                request.setAttribute("screens", screenDAO.listByCinemaId(cinemaId));
                url = "cinema/detail.jsp";

            // ── AJAX: Trả về danh sách phòng theo rạp (JSON) ─────────────
            } else if ("screenListJson".equals(action)) {
                int cinemaId = Integer.parseInt(request.getParameter("cinemaId"));
                ArrayList<ScreenDTO> screens = screenDAO.listByCinemaId(cinemaId);
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < screens.size(); i++) {
                    ScreenDTO s = screens.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"screenId\":").append(s.getScreenId()).append(",")
                        .append("\"screenName\":\"").append(s.getScreenName()).append("\",")
                        .append("\"screenType\":\"").append(s.getScreenType()).append("\",")
                        .append("\"capacity\":").append(s.getCapacity())
                        .append("}");
                }
                json.append("]");
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(json.toString());
                return;

            // ── ADMIN: CINEMA CRUD ────────────────────────────────────────
            } else if ("cinemaList".equals(action)) {
                request.setAttribute("cinemas", cinemaDAO.listAll());
                request.setAttribute("msg", request.getParameter("msg"));
                url = "admin/cinemas/list.jsp";

            } else if ("cinemaAdd".equals(action)) {
                url = "admin/cinemas/form.jsp";

            } else if ("cinemaDoAdd".equals(action)) {
                CinemaDTO cinema = buildCinemaFromRequest(request);
                if (cinema.getCinemaName() == null || cinema.getCinemaName().trim().isEmpty()) {
                    request.setAttribute("error", "Tên rạp không được để trống.");
                    url = "admin/cinemas/form.jsp";
                } else {
                    cinemaDAO.add(cinema);
                    response.sendRedirect(request.getContextPath()
                            + "/CinemaController?action=cinemaList&msg=added");
                    return;
                }

            } else if ("cinemaEdit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                CinemaDTO cinema = cinemaDAO.searchByID(id);
                if (cinema == null) {
                    response.sendRedirect(request.getContextPath()
                            + "/CinemaController?action=cinemaList&msg=notfound");
                    return;
                }
                request.setAttribute("cinema", cinema);
                url = "admin/cinemas/form.jsp";

            } else if ("cinemaDoEdit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("cinemaId"));
                CinemaDTO cinema = cinemaDAO.searchByID(id);
                if (cinema == null) {
                    response.sendRedirect(request.getContextPath()
                            + "/CinemaController?action=cinemaList&msg=notfound");
                    return;
                }
                updateCinemaFromRequest(cinema, request);
                cinemaDAO.update(cinema);
                response.sendRedirect(request.getContextPath()
                        + "/CinemaController?action=cinemaList&msg=updated");
                return;

            } else if ("cinemaDelete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                CinemaDTO cinema = cinemaDAO.searchByID(id);
                if (cinema != null) {
                    cinemaDAO.remove(cinema);
                }
                response.sendRedirect(request.getContextPath()
                        + "/CinemaController?action=cinemaList&msg=deleted");
                return;

            // ── ADMIN: SCREEN CRUD ────────────────────────────────────────
            } else if ("screenList".equals(action)) {
                int cinemaId = Integer.parseInt(request.getParameter("cinemaId"));
                CinemaDTO cinema = cinemaDAO.searchByID(cinemaId);
                if (cinema == null) {
                    response.sendRedirect(request.getContextPath()
                            + "/CinemaController?action=cinemaList");
                    return;
                }
                request.setAttribute("cinema", cinema);
                request.setAttribute("screens", screenDAO.listByCinemaId(cinemaId));
                request.setAttribute("msg", request.getParameter("msg"));
                url = "admin/cinemas/screens.jsp";

            } else if ("screenDoAdd".equals(action)) {
                int cinemaId = Integer.parseInt(request.getParameter("cinemaId"));
                CinemaDTO cinema = cinemaDAO.searchByID(cinemaId);
                if (cinema == null) {
                    response.sendRedirect(request.getContextPath()
                            + "/CinemaController?action=cinemaList");
                    return;
                }
                String screenName = request.getParameter("screenName");
                if (screenName == null || screenName.trim().isEmpty()) {
                    request.setAttribute("error", "Tên phòng không được để trống.");
                    request.setAttribute("cinema", cinema);
                    request.setAttribute("screens", screenDAO.listByCinemaId(cinemaId));
                    url = "admin/cinemas/screens.jsp";
                } else {
                    ScreenDTO screen = new ScreenDTO();
                    screen.setCinema(cinema);
                    screen.setScreenName(screenName.trim());
                    screen.setScreenType(request.getParameter("screenType"));
                    try {
                        screen.setCapacity(Integer.parseInt(request.getParameter("capacity")));
                    } catch (NumberFormatException ex) {
                        screen.setCapacity(100);
                    }
                    screen.setStatus("ACTIVE");
                    screenDAO.add(screen);
                    response.sendRedirect(request.getContextPath()
                            + "/CinemaController?action=screenList&cinemaId=" + cinemaId + "&msg=added");
                    return;
                }

            } else if ("screenDelete".equals(action)) {
                int screenId = Integer.parseInt(request.getParameter("id"));
                int cinemaId = Integer.parseInt(request.getParameter("cinemaId"));
                ScreenDTO screen = screenDAO.searchByID(screenId);
                if (screen != null) {
                    screenDAO.remove(screen);
                }
                response.sendRedirect(request.getContextPath()
                        + "/CinemaController?action=screenList&cinemaId=" + cinemaId + "&msg=deleted");
                return;

            } else {
                // Mặc định: danh sách rạp public
                request.setAttribute("cinemas", cinemaDAO.listActive());
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

    private boolean isAdminOrStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        UserDTO user = (UserDTO) session.getAttribute("user");
        return user != null && (user.isAdmin() || user.isStaff());
    }

    private CinemaDTO buildCinemaFromRequest(HttpServletRequest request) {
        CinemaDTO c = new CinemaDTO();
        updateCinemaFromRequest(c, request);
        return c;
    }

    private void updateCinemaFromRequest(CinemaDTO c, HttpServletRequest request) {
        c.setCinemaName(request.getParameter("cinemaName"));
        c.setAddress(request.getParameter("address"));
        c.setCity(request.getParameter("city"));
        c.setPhone(request.getParameter("phone"));
        c.setImageUrl(request.getParameter("imageUrl"));
        c.setDescription(request.getParameter("description"));
        String status = request.getParameter("status");
        c.setStatus(status != null ? status : "ACTIVE");
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
