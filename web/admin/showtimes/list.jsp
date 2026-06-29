<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% request.setAttribute("pageTitle", "Quản lý lịch chiếu - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-calendar-alt text-danger me-2"></i>Quản lý lịch chiếu</h2>
            <a href="${pageContext.request.contextPath}/ShowtimeController?action=showtimeAdd" class="btn btn-danger">
                <i class="fas fa-plus me-2"></i>Thêm lịch chiếu
            </a>
        </div>

        <c:if test="${param.msg == 'added'}"><div class="alert alert-success">Thêm lịch chiếu thành công!</div></c:if>
        <c:if test="${param.msg == 'deleted'}"><div class="alert alert-warning">Đã xóa lịch chiếu.</div></c:if>

        <div style="overflow-x:auto;">
            <table class="csn-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Phim</th>
                        <th>Rạp / Phòng</th>
                        <th>Ngày chiếu</th>
                        <th>Giờ chiếu</th>
                        <th>Giá vé</th>
                        <th>Ghế còn</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="st" items="${showtimes}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td class="text-white fw-semibold">${st.movie.title}</td>
                            <td>
                                <div>${st.screen.cinema.cinemaName}</div>
                                <small class="text-muted">${st.screen.screenName} (${st.screen.screenType})</small>
                            </td>
                            <td><fmt:formatDate value="${st.showDate}" pattern="dd/MM/yyyy"/></td>
                            <td>${st.startTime} — ${st.endTime}</td>
                            <td><fmt:formatNumber value="${st.basePrice}" pattern="#,###"/>đ</td>
                            <td>${st.availableSeats}</td>
                            <td>
                                <span class="badge ${st.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                    ${st.status == 'ACTIVE' ? 'Đang bán' : 'Đã đóng'}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/ShowtimeController?action=showtimeDelete&id=${st.showtimeId}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xác nhận xóa lịch chiếu này?')" title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty showtimes}">
                        <tr><td colspan="9" class="text-center text-muted py-4">Chưa có lịch chiếu nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
