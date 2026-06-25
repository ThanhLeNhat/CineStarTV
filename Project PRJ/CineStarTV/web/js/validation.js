/**
 * validation.js — Client-side Form Validation cho CineStarTV
 * Cung cấp các hàm validate tái sử dụng cho login, register, và các form khác.
 */

const Validator = (function () {

    // ─── Regex patterns ───
    const patterns = {
        email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        phone: /^(0[3|5|7|8|9])+([0-9]{8})$/,
        password: /^.{6,}$/,
        name: /^.{2,}$/
    };

    /**
     * Hiển thị lỗi cho một field
     */
    function showError(fieldId, errorId, message) {
        const field = document.getElementById(fieldId);
        const error = document.getElementById(errorId);
        if (field) field.classList.add('is-invalid');
        if (error) error.textContent = message;
    }

    /**
     * Xóa lỗi cho một field
     */
    function clearError(fieldId, errorId) {
        const field = document.getElementById(fieldId);
        const error = document.getElementById(errorId);
        if (field) field.classList.remove('is-invalid');
        if (error) error.textContent = '';
    }

    /**
     * Xóa tất cả lỗi trong form
     */
    function clearAllErrors(fieldIds, errorIds) {
        fieldIds.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.remove('is-invalid');
        });
        errorIds.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.textContent = '';
        });
    }

    /**
     * Validate email
     * @returns {boolean} true nếu hợp lệ
     */
    function validateEmail(fieldId, errorId) {
        const field = document.getElementById(fieldId);
        if (!field) return true;
        const value = field.value.trim();

        if (!value) {
            showError(fieldId, errorId, 'Vui lòng nhập email.');
            return false;
        }
        if (!patterns.email.test(value)) {
            showError(fieldId, errorId, 'Email không đúng định dạng.');
            return false;
        }
        clearError(fieldId, errorId);
        return true;
    }

    /**
     * Validate mật khẩu (tối thiểu 6 ký tự)
     */
    function validatePassword(fieldId, errorId) {
        const field = document.getElementById(fieldId);
        if (!field) return true;
        const value = field.value;

        if (!value) {
            showError(fieldId, errorId, 'Vui lòng nhập mật khẩu.');
            return false;
        }
        if (value.length < 6) {
            showError(fieldId, errorId, 'Mật khẩu phải có ít nhất 6 ký tự.');
            return false;
        }
        clearError(fieldId, errorId);
        return true;
    }

    /**
     * Validate xác nhận mật khẩu (phải khớp)
     */
    function validateConfirmPassword(passwordId, confirmId, errorId) {
        const password = document.getElementById(passwordId);
        const confirm = document.getElementById(confirmId);
        if (!password || !confirm) return true;

        if (!confirm.value) {
            showError(confirmId, errorId, 'Vui lòng xác nhận mật khẩu.');
            return false;
        }
        if (confirm.value !== password.value) {
            showError(confirmId, errorId, 'Mật khẩu xác nhận không khớp.');
            return false;
        }
        clearError(confirmId, errorId);
        return true;
    }

    /**
     * Validate họ tên (tối thiểu 2 ký tự)
     */
    function validateName(fieldId, errorId) {
        const field = document.getElementById(fieldId);
        if (!field) return true;
        const value = field.value.trim();

        if (!value) {
            showError(fieldId, errorId, 'Vui lòng nhập họ tên.');
            return false;
        }
        if (value.length < 2) {
            showError(fieldId, errorId, 'Họ tên phải có ít nhất 2 ký tự.');
            return false;
        }
        clearError(fieldId, errorId);
        return true;
    }

    /**
     * Validate số điện thoại (không bắt buộc, nhưng nếu nhập phải đúng format VN)
     */
    function validatePhone(fieldId, errorId) {
        const field = document.getElementById(fieldId);
        if (!field) return true;
        const value = field.value.trim();

        if (!value) {
            clearError(fieldId, errorId);
            return true; // Không bắt buộc
        }
        if (!patterns.phone.test(value)) {
            showError(fieldId, errorId, 'Số điện thoại không hợp lệ (vd: 0912345678).');
            return false;
        }
        clearError(fieldId, errorId);
        return true;
    }

    /**
     * Validate checkbox (phải checked)
     */
    function validateCheckbox(fieldId, errorId, message) {
        const field = document.getElementById(fieldId);
        if (!field) return true;

        if (!field.checked) {
            const error = document.getElementById(errorId);
            if (error) error.textContent = message || 'Bạn cần đồng ý để tiếp tục.';
            return false;
        }
        const error = document.getElementById(errorId);
        if (error) error.textContent = '';
        return true;
    }

    /**
     * Disable submit button và hiện loading spinner
     */
    function disableSubmit(buttonId, loadingText) {
        const btn = document.getElementById(buttonId);
        if (!btn) return;
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> ' +
            (loadingText || 'Đang xử lý...');
    }

    /**
     * Enable submit button trở lại
     */
    function enableSubmit(buttonId, originalHTML) {
        const btn = document.getElementById(buttonId);
        if (!btn) return;
        btn.disabled = false;
        if (originalHTML) btn.innerHTML = originalHTML;
    }

    /**
     * Password strength checker
     */
    function checkPasswordStrength(value, barId, textId) {
        const bar = document.getElementById(barId);
        const text = document.getElementById(textId);
        if (!bar || !text) return;

        let score = 0;
        if (value.length >= 6)           score++;
        if (value.length >= 10)          score++;
        if (/[A-Z]/.test(value))         score++;
        if (/[0-9]/.test(value))         score++;
        if (/[^A-Za-z0-9]/.test(value))  score++;

        const levels = [
            { w: '0%',   bg: 'transparent', label: '' },
            { w: '25%',  bg: '#dc3545',     label: 'Yếu' },
            { w: '50%',  bg: '#fd7e14',     label: 'Trung bình' },
            { w: '75%',  bg: '#ffc107',     label: 'Khá' },
            { w: '100%', bg: '#1D9E75',     label: 'Mạnh' }
        ];

        const lv = levels[Math.min(score, 4)];
        bar.style.width = lv.w;
        bar.style.background = lv.bg;
        text.textContent = lv.label;
        text.style.color = lv.bg || 'var(--cgv-muted)';
    }

    // Public API
    return {
        showError,
        clearError,
        clearAllErrors,
        validateEmail,
        validatePassword,
        validateConfirmPassword,
        validateName,
        validatePhone,
        validateCheckbox,
        disableSubmit,
        enableSubmit,
        checkPasswordStrength
    };
})();
