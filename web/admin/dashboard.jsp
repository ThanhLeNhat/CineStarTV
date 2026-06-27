<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Admin Dashboard - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="sidebar.jsp" %>
    <main class="admin-content">
        <h2 class="text-white mb-4"><i class="fas fa-tachometer-alt text-danger me-2"></i>Dashboard</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Stats -->
        <div class="row g-4 mb-5">
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon mb-3"><i class="fas fa-film"></i></div>
                    <div class="stat-value">${totalMovies}</div>
                    <div class="stat-label">Phim</div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon mb-3"><i class="fas fa-users"></i></div>
                    <div class="stat-value">${totalUsers}</div>
                    <div class="stat-label">Người dùng</div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon mb-3"><i class="fas fa-ticket-alt"></i></div>
                    <div class="stat-value">—</div>
                    <div class="stat-label">Đặt vé</div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon mb-3"><i class="fas fa-money-bill"></i></div>
                    <div class="stat-value">—</div>
                    <div class="stat-label">Doanh thu</div>
                </div>
            </div>
        </div>

        <!-- Quick actions -->
        <h4 class="text-white mb-3">Truy cập nhanh</h4>
        <div class="row g-3">
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/AdminController?action=movieList"
                   class="card bg-dark border-secondary text-center p-4 text-decoration-none d-block">
                    <i class="fas fa-film fa-2x text-danger mb-2"></i>
                    <div class="text-white">Quản lý phim</div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="#" class="card bg-dark border-secondary text-center p-4 text-decoration-none d-block">
                    <i class="fas fa-users fa-2x text-danger mb-2"></i>
                    <div class="text-white">Quản lý user</div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="#" class="card bg-dark border-secondary text-center p-4 text-decoration-none d-block">
                    <i class="fas fa-building fa-2x text-danger mb-2"></i>
                    <div class="text-white">Quản lý rạp</div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="#" class="card bg-dark border-secondary text-center p-4 text-decoration-none d-block">
                    <i class="fas fa-ticket-alt fa-2x text-danger mb-2"></i>
                    <div class="text-white">Quản lý đặt vé</div>
                </a>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
