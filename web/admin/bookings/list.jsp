<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Quản lý đặt vé - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <h2 class="text-white mb-4"><i class="fas fa-ticket-alt text-danger me-2"></i>Quản lý đặt vé</h2>

        <c:if test="${param.msg == 'cancelled'}">
            <div class="alert alert-warning">Đã hủy đơn đặt vé.</div>
        </c:if>

        <div style="overflow-x:auto;">
            <table class="csn-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Mã vé</th>
                        <th>Khách hàng</th>
                        <th>Phim</th>
                        <th>Suất chiếu</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Ngày đặt</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookings}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td><span class="text-warning fw-bold">${b.bookingCode}</span></td>
                            <td>${b.user.fullName}</td>
                            <td>${b.showtime.movie.title}</td>
                            <td>
                                <fmt:formatDate value="${b.showtime.showDate}" pattern="dd/MM"/>
                                — ${b.showtime.startTime}
                            </td>
                            <td><fmt:formatNumber value="${b.finalAmount}" pattern="#,###"/>đ</td>
                            <td>
                                <span class="badge ${b.status == 'CONFIRMED' ? 'bg-success' : b.status == 'PENDING' ? 'bg-warning text-dark' : 'bg-secondary'}">
                                    ${b.status == 'CONFIRMED' ? 'Đã thanh toán' : b.status == 'PENDING' ? 'Chờ thanh toán' : 'Đã hủy'}
                                </span>
                            </td>
                            <td><fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <c:if test="${b.status == 'PENDING'}">
                                    <a href="${pageContext.request.contextPath}/BookingController?action=cancelBooking&bookingId=${b.bookingId}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Xác nhận hủy đơn này?')">
                                        <i class="fas fa-times"></i>
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bookings}">
                        <tr><td colspan="9" class="text-center text-muted py-4">Chưa có đơn đặt vé nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
