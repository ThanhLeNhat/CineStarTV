<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<c:if test="${empty movie}">
    <c:redirect url="/MovieController"/>
</c:if>

<% request.setAttribute("pageTitle", ((model.MovieDTO)request.getAttribute("movie")).getTitle() + " - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="row g-5">
        <!-- Poster -->
        <div class="col-md-3">
            <img src="${not empty movie.posterUrl ? pageContext.request.contextPath.concat(movie.posterUrl) : pageContext.request.contextPath.concat('/images/no-poster.jpg')}"
                 class="img-fluid rounded shadow" alt="${movie.title}"
                 style="width:100%;object-fit:cover;border-radius:8px;"
                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/no-poster.jpg'">

            <c:if test="${movie.status == 'NOW_SHOWING'}">
                <a href="#showtimes" class="btn btn-danger w-100 mt-3 py-2">
                    <i class="fas fa-ticket-alt me-2"></i>Đặt vé ngay
                </a>
            </c:if>
        </div>

        <!-- Info -->
        <div class="col-md-9">
            <div class="d-flex align-items-start gap-3 flex-wrap mb-2">
                <h1 class="text-white fw-bold mb-0">${movie.title}</h1>
                <span class="badge ${movie.ageRating == 'P' ? 'bg-success' : movie.ageRating == 'C13' ? 'bg-warning text-dark' : 'bg-danger'} fs-6">
                    ${movie.ageRating}
                </span>
            </div>
            <p class="text-secondary mb-3">${movie.titleEn}</p>

            <!-- Rating -->
            <div class="d-flex align-items-center gap-4 mb-4">
                <div class="text-center">
                    <div class="fs-2 fw-bold text-warning">${movie.rating}</div>
                    <small class="text-muted">/ 10 · ${movie.ratingCount} đánh giá</small>
                </div>
                <div>
                    <c:forEach begin="1" end="10" var="i">
                        <i class="fas fa-star ${i <= movie.rating ? 'text-warning' : 'text-secondary'}" style="font-size:.9rem;"></i>
                    </c:forEach>
                </div>
            </div>

            <!-- Meta -->
            <table class="table table-borderless text-light" style="width:auto;">
                <tr>
                    <td class="text-secondary pe-4">Đạo diễn</td>
                    <td class="fw-semibold">${movie.director}</td>
                </tr>
                <tr>
                    <td class="text-secondary">Diễn viên</td>
                    <td>${movie.actors}</td>
                </tr>
                <tr>
                    <td class="text-secondary">Thể loại</td>
                    <td>${movie.language}</td>
                </tr>
                <tr>
                    <td class="text-secondary">Thời lượng</td>
                    <td>${movie.durationFormatted}</td>
                </tr>
                <tr>
                    <td class="text-secondary">Khởi chiếu</td>
                    <td><fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/></td>
                </tr>
                <tr>
                    <td class="text-secondary">Ngôn ngữ</td>
                    <td>${movie.language}</td>
                </tr>
            </table>

            <!-- Mô tả -->
            <div class="mt-3">
                <h5 class="text-white">Nội dung phim</h5>
                <p class="text-secondary lh-lg">${movie.description}</p>
            </div>

            <!-- Trailer -->
            <c:if test="${not empty movie.trailerUrl}">
                <a href="${movie.trailerUrl}" target="_blank" class="btn btn-outline-danger mt-2">
                    <i class="fab fa-youtube me-2"></i>Xem trailer
                </a>
            </c:if>
        </div>
    </div>

    <!-- LỊCH CHIẾU -->
    <div id="showtimes" class="mt-5">
        <h3 class="text-white mb-4">
            <i class="fas fa-calendar-alt text-danger me-2"></i>Lịch chiếu
        </h3>
        <c:choose>
            <c:when test="${empty showtimes}">
                <p class="text-secondary">Chưa có lịch chiếu.</p>
            </c:when>
            <c:otherwise>
                <div class="row g-3">
                    <c:forEach var="st" items="${showtimes}">
                        <div class="col-md-4">
                            <div class="card bg-dark border-secondary p-3">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="text-white fw-bold fs-5">
                                            ${st.startTime} - ${st.endTime}
                                        </div>
                                        <small class="text-secondary">
                                            <fmt:formatDate value="${st.showDate}" pattern="dd/MM/yyyy"/>
                                        </small>
                                    </div>
                                    <span class="badge bg-secondary">${st.screen.screenType}</span>
                                </div>
                                <div class="mt-2 text-secondary small">
                                    <i class="fas fa-building me-1"></i>${st.screen.cinema.cinemaName}
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span class="text-danger fw-bold">
                                        <fmt:formatNumber value="${st.basePrice}" type="number" groupingUsed="true"/>đ
                                    </span>
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user}">
                                            <a href="${pageContext.request.contextPath}/MainController?action=selectSeat&showtimeId=${st.showtimeId}"
                                               class="btn btn-danger btn-sm">Chọn ghế</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/MainController?action=login"
                                               class="btn btn-outline-danger btn-sm">Đăng nhập để đặt</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ĐÁNH GIÁ -->
    <div class="mt-5">
        <h3 class="text-white mb-4">
            <i class="fas fa-star text-warning me-2"></i>Đánh giá (${avgRating != null ? avgRating : 0}/10)
        </h3>
        <c:choose>
            <c:when test="${empty reviews}">
                <p class="text-secondary">Chưa có đánh giá nào.</p>
            </c:when>
            <c:otherwise>
                <div class="row g-3">
                    <c:forEach var="rv" items="${reviews}">
                        <div class="col-md-6">
                            <div class="card bg-dark border-secondary p-3">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <span class="fw-bold text-white">${rv.user.fullName}</span>
                                        <small class="text-muted ms-2">
                                            <fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy"/>
                                        </small>
                                    </div>
                                    <span class="badge bg-warning text-dark">
                                        <i class="fas fa-star me-1"></i>${rv.rating}/10
                                    </span>
                                </div>
                                <p class="text-secondary mt-2 mb-0 small">${rv.comment}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
