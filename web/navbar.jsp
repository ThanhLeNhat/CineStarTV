<%-- navbar.jsp — Thanh điều hướng chung
     Dùng: <%@ include file="navbar.jsp" %>
     Yêu cầu: taglib c đã khai báo trong header.jsp
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<nav class="csn-navbar">
    <div class="csn-nav-inner">

        <!-- Logo -->
        <a href="${pageContext.request.contextPath}/MainController" class="csn-logo">
            <i class="fas fa-film"></i>
            <span>Cine<em>Star</em>TV</span>
        </a>

        <!-- Menu chính (desktop) -->
        <ul class="csn-menu">
            <li>
                <a href="${pageContext.request.contextPath}/MainController"
                   class="csn-link ${param.action == null || param.action == 'home' ? 'active' : ''}">
                    Trang chủ
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/MovieController"
                   class="csn-link ${param.action == 'movieList' ? 'active' : ''}">
                    <i class="fas fa-video me-1"></i>Phim
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/CinemaController"
                   class="csn-link ${param.action == 'cinemaList' ? 'active' : ''}">
                    <i class="fas fa-map-marker-alt me-1"></i>Rạp
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/BlogController"
                   class="csn-link ${param.action == 'blogList' ? 'active' : ''}">
                    <i class="fas fa-newspaper me-1"></i>Tin tức
                </a>
            </li>
        </ul>

        <!-- Khu vực user (bên phải) -->
        <div class="csn-user-area">
            <c:choose>
                <%-- ĐÃ ĐĂNG NHẬP --%>
                <c:when test="${not empty sessionScope.loggedUser}">

                    <%-- Notification bell --%>
                    <a href="${pageContext.request.contextPath}/NotificationController"
                       class="csn-icon-btn" title="Thông báo">
                        <i class="fas fa-bell"></i>
                    </a>

                    <%-- User dropdown --%>
                    <div class="csn-dropdown">
                        <button class="csn-user-btn" id="userDropdownBtn">
                            <img src="${pageContext.request.contextPath}/images/avatars/${sessionScope.loggedUser.avatar}"
                                 alt="avatar"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-avatar.png'"
                                 class="csn-avatar">
                            <span class="csn-username d-none d-lg-inline">
                                ${sessionScope.loggedUser.fullName}
                            </span>
                            <i class="fas fa-chevron-down csn-chevron"></i>
                        </button>

                        <div class="csn-dropdown-menu" id="userDropdownMenu">
                            <div class="csn-dropdown-header">
                                <strong>${sessionScope.loggedUser.fullName}</strong>
                                <small>${sessionScope.loggedUser.email}</small>
                            </div>
                            <div class="csn-dropdown-divider"></div>

                            <a href="${pageContext.request.contextPath}/ProfileController">
                                <i class="fas fa-user"></i> Tài khoản của tôi
                            </a>
                            <a href="${pageContext.request.contextPath}/BookingController?action=history">
                                <i class="fas fa-ticket-alt"></i> Lịch sử đặt vé
                            </a>

                            <%-- Chỉ hiện khi là ADMIN hoặc STAFF --%>
                            <c:if test="${sessionScope.loggedUser.admin || sessionScope.loggedUser.staff}">
                                <div class="csn-dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/AdminController"
                                   class="csn-admin-link">
                                    <i class="fas fa-tachometer-alt"></i> Trang quản trị
                                </a>
                            </c:if>

                            <div class="csn-dropdown-divider"></div>
                            <a href="${pageContext.request.contextPath}/LogoutController"
                               class="csn-logout-link">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </c:when>

                <%-- CHƯA ĐĂNG NHẬP --%>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/LoginController"
                       class="csn-btn-ghost">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/RegisterController"
                       class="csn-btn-red">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Hamburger (mobile) -->
        <button class="csn-hamburger" id="hamburgerBtn" aria-label="Mở menu">
            <span></span><span></span><span></span>
        </button>
    </div>

    <!-- Mobile menu -->
    <div class="csn-mobile-menu" id="mobileMenu">
        <a href="${pageContext.request.contextPath}/MainController">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/MovieController">Phim</a>
        <a href="${pageContext.request.contextPath}/CinemaController">Rạp</a>
        <a href="${pageContext.request.contextPath}/BlogController">Tin tức</a>
        <div class="csn-mobile-divider"></div>
        <c:choose>
            <c:when test="${not empty sessionScope.loggedUser}">
                <a href="${pageContext.request.contextPath}/ProfileController">Tài khoản</a>
                <a href="${pageContext.request.contextPath}/BookingController?action=history">Lịch sử vé</a>
                <a href="${pageContext.request.contextPath}/LogoutController">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/LoginController">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/RegisterController">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>
