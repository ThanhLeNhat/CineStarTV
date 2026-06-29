<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% request.setAttribute("pageTitle", "Thêm lịch chiếu - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex align-items-center gap-3 mb-4">
            <a href="${pageContext.request.contextPath}/ShowtimeController?action=showtimeList"
               class="btn btn-outline-secondary btn-sm"><i class="fas fa-arrow-left"></i></a>
            <h2 class="text-white mb-0">
                <i class="fas fa-calendar-plus text-danger me-2"></i>Thêm lịch chiếu
            </h2>
        </div>

        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

        <div class="csn-form-card" style="max-width:650px;">
            <form action="${pageContext.request.contextPath}/ShowtimeController" method="post">
                <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                <input type="hidden" name="action" value="showtimeDoAdd">

                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label">Phim *</label>
                        <select name="movieId" class="form-select" required id="movieSelect">
                            <option value="">-- Chọn phim --</option>
                            <c:forEach var="movie" items="${movies}">
                                <option value="${movie.movieId}" data-duration="${movie.duration}">
                                    ${movie.title} (${movie.durationFormatted})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Rạp *</label>
                        <select name="cinemaId" class="form-select" id="cinemaSelect" required>
                            <option value="">-- Chọn rạp --</option>
                            <c:forEach var="cinema" items="${cinemas}">
                                <option value="${cinema.cinemaId}">${cinema.cinemaName} — ${cinema.city}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Phòng chiếu *</label>
                        <select name="screenId" class="form-select" id="screenSelect" required>
                            <option value="">-- Chọn rạp trước --</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Ngày chiếu *</label>
                        <input type="date" name="showDate" class="form-control" required
                               min="${pageContext.request.getAttribute('today')}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Giờ bắt đầu *</label>
                        <input type="time" name="startTime" class="form-control" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Giá vé cơ bản (VNĐ)</label>
                        <input type="number" name="basePrice" class="form-control"
                               min="0" step="5000" value="75000">
                    </div>
                    <div class="col-12 d-flex gap-3 mt-2">
                        <button type="submit" class="btn btn-danger px-5">
                            <i class="fas fa-save me-2"></i>Thêm lịch chiếu
                        </button>
                        <a href="${pageContext.request.contextPath}/ShowtimeController?action=showtimeList"
                           class="btn btn-outline-secondary px-4">Hủy</a>
                    </div>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
// Load danh sách phòng theo rạp được chọn (AJAX)
document.getElementById('cinemaSelect').addEventListener('change', function () {
    const cinemaId = this.value;
    const screenSelect = document.getElementById('screenSelect');
    screenSelect.innerHTML = '<option value="">Đang tải...</option>';
    if (!cinemaId) {
        screenSelect.innerHTML = '<option value="">-- Chọn rạp trước --</option>';
        return;
    }
    fetch('${pageContext.request.contextPath}/CinemaController?action=screenListJson&cinemaId=' + cinemaId)
        .then(r => r.json())
        .then(screens => {
            screenSelect.innerHTML = '<option value="">-- Chọn phòng --</option>';
            screens.forEach(s => {
                screenSelect.innerHTML += '<option value="' + s.screenId + '">'
                    + s.screenName + ' (' + s.screenType + ' — ' + s.capacity + ' ghế)</option>';
            });
        })
        .catch(() => {
            screenSelect.innerHTML = '<option value="">Lỗi tải phòng chiếu</option>';
        });
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
