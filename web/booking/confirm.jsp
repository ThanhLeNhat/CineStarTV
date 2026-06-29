<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Xác nhận đặt vé - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <h2 class="text-white mb-4">
        <i class="fas fa-check-circle text-danger me-2"></i>Xác nhận đặt vé
    </h2>

    <c:if test="${not empty booking}">
        <div class="row">
            <div class="col-md-8">
                <div class="csn-form-card mb-4">
                    <h5 class="text-white mb-3">Thông tin đặt vé</h5>
                    <table class="table table-dark table-borderless">
                        <tr>
                            <td class="text-muted">Mã đặt vé:</td>
                            <td class="text-warning fw-bold">${booking.bookingCode}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">Phim:</td>
                            <td class="text-white fw-bold">${showtime.movie.title}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">Suất chiếu:</td>
                            <td>
                                <fmt:formatDate value="${showtime.showDate}" pattern="dd/MM/yyyy"/>
                                • ${showtime.startTime} — ${showtime.endTime}
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Phòng chiếu:</td>
                            <td>${showtime.screen.screenName} (${showtime.screen.screenType})</td>
                        </tr>
                        <tr>
                            <td class="text-muted">Ghế:</td>
                            <td class="text-white">
                                <c:forEach var="seat" items="${selectedSeats}" varStatus="s">
                                    <span class="badge bg-secondary me-1">${seat.label}</span>
                                </c:forEach>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="col-md-4">
                <div class="csn-form-card">
                    <h5 class="text-white mb-3">Thanh toán</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Tổng tiền vé:</span>
                        <span class="text-white"><fmt:formatNumber value="${booking.totalAmount}" pattern="#,###"/>đ</span>
                    </div>
                    <c:if test="${booking.discountAmount > 0}">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Giảm giá:</span>
                            <span class="text-success">-<fmt:formatNumber value="${booking.discountAmount}" pattern="#,###"/>đ</span>
                        </div>
                    </c:if>
                    <hr style="border-color:#333;">
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-white fw-bold">Thành tiền:</span>
                        <span class="text-danger fw-bold" style="font-size:1.3rem;">
                            <fmt:formatNumber value="${booking.finalAmount}" pattern="#,###"/>đ
                        </span>
                    </div>
                    <a href="${pageContext.request.contextPath}/PaymentController?action=processPayment&bookingId=${booking.bookingId}"
                       class="btn btn-danger w-100 btn-lg">
                        <i class="fas fa-credit-card me-2"></i>Thanh toán ngay
                    </a>
                    <div class="text-center mt-2">
                        <a href="${pageContext.request.contextPath}/BookingController?action=bookingHistory"
                           class="text-muted small">Thanh toán sau →</a>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
