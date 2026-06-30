<%-- common/navbar.jsp — Không khai báo taglib ở đây --%>
<nav class="navbar navbar-expand-lg csn-navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/HomeController">
            <i class="fas fa-film me-2"></i>CineStarTV
        </a>
        <button class="navbar-toggler border-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <i class="fas fa-bars text-light"></i>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/HomeController">
                        <i class="fas fa-home me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/MovieController">
                        <i class="fas fa-video me-1"></i>Phim
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/CinemaController">
                        <i class="fas fa-building me-1"></i>Rạp
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/MainController?action=blogList">
                        <i class="fas fa-newspaper me-1"></i>Tin tức
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="csn-dropdown">
                            <button class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-2">
                                <i class="fas fa-user-circle"></i>
                                <span>${sessionScope.user.fullName}</span>
                                <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="csn-dropdown-menu">
                                <a href="${pageContext.request.contextPath}/MainController?action=profile">
                                    <i class="fas fa-user me-2"></i>Tài khoản
                                </a>
                                <a href="${pageContext.request.contextPath}/BookingController?action=bookingHistory">
                                    <i class="fas fa-ticket-alt me-2"></i>Lịch sử vé
                                </a>
                                <a href="${pageContext.request.contextPath}/NotificationController?action=notificationList">
                                    <i class="fas fa-bell me-2"></i>Thông báo
                                </a>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <div class="divider"></div>
                                    <a href="${pageContext.request.contextPath}/AdminController">
                                        <i class="fas fa-tachometer-alt me-2"></i>Admin
                                    </a>
                                </c:if>
                                <div class="divider"></div>
                                <a href="${pageContext.request.contextPath}/LogoutController" class="text-danger">
                                    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/MainController?action=login" class="btn-login me-2">
                            <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/MainController?action=register" class="btn-register">
                            <i class="fas fa-user-plus me-1"></i>Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
