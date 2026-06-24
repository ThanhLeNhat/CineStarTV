<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — CineStarTV</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --cgv-dark:   #0d0d1a;
            --cgv-navy:   #1A1A2E;
            --cgv-red:    #E71A0F;
            --cgv-red-h:  #c41208;
            --cgv-gold:   #E2B616;
            --cgv-muted:  #8b8fa8;
            --cgv-card:   #16213e;
            --cgv-border: #2a2d4a;
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--cgv-dark);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            /* Hiệu ứng lưới phim nhẹ ở nền */
            background-image:
                linear-gradient(rgba(231,26,15,0.04) 1px, transparent 1px),
                linear-gradient(90deg, rgba(231,26,15,0.04) 1px, transparent 1px);
            background-size: 40px 40px;
        }

        .auth-wrapper {
            width: 100%;
            max-width: 420px;
        }

        /* Logo */
        .auth-logo {
            text-align: center;
            margin-bottom: 2rem;
        }
        .auth-logo a {
            text-decoration: none;
            color: white;
            font-size: 1.8rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }
        .auth-logo span { color: var(--cgv-red); }
        .auth-logo p {
            color: var(--cgv-muted);
            font-size: 0.85rem;
            margin-top: 0.25rem;
        }

        /* Card */
        .auth-card {
            background: var(--cgv-card);
            border: 1px solid var(--cgv-border);
            border-radius: 16px;
            padding: 2rem;
        }

        .auth-card h2 {
            color: white;
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }
        .auth-card .subtitle {
            color: var(--cgv-muted);
            font-size: 0.875rem;
            margin-bottom: 1.75rem;
        }

        /* Form */
        .form-label {
            color: #cdd1e8;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.4rem;
        }

        .form-control {
            background: #0d0d1a;
            border: 1px solid var(--cgv-border);
            border-radius: 8px;
            color: white;
            padding: 0.65rem 0.9rem;
            font-size: 0.9rem;
            transition: border-color 0.2s;
        }
        .form-control:focus {
            background: #0d0d1a;
            border-color: var(--cgv-red);
            color: white;
            box-shadow: 0 0 0 3px rgba(231,26,15,0.15);
        }
        .form-control::placeholder { color: var(--cgv-muted); }
        .form-control.is-invalid {
            border-color: #dc3545;
        }

        /* Password toggle */
        .input-group .form-control { border-right: none; }
        .btn-eye {
            background: #0d0d1a;
            border: 1px solid var(--cgv-border);
            border-left: none;
            border-radius: 0 8px 8px 0;
            color: var(--cgv-muted);
            padding: 0 0.75rem;
            cursor: pointer;
            transition: color 0.2s;
        }
        .btn-eye:hover { color: white; }
        .input-group:focus-within .btn-eye {
            border-color: var(--cgv-red);
        }

        /* Forgot password */
        .forgot-link {
            color: var(--cgv-gold);
            font-size: 0.8rem;
            text-decoration: none;
        }
        .forgot-link:hover { text-decoration: underline; color: var(--cgv-gold); }

        /* Submit button */
        .btn-login {
            width: 100%;
            background: var(--cgv-red);
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 0.7rem;
            margin-top: 0.5rem;
            transition: background 0.2s, transform 0.1s;
        }
        .btn-login:hover { background: var(--cgv-red-h); }
        .btn-login:active { transform: scale(0.98); }

        /* Divider */
        .divider {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin: 1.25rem 0;
            color: var(--cgv-muted);
            font-size: 0.8rem;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--cgv-border);
        }

        /* Register link */
        .auth-footer {
            text-align: center;
            margin-top: 1.25rem;
            color: var(--cgv-muted);
            font-size: 0.875rem;
        }
        .auth-footer a {
            color: var(--cgv-red);
            font-weight: 600;
            text-decoration: none;
        }
        .auth-footer a:hover { text-decoration: underline; }

        /* Alert lỗi */
        .alert-auth {
            background: rgba(220,53,69,0.12);
            border: 1px solid rgba(220,53,69,0.35);
            border-radius: 8px;
            color: #f08080;
            font-size: 0.875rem;
            padding: 0.65rem 0.9rem;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Alert thành công (sau register) */
        .alert-success-auth {
            background: rgba(29,158,117,0.12);
            border: 1px solid rgba(29,158,117,0.35);
            border-radius: 8px;
            color: #6ddcb5;
            font-size: 0.875rem;
            padding: 0.65rem 0.9rem;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Back to home */
        .back-home {
            text-align: center;
            margin-top: 1.5rem;
        }
        .back-home a {
            color: var(--cgv-muted);
            font-size: 0.8rem;
            text-decoration: none;
        }
        .back-home a:hover { color: white; }
    </style>
</head>
<body>

<div class="auth-wrapper">

    <!-- Logo -->
    <div class="auth-logo">
        <a href="${pageContext.request.contextPath}/MainController">
            <i class="fas fa-film"></i> Cine<span>Star</span>TV
        </a>
        <p>Hệ thống đặt vé xem phim trực tuyến</p>
    </div>

    <!-- Card -->
    <div class="auth-card">
        <h2>Đăng nhập</h2>
        <p class="subtitle">Chào mừng trở lại! Nhập thông tin để tiếp tục.</p>

        <%-- Hiển thị thông báo lỗi từ Controller --%>
        <c:if test="${not empty errorMessage}">
    <div class="alert-auth">
        <i class="fas fa-circle-exclamation"></i>
        ${errorMessage}
    </div>
</c:if>
        <c:if test="${param.registered eq 'success'}">
    <div class="alert-success-auth">
        <i class="fas fa-circle-check"></i>
        Đăng ký thành công! Hãy đăng nhập để tiếp tục.
    </div>
</c:if>
        <c:if test="${param.logout eq 'success'}">
    <div class="alert-success-auth">
        <i class="fas fa-circle-check"></i>
        Bạn đã đăng xuất thành công.
    </div>
</c:if>

        <%-- Thông báo sau khi đăng ký thành công --%>
        <c:if test="${not empty successMessage}">
            <div class="alert-success-auth">
                <i class="fas fa-circle-check"></i>
                ${successMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/LoginController" method="POST" id="loginForm" novalidate>

            <!-- Email -->
            <div class="mb-3">
                <label class="form-label" for="email">Email</label>
                <input
                    type="email"
                    class="form-control"
                    id="email"
                    name="email"
                    placeholder="example@gmail.com"
                    value="${emailValue}"
                    required
                    autofocus
                >
                <div class="invalid-feedback" id="emailError"></div>
            </div>

            <!-- Password -->
            <div class="mb-2">
                <div class="d-flex justify-content-between align-items-center">
                    <label class="form-label mb-0" for="password">Mật khẩu</label>
                    <a href="${pageContext.request.contextPath}/ForgotPasswordController" class="forgot-link">
                        Quên mật khẩu?
                    </a>
                </div>
                <div class="input-group mt-1">
                    <input
                        type="password"
                        class="form-control"
                        id="password"
                        name="password"
                        placeholder="Nhập mật khẩu"
                        required
                    >
                    <button type="button" class="btn-eye" onclick="togglePassword()" title="Hiện/ẩn mật khẩu">
                        <i class="fas fa-eye" id="eyeIcon"></i>
                    </button>
                </div>
                <div class="invalid-feedback d-block" id="passwordError"></div>
            </div>

            <!-- Submit -->
            <button type="submit" class="btn-login mt-3" id="submitBtn">
                <i class="fas fa-right-to-bracket me-1"></i> Đăng nhập
            </button>

        </form>

        <div class="divider">hoặc</div>

        <div class="auth-footer">
            Chưa có tài khoản?
            <a href="${pageContext.request.contextPath}/RegisterController">Đăng ký ngay</a>
        </div>
    </div>

    <!-- Back to home -->
    <div class="back-home">
        <a href="${pageContext.request.contextPath}/MainController">
            <i class="fas fa-arrow-left me-1"></i> Quay về trang chủ
        </a>
    </div>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Toggle hiện/ẩn mật khẩu
    function togglePassword() {
        const pwd  = document.getElementById('password');
        const icon = document.getElementById('eyeIcon');
        if (pwd.type === 'password') {
            pwd.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            pwd.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }

    // Client-side validation trước khi submit
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        let valid = true;

        const email    = document.getElementById('email');
        const password = document.getElementById('password');
        const emailErr = document.getElementById('emailError');
        const pwdErr   = document.getElementById('passwordError');

        // Reset
        email.classList.remove('is-invalid');
        password.classList.remove('is-invalid');
        emailErr.textContent = '';
        pwdErr.textContent   = '';

        // Validate email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.value.trim()) {
            email.classList.add('is-invalid');
            emailErr.textContent = 'Vui lòng nhập email.';
            valid = false;
        } else if (!emailRegex.test(email.value.trim())) {
            email.classList.add('is-invalid');
            emailErr.textContent = 'Email không đúng định dạng.';
            valid = false;
        }

        // Validate password
        if (!password.value) {
            password.classList.add('is-invalid');
            pwdErr.textContent = 'Vui lòng nhập mật khẩu.';
            valid = false;
        }

        if (!valid) {
            e.preventDefault();
            return;
        }

        // Disable submit để tránh double-click
        document.getElementById('submitBtn').disabled = true;
        document.getElementById('submitBtn').innerHTML =
            '<span class="spinner-border spinner-border-sm me-1"></span> Đang xử lý...';
    });
</script>

</body>
</html>
