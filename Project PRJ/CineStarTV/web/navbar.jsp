<%-- 
    Document   : navbar
    Created on : Jun 24, 2026, 3:14:04 AM
    Author     : TRI VY
--%>

<%-- 
    navbar.jsp — Thanh điều hướng chung
    Hiển thị: logo, menu chính, nút đăng nhập/avatar user
    Dùng: <%@ include file="navbar.jsp" %>
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<nav class="navbar">
    <div class="nav-container">
        <!-- Logo -->
        <a href="${pageContext.request.contextPath}/HomeController" class="nav-logo">
            <i class="fas fa-film"></i>
            <span>CineStarTV</span>
        </a>

        <!-- Menu chính -->
        <ul class="nav-menu">
            <li><a href="${pageContext.request.contextPath}/HomeController" class="nav-link">
                <i class="fas fa-home"></i> Trang chủ</a></li>
            <li><a href="${pageContext.request.contextPath}/MainController?action=movieList" class="nav-link">
                <i class="fas fa-video"></i> Phim</a></li>
            <li><a href="${pageContext.request.contextPath}/MainController?action=cinemaList" class="nav-link">
                <i class="fas fa-building"></i> Rạp</a></li>
            <li><a href="${pageContext.request.contextPath}/MainController?action=blogList" class="nav-link">
                <i class="fas fa-newspaper"></i> Tin tức</a></li>
        </ul>

        <!-- Phần user (bên phải) -->
        <div class="nav-user">
            <c:choose>
                <%-- Nếu đã đăng nhập --%>
                <c:when test="${sessionScope.loggedUser != null}">
                    <div class="user-dropdown">
                        <button class="user-btn">
                            <i class="fas fa-user-circle"></i>
                            <span>${sessionScope.loggedUser.fullName}</span>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="dropdown-menu">
                            <a href="${pageContext.request.contextPath}/MainController?action=profile">
                                <i class="fas fa-user"></i> Tài khoản</a>
                            <a href="${pageContext.request.contextPath}/MainController?action=bookingHistory">
                                <i class="fas fa-ticket-alt"></i> Lịch sử vé</a>

                            <%-- Menu Admin (chỉ hiện khi role = ADMIN) --%>
                            <c:if test="${sessionScope.loggedUser.admin}">
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/MainController?action=adminDashboard">
                                    <i class="fas fa-tachometer-alt"></i> Dashboard</a>
                                <a href="${pageContext.request.contextPath}/MainController?action=adminMovies">
                                    <i class="fas fa-film"></i> Quản lý phim</a>
                            </c:if>

                            <div class="dropdown-divider"></div>
                            <a href="${pageContext.request.contextPath}/LogoutController" class="logout-link">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                        </div>
                    </div>
                </c:when>

                <%-- Nếu chưa đăng nhập --%>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/LoginController" class="btn btn-login">
                        <i class="fas fa-sign-in-alt"></i> Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/RegisterController" class="btn-register">
                        <i class="fas fa-user-plus"></i> Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Nút hamburger (mobile) -->
        <button class="nav-toggle" id="navToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</nav>