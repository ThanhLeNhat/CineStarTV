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
                    <div class="mb-4">
                        <p class="text-muted mb-1">Mã đặt vé</p>
                        <h4 class="text-warning">${booking.bookingCode}</h4>
                    </div>
                    <div class="mb-4">
                        <p class="text-muted mb-1">Số tiền thanh toán</p>
                        <h2 class="text-danger"><fmt:formatNumber value="${booking.finalAmount}" pattern="#,###"/>đ</h2>
                    </div>

                    <form action="${pageContext.request.contextPath}/PaymentController" method="POST">
                        <input type="hidden" name="action" value="doPayment"/>
                        <input type="hidden" name="bookingId" value="${booking.bookingId}"/>

                        <div class="mb-4">
                            <label class="form-label text-muted">Phương thức thanh toán</label>
                            <div class="d-flex flex-column gap-2">
                                <label class="d-flex align-items-center gap-3 p-3 rounded" style="background:#222;border:1px solid #333;cursor:pointer;">
                                    <input type="radio" name="paymentMethod" value="VNPAY" checked/>
                                    <i class="fas fa-wallet text-info"></i>
                                    <span class="text-white">VNPay</span>
                                </label>
                                <label class="d-flex align-items-center gap-3 p-3 rounded" style="background:#222;border:1px solid #333;cursor:pointer;">
                                    <input type="radio" name="paymentMethod" value="MOMO"/>
                                    <i class="fas fa-mobile-alt text-danger"></i>
                                    <span class="text-white">MoMo</span>
                                </label>
                                <label class="d-flex align-items-center gap-3 p-3 rounded" style="background:#222;border:1px solid #333;cursor:pointer;">
                                    <input type="radio" name="paymentMethod" value="BANK_TRANSFER"/>
                                    <i class="fas fa-university text-success"></i>
                                    <span class="text-white">Chuyển khoản ngân hàng</span>
                                </label>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-danger btn-lg w-100"
                                onclick="return confirm('Xác nhận thanh toán?')">
                            <i class="fas fa-lock me-2"></i>Xác nhận thanh toán
                        </button>
                    </form>
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
