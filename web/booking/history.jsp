<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Lịch sử đặt vé - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <h2 class="text-white mb-4">
        <i class="fas fa-ticket-alt text-danger me-2"></i>Lịch sử đặt vé
    </h2>

    <c:if test="${param.msg == 'cancelled'}">
        <div class="alert alert-warning">Đã hủy đơn đặt vé.</div>
    </c:if>

    <c:choose>
        <c:when test="${not empty bookings}">
            <div class="row g-4">
                <c:forEach var="b" items="${bookings}">
                    <div class="col-md-6">
                        <div class="csn-form-card">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <span class="text-warning fw-bold">${b.bookingCode}</span>
                                    <div class="text-muted small">
                                        <fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                                <span class="badge ${b.status == 'CONFIRMED' ? 'bg-success' : b.status == 'PENDING' ? 'bg-warning text-dark' : 'bg-secondary'}">
                                    ${b.status == 'CONFIRMED' ? 'Đã thanh toán' : b.status == 'PENDING' ? 'Chờ thanh toán' : 'Đã hủy'}
                                </span>
                            </div>

                            <h5 class="text-white mb-1">${b.showtime.movie.title}</h5>
                            <p class="text-muted small mb-2">
                                <i class="fas fa-calendar me-1"></i>
                                <fmt:formatDate value="${b.showtime.showDate}" pattern="dd/MM/yyyy"/>
                                • ${b.showtime.startTime} — ${b.showtime.endTime}
                                <br>
                                <i class="fas fa-map-marker-alt me-1"></i>
                                ${b.showtime.screen.screenName} (${b.showtime.screen.screenType})
                            </p>

                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-danger fw-bold" style="font-size:1.1rem;">
                                    <fmt:formatNumber value="${b.finalAmount}" pattern="#,###"/>đ
                                </span>
                                <div>
                                    <c:if test="${b.status == 'PENDING'}">
                                        <a href="${pageContext.request.contextPath}/PaymentController?action=processPayment&bookingId=${b.bookingId}"
                                           class="btn btn-sm btn-danger me-1">
                                            <i class="fas fa-credit-card me-1"></i>Thanh toán
                                        </a>
                                        <a href="${pageContext.request.contextPath}/BookingController?action=cancelBooking&bookingId=${b.bookingId}"
                                           class="btn btn-sm btn-outline-secondary"
                                           onclick="return confirm('Xác nhận hủy đơn này?')">
                                            <i class="fas fa-times"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="csn-form-card text-center py-5">
                <i class="fas fa-ticket-alt text-muted" style="font-size:3rem;"></i>
                <p class="text-muted mt-3">Bạn chưa có đơn đặt vé nào.</p>
                <a href="${pageContext.request.contextPath}/MovieController" class="btn btn-danger mt-2">
                    <i class="fas fa-film me-2"></i>Xem phim ngay
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
