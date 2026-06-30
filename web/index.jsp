<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%
    if (request.getAttribute("nowShowing") == null) {
        response.sendRedirect(request.getContextPath() + "/HomeController");
        return;
    }
    request.setAttribute("pageTitle", "CineStarTV - Trang chủ");
%>
<%@ include file="common/header.jsp" %>
<%@ include file="common/navbar.jsp" %>

<!-- HERO BANNER -->
<section class="csn-hero">
    <div class="csn-hero-overlay"></div>
    <div class="csn-hero-content container">
        <p class="csn-hero-eyebrow"><i class="fas fa-film"></i> Rạp chiếu phim của Thành và Vỹ</p>
        <h1>Trải nghiệm điện ảnh<br><span class="text-danger">đỉnh cao</span></h1>
        <p class="csn-hero-sub">Đặt vé nhanh — Chọn ghế dễ — Thanh toán tiện</p>
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/MovieController" class="btn btn-danger btn-lg me-3">
                <i class="fas fa-ticket-alt me-2"></i>Đặt vé ngay
            </a>
            <a href="${pageContext.request.contextPath}/CinemaController" class="btn btn-outline-light btn-lg">
                <i class="fas fa-map-marker-alt me-2"></i>Tìm rạp gần bạn
            </a>
        </div>
    </div>
</section>

<!-- PHIM ĐANG CHIẾU -->
<section class="py-5 bg-dark">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-fire text-danger me-2"></i>Phim đang chiếu</h2>
            <a href="${pageContext.request.contextPath}/MovieController" class="btn btn-outline-danger btn-sm">
                Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
            </a>
        </div>
        <div class="row g-4">
            <c:forEach var="movie" items="${nowShowing}">
                <div class="col-6 col-md-3 col-lg-2">
                    <div class="card movie-card bg-secondary border-0 h-100">
                        <div class="movie-poster-wrap">
                            <img src="${not empty movie.posterUrl ? pageContext.request.contextPath.concat(movie.posterUrl) : pageContext.request.contextPath.concat('/images/no-poster.jpg')}"
                                 class="card-img-top" alt="${movie.title}" style="height:280px;object-fit:cover;"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/no-poster.jpg'">
                            <div class="movie-poster-overlay">
                                <a href="${pageContext.request.contextPath}/MovieController?action=movieDetail&id=${movie.movieId}"
                                   class="btn btn-outline-light btn-sm mb-2 d-block">Chi tiết</a>
                                <a href="${pageContext.request.contextPath}/MainController?action=selectShowtime&movieId=${movie.movieId}"
                                   class="btn btn-danger btn-sm d-block">Đặt vé</a>
                            </div>
                            <span class="badge bg-danger position-absolute top-0 start-0 m-2">${movie.ageRating}</span>
                        </div>
                        <div class="card-body p-2">
                            <h6 class="card-title text-white text-truncate mb-1" title="${movie.title}">${movie.title}</h6>
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>${movie.durationFormatted}
                                &nbsp;|&nbsp;
                                <i class="fas fa-star text-warning me-1"></i>${movie.rating}
                            </small>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- PHIM SẮP CHIẾU -->
<section class="py-5" style="background:#1a1a2e;">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-calendar-alt text-danger me-2"></i>Phim sắp chiếu</h2>
        </div>
        <div class="row g-4">
            <c:forEach var="movie" items="${comingSoon}">
                <div class="col-6 col-md-3 col-lg-2">
                    <div class="card movie-card bg-secondary border-0 h-100">
                        <div class="movie-poster-wrap position-relative">
                            <img src="${not empty movie.posterUrl ? pageContext.request.contextPath.concat(movie.posterUrl) : pageContext.request.contextPath.concat('/images/no-poster.jpg')}"
                                 class="card-img-top" alt="${movie.title}" style="height:280px;object-fit:cover;"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/no-poster.jpg'">
                            <div class="movie-poster-overlay">
                                <a href="${pageContext.request.contextPath}/MovieController?action=movieDetail&id=${movie.movieId}"
                                   class="btn btn-outline-light btn-sm d-block">Chi tiết</a>
                            </div>
                            <span class="badge bg-warning text-dark position-absolute top-0 end-0 m-2">Sắp chiếu</span>
                        </div>
                        <div class="card-body p-2">
                            <h6 class="card-title text-white text-truncate mb-1" title="${movie.title}">${movie.title}</h6>
                            <small class="text-muted">
                                <i class="fas fa-calendar me-1"></i>
                                <fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/>
                            </small>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- TIN TỨC -->
<c:if test="${not empty latestBlogs}">
<section class="py-5 bg-dark">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-newspaper text-danger me-2"></i>Tin tức &amp; Khuyến mãi</h2>
            <a href="${pageContext.request.contextPath}/MainController?action=blogList" class="btn btn-outline-danger btn-sm">
                Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
            </a>
        </div>
        <div class="row g-4">
            <c:forEach var="post" items="${latestBlogs}" end="2">
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/MainController?action=blogDetail&id=${post.postId}"
                       class="text-decoration-none">
                        <div class="card bg-secondary border-0 h-100">
                            <img src="${not empty post.thumbnailUrl ? post.thumbnailUrl : pageContext.request.contextPath.concat('/images/no-image.jpg')}"
                                 class="card-img-top" alt="${post.title}" style="height:200px;object-fit:cover;"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/no-image.jpg'">
                            <div class="card-body">
                                <span class="badge bg-danger mb-2">${post.category}</span>
                                <h5 class="card-title text-white">${post.title}</h5>
                                <small class="text-muted">
                                    <i class="fas fa-calendar me-1"></i>
                                    <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy"/>
                                </small>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</section>
</c:if>

<%@ include file="common/footer.jsp" %>
