<%-- 
    Document   : index
    Created on : Jun 23, 2026, 7:53:33 PM
    Author     : TRI VY
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "CineStarTV - Trang chủ"); %>
<%@ include file="header.jsp" %>

<%-- Nếu chưa có data → redirect qua HomeController --%>
<c:if test="${nowShowing == null}">
    <c:redirect url="HomeController"/>
</c:if>
<%@ include file="navbar.jsp" %>

<!-- ========== HERO BANNER ========== -->
<section class="hero">
    <div class="hero-content">
        <h1>Chào mừng đến <span class="highlight">CineStarTV</span></h1>
        <p>Trải nghiệm điện ảnh đỉnh cao — Đặt vé nhanh, xem phim hay</p>
        <a href="${pageContext.request.contextPath}/MainController?action=movieList" class="btn btn-primary">
            <i class="fas fa-ticket-alt"></i> Đặt vé ngay
        </a>
    </div>
</section>

<!-- ========== PHIM ĐANG CHIẾU ========== -->
<section class="section">
    <div class="section-container">
        <div class="section-header">
            <h2><i class="fas fa-fire"></i> Phim đang chiếu</h2>
            <a href="${pageContext.request.contextPath}/MainController?action=movieList" class="view-all">
                Xem tất cả <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="movie-grid">
            <c:forEach var="movie" items="${nowShowing}">
                <div class="movie-card">
                    <div class="movie-poster">
                        <img src="${movie.posterUrl != null ? movie.posterUrl : 'images/no-poster.jpg'}" 
                             alt="${movie.title}">
                        <div class="movie-overlay">
                            <a href="${pageContext.request.contextPath}/MainController?action=movieDetail&id=${movie.movieId}" 
                               class="btn btn-sm">Chi tiết</a>
                            <a href="${pageContext.request.contextPath}/MainController?action=selectShowtime&movieId=${movie.movieId}" 
                               class="btn btn-primary btn-sm">Đặt vé</a>
                        </div>
                        <span class="age-badge ${movie.ageRating}">${movie.ageRating}</span>
                    </div>
                    <div class="movie-info">
                        <h3 class="movie-title">${movie.title}</h3>
                        <p class="movie-meta">
                            <i class="fas fa-clock"></i> ${movie.duration} phút
                            <span class="separator">|</span>
                            <i class="fas fa-star"></i> ${movie.rating}/10
                        </p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- ========== PHIM SẮP CHIẾU ========== -->
<section class="section section-dark">
    <div class="section-container">
        <div class="section-header">
            <h2><i class="fas fa-calendar-alt"></i> Phim sắp chiếu</h2>
        </div>
        <div class="movie-grid">
            <c:forEach var="movie" items="${comingSoon}">
                <div class="movie-card">
                    <div class="movie-poster">
                        <img src="${movie.posterUrl != null ? movie.posterUrl : 'images/no-poster.jpg'}" 
                             alt="${movie.title}">
                        <div class="movie-overlay">
                            <a href="${pageContext.request.contextPath}/MainController?action=movieDetail&id=${movie.movieId}" 
                               class="btn btn-sm">Chi tiết</a>
                        </div>
                        <span class="coming-soon-badge">Sắp chiếu</span>
                        <span class="age-badge ${movie.ageRating}">${movie.ageRating}</span>
                    </div>
                    <div class="movie-info">
                        <h3 class="movie-title">${movie.title}</h3>
                        <p class="movie-meta">
                            <i class="fas fa-clock"></i> ${movie.duration} phút
                            <span class="separator">|</span>
                            <fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/>
                        </p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- ========== TIN TỨC ========== -->
<section class="section">
    <div class="section-container">
        <div class="section-header">
            <h2><i class="fas fa-newspaper"></i> Tin tức & Khuyến mãi</h2>
            <a href="${pageContext.request.contextPath}/MainController?action=blogList" class="view-all">
                Xem tất cả <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="blog-grid">
            <c:forEach var="post" items="${latestBlogs}" end="2">
                <div class="blog-card">
                    <div class="blog-thumb">
                        <img src="${post.thumbnailUrl != null ? post.thumbnailUrl : 'images/no-image.jpg'}" 
                             alt="${post.title}">
                        <span class="blog-category">${post.category}</span>
                    </div>
                    <div class="blog-body">
                        <h3><a href="${pageContext.request.contextPath}/MainController?action=blogDetail&id=${post.postId}">
                            ${post.title}</a></h3>
                        <p class="blog-date"><i class="fas fa-calendar"></i> 
                            <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy"/></p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>
