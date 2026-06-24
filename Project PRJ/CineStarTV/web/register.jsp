<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký — CineStarTV</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
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
            padding: 1.5rem 1rem;
            background-image:
                linear-gradient(rgba(231,26,15,0.04) 1px, transparent 1px),
                linear-gradient(90deg, rgba(231,26,15,0.04) 1px, transparent 1px);
            background-size: 40px 40px;
        }

        .auth-wrapper {
            width: 100%;
            max-width: 460px;
        }

        .auth-logo {
            text-align: center;
            margin-bottom: 2rem;
        }
        .auth-logo a {
            text-decoration: none;
            color: white;
            font-size: 1.8rem;
            font-weight: 800;
        }
        .auth-logo span { color: var(--cgv-red); }
        .auth-logo p {
            color: var(--cgv-muted);
            font-size: 0.85rem;
            margin-top: 0.25rem;
        }

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
        .form-control.is-invalid { border-color: #dc3545; }
        .invalid-feedback { font-size: 0.78rem; color: #f08080; }

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
        .input-group:focus-within .btn-eye { border-color: var(--cgv-red); }

        /* Password strength bar */
        .strength-bar {
            height: 4px;
            border-radius: 2px;
            background: var(--cgv-border);
            margin-top: 6px;
            overflow: hidden;
        }
        .strength-bar-fill {
            height: 100%;
            border-radius: 2px;
            width: 0%;
            transition: width 0.3s, background 0.3s;
        }
        .strength-text {
            font-size: 0.75rem;
            margin-top: 3px;
            color: var(--cgv-muted);
        }

        .btn-register {
            width: 100%;
            background: var(--cgv-red);
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 0.7rem;
            transition: background 0.2s, transform 0.1s;
        }
        .btn-register:hover { background: var(--cgv-red-h); }
        .btn-register:active { transform: scale(0.98); }

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

        /* Terms */
        .terms-check {
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
            margin-top: 0.75rem;
        }
        .terms-check input[type="checkbox"] {
            margin-top: 3px;
            accent-color: var(--cgv-red);
            cursor: pointer;
        }
        .terms-check label {
            color: var(--cgv-muted);
            font-size: 0.8rem;
            cursor: pointer;
        }
        .terms-check a { color: var(--cgv-gold); text-decoration: none; }
        .terms-check a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="auth-wrapper">

    <div class="auth-logo">
        <a href="${pageContext.request.contextPath}/MainController">
            <i class="fas fa-film"></i> Cine<span>Star</span>TV
        </a>
        <p>Tạo tài khoản để đặt vé nhanh hơn</p>
    </div>

    <div class="auth-card">
        <h2>Tạo tài khoản</h2>
        <p class="subtitle">Điền đầy đủ thông tin để bắt đầu.</p>

        <%-- Lỗi từ Controller --%>
        <c:if test="${not empty errorMessage}">
            <div class="alert-auth">
                <i class="fas fa-circle-exclamation"></i>
                ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/RegisterController"
              method="POST" id="registerForm" novalidate>

            <!-- Họ tên -->
            <div class="mb-3">
                <label class="form-label" for="fullName">Họ và tên</label>
                <input
                    type="text"
                    class="form-control"
                    id="fullName"
                    name="fullName"
                    placeholder="Nguyễn Văn A"
                    value="${param.fullName}"
                    required
                    autofocus
                >
                <div class="invalid-feedback" id="fullNameError"></div>
            </div>

            <!-- Email -->
            <div class="mb-3">
                <label class="form-label" for="email">Email</label>
                <input
                    type="email"
                    class="form-control"
                    id="email"
                    name="email"
                    placeholder="example@gmail.com"
                    value="${param.email}"
                    required
                >
                <div class="invalid-feedback" id="emailError"></div>
            </div>

            <!-- Số điện thoại -->
            <div class="mb-3">
                <label class="form-label" for="phone">
                    Số điện thoại
                    <span style="color: var(--cgv-muted); font-weight:400;">(không bắt buộc)</span>
                </label>
                <input
                    type="tel"
                    class="form-control"
                    id="phone"
                    name="phone"
                    placeholder="09xxxxxxxx"
                    value="${param.phone}"
                >
                <div class="invalid-feedback" id="phoneError"></div>
            </div>

            <!-- Mật khẩu -->
            <div class="mb-3">
                <label class="form-label" for="password">Mật khẩu</label>
                <div class="input-group">
                    <input
                        type="password"
                        class="form-control"
                        id="password"
                        name="password"
                        placeholder="Tối thiểu 6 ký tự"
                        required
                        oninput="checkStrength(this.value)"
                    >
                    <button type="button" class="btn-eye" onclick="togglePwd('password','eyeIcon1')">
                        <i class="fas fa-eye" id="eyeIcon1"></i>
                    </button>
                </div>
                <div class="strength-bar">
                    <div class="strength-bar-fill" id="strengthBar"></div>
                </div>
                <div class="strength-text" id="strengthText"></div>
                <div class="invalid-feedback d-block" id="passwordError"></div>
            </div>

            <!-- Xác nhận mật khẩu -->
            <div class="mb-3">
                <label class="form-label" for="confirmPassword">Xác nhận mật khẩu</label>
                <div class="input-group">
                    <input
                        type="password"
                        class="form-control"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Nhập lại mật khẩu"
                        required
                    >
                    <button type="button" class="btn-eye" onclick="togglePwd('confirmPassword','eyeIcon2')">
                        <i class="fas fa-eye" id="eyeIcon2"></i>
                    </button>
                </div>
                <div class="invalid-feedback d-block" id="confirmError"></div>
            </div>

            <!-- Terms -->
            <div class="terms-check">
                <input type="checkbox" id="terms" name="terms" required>
                <label for="terms">
                    Tôi đồng ý với
                    <a href="#">Điều khoản sử dụng</a> và
                    <a href="#">Chính sách bảo mật</a> của CineStarTV
                </label>
            </div>
            <div class="invalid-feedback d-block" id="termsError"></div>

            <!-- Submit -->
            <button type="submit" class="btn-register mt-4" id="submitBtn">
                <i class="fas fa-user-plus me-1"></i> Tạo tài khoản
            </button>

        </form>

        <div class="auth-footer" style="margin-top:1.25rem;">
            Đã có tài khoản?
            <a href="${pageContext.request.contextPath}/LoginController">Đăng nhập</a>
        </div>
    </div>

    <div class="back-home">
        <a href="${pageContext.request.contextPath}/MainController">
            <i class="fas fa-arrow-left me-1"></i> Quay về trang chủ
        </a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function togglePwd(fieldId, iconId) {
        const f = document.getElementById(fieldId);
        const i = document.getElementById(iconId);
        if (f.type === 'password') {
            f.type = 'text';
            i.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            f.type = 'password';
            i.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }

    function checkStrength(val) {
        const bar  = document.getElementById('strengthBar');
        const text = document.getElementById('strengthText');
        let score = 0;
        if (val.length >= 6)  score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val)) score++;
        if (/[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;

        const levels = [
            { w:'0%',   bg:'transparent', label:'' },
            { w:'25%',  bg:'#dc3545',     label:'Yếu' },
            { w:'50%',  bg:'#fd7e14',     label:'Trung bình' },
            { w:'75%',  bg:'#ffc107',     label:'Khá' },
            { w:'100%', bg:'#1D9E75',     label:'Mạnh' },
        ];
        const lv = levels[Math.min(score, 4)];
        bar.style.width      = lv.w;
        bar.style.background = lv.bg;
        text.textContent     = lv.label;
        text.style.color     = lv.bg || 'var(--cgv-muted)';
    }

    document.getElementById('registerForm').addEventListener('submit', function(e) {
        let valid = true;

        const fullName  = document.getElementById('fullName');
        const email     = document.getElementById('email');
        const phone     = document.getElementById('phone');
        const password  = document.getElementById('password');
        const confirm   = document.getElementById('confirmPassword');
        const terms     = document.getElementById('terms');

        // Reset tất cả lỗi
        ['fullName','email','password','confirmPassword'].forEach(id => {
            document.getElementById(id).classList.remove('is-invalid');
        });
        ['fullNameError','emailError','phoneError','passwordError','confirmError','termsError'].forEach(id => {
            document.getElementById(id).textContent = '';
        });

        // Họ tên
        if (!fullName.value.trim()) {
            fullName.classList.add('is-invalid');
            document.getElementById('fullNameError').textContent = 'Vui lòng nhập họ tên.';
            valid = false;
        } else if (fullName.value.trim().length < 2) {
            fullName.classList.add('is-invalid');
            document.getElementById('fullNameError').textContent = 'Họ tên phải có ít nhất 2 ký tự.';
            valid = false;
        }

        // Email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.value.trim()) {
            email.classList.add('is-invalid');
            document.getElementById('emailError').textContent = 'Vui lòng nhập email.';
            valid = false;
        } else if (!emailRegex.test(email.value.trim())) {
            email.classList.add('is-invalid');
            document.getElementById('emailError').textContent = 'Email không đúng định dạng.';
            valid = false;
        }

        // Số điện thoại (không bắt buộc nhưng nếu nhập phải đúng format)
        if (phone.value.trim()) {
            const phoneRegex = /^(0[3|5|7|8|9])+([0-9]{8})$/;
            if (!phoneRegex.test(phone.value.trim())) {
                document.getElementById('phoneError').textContent = 'Số điện thoại không hợp lệ (vd: 0912345678).';
                valid = false;
            }
        }

        // Mật khẩu
        if (!password.value) {
            password.classList.add('is-invalid');
            document.getElementById('passwordError').textContent = 'Vui lòng nhập mật khẩu.';
            valid = false;
        } else if (password.value.length < 6) {
            password.classList.add('is-invalid');
            document.getElementById('passwordError').textContent = 'Mật khẩu phải có ít nhất 6 ký tự.';
            valid = false;
        }

        // Xác nhận mật khẩu
        if (!confirm.value) {
            confirm.classList.add('is-invalid');
            document.getElementById('confirmError').textContent = 'Vui lòng xác nhận mật khẩu.';
            valid = false;
        } else if (confirm.value !== password.value) {
            confirm.classList.add('is-invalid');
            document.getElementById('confirmError').textContent = 'Mật khẩu xác nhận không khớp.';
            valid = false;
        }

        // Terms
        if (!terms.checked) {
            document.getElementById('termsError').textContent = 'Bạn cần đồng ý với điều khoản để tiếp tục.';
            valid = false;
        }

        if (!valid) {
            e.preventDefault();
            return;
        }

        // Disable submit
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang xử lý...';
    });
</script>

</body>
</html>
