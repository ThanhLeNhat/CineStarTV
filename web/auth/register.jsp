<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty sessionScope.user}">
    <c:redirect url="/HomeController"/>
</c:if>

<% request.setAttribute("pageTitle", "Đăng ký - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>

<div class="auth-page">
    <div class="auth-card" style="max-width:480px;">
        <div class="logo"><i class="fas fa-film"></i> CineStarTV</div>
        <h2>Tạo tài khoản</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-csn mb-3">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
            </div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-csn mb-3">
                <i class="fas fa-check-circle me-2"></i>${success}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/RegisterController" method="post" id="regForm" novalidate>
            <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
            <div class="mb-3">
                <label class="form-label text-secondary">Họ và tên <span class="text-danger">*</span></label>
                <input type="text" name="fullName" class="form-control bg-dark border-secondary text-light"
                       placeholder="Nguyễn Văn A" required minlength="3"
                       value="${not empty param.fullName ? param.fullName : ''}">
                <div class="invalid-feedback">Vui lòng nhập họ tên (ít nhất 3 ký tự).</div>
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary">Email <span class="text-danger">*</span></label>
                <input type="email" name="email" class="form-control bg-dark border-secondary text-light"
                       placeholder="example@gmail.com" required
                       value="${not empty param.email ? param.email : ''}">
                <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary">Số điện thoại</label>
                <input type="tel" name="phone" class="form-control bg-dark border-secondary text-light"
                       placeholder="0901234567" pattern="[0-9]{10,11}"
                       value="${not empty param.phone ? param.phone : ''}">
                <div class="invalid-feedback">Số điện thoại phải có 10-11 chữ số.</div>
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary">Mật khẩu <span class="text-danger">*</span></label>
                <input type="password" name="password" id="password"
                       class="form-control bg-dark border-secondary text-light"
                       placeholder="Ít nhất 6 ký tự" required minlength="6">
                <div class="invalid-feedback">Mật khẩu phải có ít nhất 6 ký tự.</div>
            </div>
            <div class="mb-4">
                <label class="form-label text-secondary">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                <input type="password" id="confirmPassword"
                       class="form-control bg-dark border-secondary text-light"
                       placeholder="Nhập lại mật khẩu" required>
                <div class="invalid-feedback">Mật khẩu xác nhận không khớp.</div>
            </div>
            <button type="submit" class="btn btn-csn-red w-100 py-2">
                <i class="fas fa-user-plus me-2"></i>Đăng ký
            </button>
        </form>

        <hr class="border-secondary my-4">
        <p class="text-center text-secondary mb-0">
            Đã có tài khoản?
            <a href="${pageContext.request.contextPath}/MainController?action=login" class="text-danger fw-bold">Đăng nhập</a>
        </p>
    </div>
</div>

<script>
document.getElementById('regForm').addEventListener('submit', function(e) {
    var pw = document.getElementById('password').value;
    var cf = document.getElementById('confirmPassword').value;
    if (pw !== cf) {
        document.getElementById('confirmPassword').setCustomValidity('Mật khẩu không khớp');
    } else {
        document.getElementById('confirmPassword').setCustomValidity('');
    }
    if (!this.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
    }
    this.classList.add('was-validated');
});
document.getElementById('confirmPassword').addEventListener('input', function() {
    if (this.value === document.getElementById('password').value) {
        this.setCustomValidity('');
    } else {
        this.setCustomValidity('Mật khẩu không khớp');
    }
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
