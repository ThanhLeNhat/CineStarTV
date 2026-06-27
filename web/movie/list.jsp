<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Danh sách phim - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <!-- Tiêu đề + tìm kiếm -->
    <div class="row align-items-center mb-4">
        <div class="col-md-6">
            <h2 class="text-white fw-bold mb-0">
                <i class="fas fa-video text-danger me-2"></i>Danh sách phim
            </h2>
        </div>
        <div class="col-md-6">
            <form action="${pageContext.request.contextPath}/MovieController" method="get" class="d-flex gap-2">
                <input type="hidden" name="action" value="searchMovie">
                <input type="text" name="keyword" class="form-control bg-dark border-secondary text-light"
                       placeholder="Tìm kiếm phim..."
                       value="${not empty keyword ? keyword : ''}">
                <button type="submit" class="btn btn-danger px-4">
                    <i class="fas fa-search"></i>
                </button>
            </form>
        </div>
    </div>

    <!-- Filter tabs -->
    <ul class="nav nav-pills mb-4" id="movieTabs">
        <li class="nav-item">
            <a class="nav-link ${empty param.status || param.status == 'all' ? 'active bg-danger' : 'text-light'}"
               href="${pageContext.request.contextPath}/MovieController">Tất cả</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.status == 'NOW_SHOWING' ? 'active bg-danger' : 'text-light'}"
               href="${pageContext.request.contextPath}/MovieController?status=NOW_SHOWING">Đang chiếu</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.status == 'COMING_SOON' ? 'active bg-danger' : 'text-light'}"
               href="${pageContext.request.contextPath}/MovieController?status=COMING_SOON">Sắp chiếu</a>
        </li>
    </ul>

    <!-- Kết quả tìm kiếm -->
    <c:if test="${not empty keyword}">
        <p class="text-secondary mb-3">
            Kết quả tìm kiếm cho: <strong class="text-white">"${keyword}"</strong>
            — ${movies.size()} phim
        </p>
    </c:if>

    <!-- Danh sách phim -->
    <c:choose>
        <c:when test="${empty movies}">
            <div class="text-center py-5">
                <i class="fas fa-film fa-4x text-secondary mb-3"></i>
                <p class="text-secondary">Không tìm thấy phim nào.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="movie" items="${movies}">
                    <div class="col-6 col-md-4 col-lg-3 col-xl-2">
                        <div class="card movie-card bg-dark border-secondary h-100">
                            <div class="movie-poster-wrap">
                                <img src="${not empty movie.posterUrl ? movie.posterUrl : pageContext.request.contextPath.concat('/images/no-poster.jpg')}"
                                     class="card-img-top" alt="${movie.title}"
                                     style="height:300px;object-fit:cover;"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/no-poster.jpg'">
                                <div class="movie-poster-overlay">
                                    <a href="${pageContext.request.contextPath}/MovieController?action=movieDetail&id=${movie.movieId}"
                                       class="btn btn-outline-light btn-sm mb-2 d-block">
                                        <i class="fas fa-info-circle me-1"></i>Chi tiết
                                    </a>
                                    <c:if test="${movie.status == 'NOW_SHOWING'}">
                                        <a href="${pageContext.request.contextPath}/MainController?action=selectShowtime&movieId=${movie.movieId}"
                                           class="btn btn-danger btn-sm d-block">
                                            <i class="fas fa-ticket-alt me-1"></i>Đặt vé
                                        </a>
                                    </c:if>
                                </div>
                                <span class="badge position-absolute top-0 start-0 m-2
                                    ${movie.ageRating == 'P' ? 'bg-success' : movie.ageRating == 'C13' ? 'bg-warning text-dark' : movie.ageRating == 'C16' ? 'bg-orange' : 'bg-danger'}">
                                    ${movie.ageRating}
                                </span>
                                <c:if test="${movie.status == 'COMING_SOON'}">
                                    <span class="badge bg-warning text-dark position-absolute top-0 end-0 m-2">Sắp chiếu</span>
                                </c:if>
                            </div>
                            <div class="card-body p-2">
                                <h6 class="card-title text-white text-truncate mb-1" title="${movie.title}">
                                    ${movie.title}
                                </h6>
                                <div class="d-flex justify-content-between">
                                    <small class="text-muted">
                                        <i class="fas fa-clock me-1"></i>${movie.durationFormatted}
                                    </small>
                                    <small class="text-warning">
                                        <i class="fas fa-star me-1"></i>${movie.rating}
                                    </small>
                                </div>
                                <small class="text-muted d-block mt-1">
                                    <i class="fas fa-language me-1"></i>${movie.language}
                                </small>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="../common/footer.jsp" %>
