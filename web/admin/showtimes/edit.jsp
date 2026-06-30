<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% request.setAttribute("pageTitle", "Sửa lịch chiếu - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex align-items-center gap-3 mb-4">
            <a href="${pageContext.request.contextPath}/ShowtimeController?action=showtimeList"
               class="btn btn-outline-secondary btn-sm"><i class="fas fa-arrow-left"></i></a>
            <h2 class="text-white mb-0">
                <i class="fas fa-calendar-edit text-danger me-2"></i>Sửa lịch chiếu
            </h2>
        </div>

        <div class="csn-form-card" style="max-width:600px;">
            <%-- Thông tin cố định --%>
            <div class="mb-4 p-3 rounded" style="background:#111;border:1px solid #2a2a2a;">
                <p class="text-muted small mb-1">Phim</p>
                <p class="text-white fw-bold mb-2">${showtime.movie.title}</p>
                <p class="text-muted small mb-1">Rạp / Phòng</p>
                <p class="text-white mb-0">${showtime.screen.cinema.cinemaName} — ${showtime.screen.screenName} (${showtime.screen.screenType})</p>
            </div>

            <form action="${pageContext.request.contextPath}/ShowtimeController" method="post">
                <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                <input type="hidden" name="action" value="showtimeDoEdit">
                <input type="hidden" name="showtimeId" value="${showtime.showtimeId}">

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Ngày chiếu *</label>
                        <input type="date" name="showDate" class="form-control" required
                               value="<fmt:formatDate value='${showtime.showDate}' pattern='yyyy-MM-dd'/>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Giờ bắt đầu *</label>
                        <input type="time" name="startTime" class="form-control" required
                               value="${showtime.startTime}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Giá vé (VNĐ)</label>
                        <input type="number" name="basePrice" class="form-control"
                               min="0" step="5000" value="${showtime.basePrice}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE"    ${showtime.status == 'ACTIVE'    ? 'selected' : ''}>Đang bán</option>
                            <option value="CANCELLED" ${showtime.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                            <option value="FULL"      ${showtime.status == 'FULL'      ? 'selected' : ''}>Hết vé</option>
                        </select>
                    </div>
                    <div class="col-12 d-flex gap-3 mt-2">
                        <button type="submit" class="btn btn-danger px-5">
                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/ShowtimeController?action=showtimeList"
                           class="btn btn-outline-secondary px-4">Hủy</a>
                    </div>
                </div>
            </form>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
