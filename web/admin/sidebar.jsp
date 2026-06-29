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
        <a href="${pageContext.request.contextPath}/MovieController?action=movieList"
           class="nav-item ${param.action == 'movieList' || param.action == 'movieAdd' || param.action == 'movieEdit' ? 'active' : ''}">
            <i class="fas fa-film"></i>Phim
        </a>
        <a href="${pageContext.request.contextPath}/MovieController?action=genreList"
           class="nav-item ${param.action == 'genreList' ? 'active' : ''}">
            <i class="fas fa-tags"></i>Thể loại
        </a>
        <a href="${pageContext.request.contextPath}/CinemaController?action=cinemaList"
           class="nav-item ${param.action == 'cinemaList' || param.action == 'cinemaAdd' || param.action == 'cinemaEdit' || param.action == 'screenList' ? 'active' : ''}">
            <i class="fas fa-building"></i>Rạp chiếu
        </a>
        <a href="${pageContext.request.contextPath}/ShowtimeController?action=showtimeList"
           class="nav-item ${param.action == 'showtimeList' || param.action == 'showtimeAdd' ? 'active' : ''}">
            <i class="fas fa-calendar-alt"></i>Lịch chiếu
        </a>
        <a href="${pageContext.request.contextPath}/BookingController?action=adminBookingList"
           class="nav-item ${param.action == 'adminBookingList' ? 'active' : ''}">
            <i class="fas fa-ticket-alt"></i>Đặt vé
        </a>
        <a href="${pageContext.request.contextPath}/UserController?action=userList"
           class="nav-item ${param.action == 'userList' || param.action == 'userEdit' ? 'active' : ''}">
            <i class="fas fa-users"></i>Người dùng
        </a>
        <a href="${pageContext.request.contextPath}/VoucherController?action=voucherList"
           class="nav-item ${param.action == 'voucherList' || param.action == 'voucherAdd' || param.action == 'voucherEdit' ? 'active' : ''}">
            <i class="fas fa-tag"></i>Voucher
        </a>
        <a href="${pageContext.request.contextPath}/ReviewController?action=adminReviewList"
           class="nav-item ${param.action == 'adminReviewList' ? 'active' : ''}">
            <i class="fas fa-star"></i>Đánh giá
        </a>
        <a href="${pageContext.request.contextPath}/BlogPostController?action=adminBlogList"
           class="nav-item ${param.action == 'adminBlogList' || param.action == 'blogAdd' || param.action == 'blogEdit' ? 'active' : ''}">
            <i class="fas fa-newspaper"></i>Blog
        </a>
        <a href="${pageContext.request.contextPath}/NotificationController?action=adminSendForm"
           class="nav-item ${param.action == 'adminSendForm' ? 'active' : ''}">
            <i class="fas fa-bell"></i>Thông báo
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
