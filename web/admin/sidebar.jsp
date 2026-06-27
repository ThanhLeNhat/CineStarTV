<%-- admin/sidebar.jsp — Không khai báo taglib ở đây --%>
<aside class="admin-sidebar">
    <a class="brand" href="${pageContext.request.contextPath}/AdminController">
        <i class="fas fa-film me-2"></i>CineStarTV
    </a>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/AdminController"
           class="nav-item ${empty param.action ? 'active' : ''}">
            <i class="fas fa-tachometer-alt"></i>Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/AdminController?action=movieList"
           class="nav-item ${param.action == 'movieList' || param.action == 'movieAdd' || param.action == 'movieEdit' ? 'active' : ''}">
            <i class="fas fa-film"></i>Phim
        </a>
        <a href="#" class="nav-item">
            <i class="fas fa-building"></i>Rạp / Phòng
        </a>
        <a href="#" class="nav-item">
            <i class="fas fa-calendar-alt"></i>Lịch chiếu
        </a>
        <a href="#" class="nav-item">
            <i class="fas fa-ticket-alt"></i>Đặt vé
        </a>
        <a href="#" class="nav-item">
            <i class="fas fa-users"></i>Người dùng
        </a>
        <a href="#" class="nav-item">
            <i class="fas fa-tag"></i>Voucher
        </a>
        <a href="#" class="nav-item">
            <i class="fas fa-newspaper"></i>Blog
        </a>
        <div class="mt-auto pt-3" style="border-top:1px solid #222;margin-top:auto;">
            <a href="${pageContext.request.contextPath}/HomeController" class="nav-item">
                <i class="fas fa-home"></i>Về trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/LogoutController" class="nav-item text-danger">
                <i class="fas fa-sign-out-alt"></i>Đăng xuất
            </a>
        </div>
    </nav>
</aside>
