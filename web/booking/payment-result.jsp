<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Kết quả thanh toán - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="csn-form-card text-center">
                <c:choose>
                    <c:when test="${success}">
                        <div class="mb-4">
                            <i class="fas fa-check-circle text-success" style="font-size:4rem;"></i>
                        </div>
                        <h3 class="text-success mb-3">Thanh toán thành công!</h3>
                        <p class="text-muted">Cảm ơn bạn đã đặt vé tại CineStarTV</p>

                        <c:if test="${not empty booking}">
                            <div class="csn-form-card mt-4 text-start" style="background:#111;">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Mã vé:</span>
                                    <span class="text-warning fw-bold">${booking.bookingCode}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Phim:</span>
                                    <span class="text-white">${booking.showtime.movie.title}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Suất chiếu:</span>
                                    <span class="text-white">
                                        <fmt:formatDate value="${booking.showtime.showDate}" pattern="dd/MM/yyyy"/>
                                        • ${booking.showtime.startTime}
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Số tiền:</span>
                                    <span class="text-danger fw-bold"><fmt:formatNumber value="${booking.finalAmount}" pattern="#,###"/>đ</span>
                                </div>
                                <c:if test="${not empty payment}">
                                    <div class="d-flex justify-content-between">
                                        <span class="text-muted">Mã giao dịch:</span>
                                        <span class="text-white">${payment.transactionId}</span>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="mb-4">
                            <i class="fas fa-times-circle text-danger" style="font-size:4rem;"></i>
                        </div>
                        <h3 class="text-danger mb-3">Thanh toán thất bại</h3>
                        <p class="text-muted">${not empty error ? error : 'Đã xảy ra lỗi. Vui lòng thử lại.'}</p>
                    </c:otherwise>
                </c:choose>

                <div class="mt-4 d-flex gap-2 justify-content-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/BookingController?action=bookingHistory" class="btn btn-outline-secondary">
                                <i class="fas fa-ticket-alt me-2"></i>Lịch sử vé
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/MainController?action=login" class="btn btn-outline-secondary">
                                <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập để xem vé
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/HomeController" class="btn btn-danger">
                        <i class="fas fa-home me-2"></i>Trang chủ
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
