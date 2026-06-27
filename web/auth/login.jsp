<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Nếu đã đăng nhập thì về trang chủ --%>
<c:if test="${not empty sessionScope.user}">
    <c:redirect url="/HomeController"/>
</c:if>

<% request.setAttribute("pageTitle", "Đăng nhập - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>

<div class="auth-page">
    <div class="auth-card">
        <div class="logo"><i class="fas fa-film"></i> CineStarTV</div>
        <h2>Đăng nhập</h2>

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

        <form action="${pageContext.request.contextPath}/LoginController" method="post" novalidate id="loginForm">
            <div class="mb-3">
                <label class="form-label text-secondary">Email</label>
                <input type="email" name="email" class="form-control bg-dark border-secondary text-light"
                       placeholder="example@gmail.com" required
                       value="${not empty param.email ? param.email : ''}">
                <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
            </div>
            <div class="mb-3">
                <label class="form-label text-secondary">Mật khẩu</label>
                <div class="input-group">
                    <input type="password" name="password" id="passwordInput"
                           class="form-control bg-dark border-secondary text-light"
                           placeholder="••••••••" required>
                    <button type="button" class="btn btn-outline-secondary" onclick="togglePassword()">
                        <i class="fas fa-eye" id="eyeIcon"></i>
                    </button>
                </div>
                <div class="invalid-feedback">Vui lòng nhập mật khẩu.</div>
            </div>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="rememberMe">
                    <label class="form-check-label text-secondary" for="rememberMe">Ghi nhớ đăng nhập</label>
                </div>
                <a href="${pageContext.request.contextPath}/MainController?action=forgotPassword"
                   class="text-danger small">Quên mật khẩu?</a>
            </div>
            <button type="submit" class="btn btn-csn-red w-100 py-2">
                <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
            </button>
        </form>

        <hr class="border-secondary my-4">

        <p class="text-center text-secondary mb-0">
            Chưa có tài khoản?
            <a href="${pageContext.request.contextPath}/MainController?action=register" class="text-danger fw-bold">Đăng ký ngay</a>
        </p>
    </div>
</div>

<script>
function togglePassword() {
    var input = document.getElementById('passwordInput');
    var icon = document.getElementById('eyeIcon');
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
    }
}

// Client-side validation
document.getElementById('loginForm').addEventListener('submit', function(e) {
    if (!this.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
    }
    this.classList.add('was-validated');
});
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
