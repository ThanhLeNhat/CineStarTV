/**
 * main.js — CineStarTV Main JavaScript
 * Xử lý: navbar toggle, dropdown, smooth scroll, alert dismiss
 */

document.addEventListener('DOMContentLoaded', function () {

    // ─── Navbar Mobile Toggle ───
    const navToggle = document.getElementById('navToggle');
    const navMenu = document.querySelector('.nav-menu');

    if (navToggle && navMenu) {
        navToggle.addEventListener('click', function () {
            navMenu.classList.toggle('active');

            // Toggle icon hamburger ↔ close
            const icon = navToggle.querySelector('i');
            if (icon) {
                if (navMenu.classList.contains('active')) {
                    icon.classList.replace('fa-bars', 'fa-xmark');
                } else {
                    icon.classList.replace('fa-xmark', 'fa-bars');
                }
            }
        });

        // Đóng menu khi click vào link
        navMenu.querySelectorAll('.nav-link').forEach(function (link) {
            link.addEventListener('click', function () {
                navMenu.classList.remove('active');
                const icon = navToggle.querySelector('i');
                if (icon) icon.classList.replace('fa-xmark', 'fa-bars');
            });
        });
    }

    // ─── Close mobile menu khi click ngoài ───
    document.addEventListener('click', function (e) {
        if (navMenu && navToggle && 
            !navMenu.contains(e.target) && !navToggle.contains(e.target)) {
            navMenu.classList.remove('active');
            const icon = navToggle.querySelector('i');
            if (icon) icon.classList.replace('fa-xmark', 'fa-bars');
        }
    });

    // ─── User Dropdown Toggle (mobile-friendly click) ───
    const userDropdown = document.querySelector('.user-dropdown');
    if (userDropdown) {
        const userBtn = userDropdown.querySelector('.user-btn');
        const dropMenu = userDropdown.querySelector('.dropdown-menu');

        if (userBtn && dropMenu) {
            userBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                dropMenu.classList.toggle('show');
            });

            // Close dropdown khi click ngoài
            document.addEventListener('click', function () {
                dropMenu.classList.remove('show');
            });
        }
    }

    // ─── Navbar scroll effect ───
    const navbar = document.querySelector('.navbar');
    if (navbar) {
        window.addEventListener('scroll', function () {
            if (window.scrollY > 50) {
                navbar.style.background = 'rgba(13, 13, 26, 0.98)';
            } else {
                navbar.style.background = 'rgba(13, 13, 26, 0.92)';
            }
        });
    }

    // ─── Auto-dismiss alerts sau 5 giây ───
    const alerts = document.querySelectorAll('.alert-auth, .alert-success-auth');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function () {
                alert.remove();
            }, 400);
        }, 5000);
    });

    // ─── Toggle Password Visibility (generic) ───
    window.togglePwd = function (fieldId, iconId) {
        const field = document.getElementById(fieldId);
        const icon = document.getElementById(iconId);
        if (!field || !icon) return;

        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    };

    // ─── Toggle password (single field — login page) ───
    window.togglePassword = function () {
        togglePwd('password', 'eyeIcon');
    };

    // ─── Smooth scroll cho anchor links ───
    document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
        anchor.addEventListener('click', function (e) {
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            const target = document.querySelector(targetId);
            if (target) {
                e.preventDefault();
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});
