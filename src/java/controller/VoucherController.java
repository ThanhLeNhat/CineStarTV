/*
 * VoucherController.java
 * CRUD Voucher (Admin) + Apply Voucher (User)
 */
package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

public class VoucherController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "admin/vouchers/list.jsp";
        try {
            String action = request.getParameter("action");
            HttpSession session = request.getSession(false);
            UserDTO currentUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;
            VoucherDAO voucherDAO = new VoucherDAO();

            // === USER ACTION: áp dụng voucher (AJAX-style) ===
            if ("applyVoucher".equals(action)) {
                String code = request.getParameter("voucherCode");
                long orderAmount = 0;
                try { orderAmount = Long.parseLong(request.getParameter("orderAmount")); } catch (Exception ex) {}

                VoucherDTO voucher = voucherDAO.searchByCode(code);
                if (voucher == null) {
                    request.setAttribute("voucherError", "Mã voucher không tồn tại.");
                } else if (!voucher.isValid()) {
                    request.setAttribute("voucherError", "Voucher đã hết hạn hoặc hết lượt sử dụng.");
                } else if (orderAmount < voucher.getMinOrder()) {
                    request.setAttribute("voucherError", "Đơn hàng tối thiểu " + String.format("%,d", voucher.getMinOrder()) + "đ.");
                } else {
                    long discount = voucher.calculateDiscount(orderAmount);
                    request.setAttribute("voucherSuccess", "Giảm " + String.format("%,d", discount) + "đ");
                    request.setAttribute("discountAmount", discount);
                    request.setAttribute("appliedVoucher", voucher);
                }
                // Trả về trang trước đó (booking confirm)
                String returnUrl = request.getParameter("returnUrl");
                if (returnUrl != null && !returnUrl.isEmpty()) {
                    url = returnUrl;
                }
                return; // Sẽ được xử lý ở trang booking

            // === ADMIN ACTIONS ===
            } else if ("voucherAdd".equals(action)) {
                url = "admin/vouchers/form.jsp";

            } else if ("voucherDoAdd".equals(action)) {
                VoucherDTO voucher = buildVoucherFromRequest(request);
                voucherDAO.add(voucher);
                response.sendRedirect(request.getContextPath() + "/VoucherController?action=voucherList&msg=added");
                return;

            } else if ("voucherEdit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("voucher", voucherDAO.searchByID(id));
                url = "admin/vouchers/form.jsp";

            } else if ("voucherDoEdit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("voucherId"));
                VoucherDTO voucher = voucherDAO.searchByID(id);
                if (voucher != null) {
                    updateVoucherFromRequest(voucher, request);
                    voucherDAO.update(voucher);
                }
                response.sendRedirect(request.getContextPath() + "/VoucherController?action=voucherList&msg=updated");
                return;

            } else if ("voucherDisable".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                VoucherDTO voucher = voucherDAO.searchByID(id);
                if (voucher != null) {
                    voucherDAO.remove(voucher);
                }
                response.sendRedirect(request.getContextPath() + "/VoucherController?action=voucherList&msg=disabled");
                return;

            } else {
                // voucherList — mặc định
                ArrayList<VoucherDTO> vouchers = voucherDAO.listAll();
                request.setAttribute("vouchers", vouchers);
                url = "admin/vouchers/list.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private VoucherDTO buildVoucherFromRequest(HttpServletRequest request) {
        VoucherDTO v = new VoucherDTO();
        updateVoucherFromRequest(v, request);
        return v;
    }

    private void updateVoucherFromRequest(VoucherDTO v, HttpServletRequest request) {
        v.setCode(request.getParameter("code").toUpperCase().trim());
        try { v.setDiscountPercent(Integer.parseInt(request.getParameter("discountPercent"))); } catch (Exception e) { v.setDiscountPercent(0); }
        try { v.setDiscountAmount(Long.parseLong(request.getParameter("discountAmount"))); } catch (Exception e) { v.setDiscountAmount(0); }
        try { v.setMaxDiscount(Long.parseLong(request.getParameter("maxDiscount"))); } catch (Exception e) {}
        try { v.setMinOrder(Long.parseLong(request.getParameter("minOrder"))); } catch (Exception e) { v.setMinOrder(0); }
        try { v.setQuantity(Integer.parseInt(request.getParameter("quantity"))); } catch (Exception e) { v.setQuantity(100); }
        v.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "ACTIVE");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try { v.setStartDate(sdf.parse(request.getParameter("startDate"))); } catch (Exception e) {}
        try { v.setEndDate(sdf.parse(request.getParameter("endDate"))); } catch (Exception e) {}
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
