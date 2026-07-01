<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Thanh toán - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="csn-form-card text-center">
                <h3 class="text-white mb-4"><i class="fas fa-credit-card text-danger me-2"></i>Thanh toán</h3>

                <c:if test="${not empty booking}">
                    <div class="mb-3">
                        <p class="text-muted mb-1">Mã đặt vé</p>
                        <h4 class="text-warning">${booking.bookingCode}</h4>
                    </div>
                    <div class="mb-4">
                        <p class="text-muted mb-1">Số tiền thanh toán</p>
                        <h2 class="text-danger"><fmt:formatNumber value="${booking.finalAmount}" pattern="#,###"/>đ</h2>
                    </div>

                    <div class="mb-4 p-3 rounded d-flex align-items-center gap-3"
                         style="background:#222;border:2px solid #e50914;">
                        <i class="fas fa-shield-alt text-danger fa-2x"></i>
                        <div class="text-start">
                            <div class="text-white fw-bold">Thanh toán qua VNPay</div>
                            <div class="text-muted small">Bảo mật, nhanh chóng, an toàn</div>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/PaymentController?action=vnpayCheckout&bookingId=${booking.bookingId}"
                       class="btn btn-danger btn-lg w-100">
                        <i class="fas fa-lock me-2"></i>Thanh toán ngay
                    </a>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/BookingController?action=bookingHistory"
                           class="text-muted small">Thanh toán sau →</a>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3">${error}</div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
