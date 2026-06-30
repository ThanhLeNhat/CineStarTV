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
                <a href="${pageContext.request.contextPath}/BookingController?action=selectShowtime&movieId=${movie.movieId}"
                   class="btn btn-danger w-100 mt-3 py-2">
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
                <%-- 5 sao, mỗi sao = 2 điểm. Dùng JS để tô màu chính xác --%>
                <div id="starRow"></div>
            </div>
            <script>
            (function(){
                var rating = ${movie.rating};
                var stars = 5;
                var html = '';
                for(var i = 1; i <= stars; i++){
                    var val = i * 2;
                    if(rating >= val) {
                        html += '<i class="fas fa-star text-warning me-1"></i>';
                    } else if(rating >= val - 1) {
                        html += '<i class="fas fa-star-half-alt text-warning me-1"></i>';
                    } else {
                        html += '<i class="far fa-star text-secondary me-1"></i>';
                    }
                }
                document.getElementById('starRow').innerHTML = html;
            })();
            </script>

            <!-- Meta -->
            <table class="table table-dark table-borderless" style="width:auto;background:transparent;">
                <tr>
                    <td class="text-secondary pe-4">Đạo diễn</td>
                    <td class="text-white fw-semibold">${movie.director}</td>
                </tr>
                <tr>
                    <td class="text-secondary">Diễn viên</td>
                    <td class="text-white">${movie.actors}</td>
                </tr>
                <tr>
                    <td class="text-secondary">Thể loại</td>
                    <td class="text-white">
                        <c:choose>
                            <c:when test="${not empty genres}">
                                <c:forEach var="g" items="${genres}" varStatus="gs">
                                    ${g.genreName}<c:if test="${!gs.last}">, </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td class="text-secondary">Thời lượng</td>
                    <td class="text-white">${movie.durationFormatted}</td>
                </tr>
                <tr>
                    <td class="text-secondary">Khởi chiếu</td>
                    <td class="text-white"><fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/></td>
                </tr>
                <tr>
                    <td class="text-secondary">Hình thức</td>
                    <td class="text-white">${movie.language}</td>
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

    <!-- ĐÁNH GIÁ -->
    <div class="mt-5">
        <h3 class="text-white mb-4">
            <i class="fas fa-star text-warning me-2"></i>Đánh giá
        </h3>

        <%-- Form viết đánh giá — chỉ hiển thị khi đã đăng nhập --%>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <div class="csn-form-card mb-4" style="max-width:600px;">
                    <h6 class="text-white mb-3">Viết đánh giá của bạn</h6>
                    <c:if test="${param.msg == 'reviewed'}">
                        <div class="alert alert-success py-2">Đánh giá đã được lưu!</div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/ReviewController" method="post">
                        <input type="hidden" name="action" value="addReview">
                        <input type="hidden" name="movieId" value="${movie.movieId}">
                        <div class="mb-3">
                            <label class="form-label">Điểm đánh giá (1-10)</label>
                            <div class="d-flex gap-2 flex-wrap">
                                <c:forEach begin="1" end="10" var="i">
                                    <label class="d-flex align-items-center gap-1" style="cursor:pointer;">
                                        <input type="radio" name="rating" value="${i}" required
                                               style="accent-color:#e50914;">
                                        <span class="text-white">${i}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nhận xét</label>
                            <textarea name="comment" class="form-control" rows="3"
                                      placeholder="Chia sẻ cảm nhận của bạn về bộ phim..."></textarea>
                        </div>
                        <button type="submit" class="btn btn-danger btn-sm">
                            <i class="fas fa-paper-plane me-1"></i>Gửi đánh giá
                        </button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-muted mb-4">
                    <a href="${pageContext.request.contextPath}/MainController?action=login" class="text-danger">Đăng nhập</a>
                    để viết đánh giá.
                </p>
            </c:otherwise>
        </c:choose>

        <%-- Danh sách đánh giá --%>
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
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-warning text-dark">
                                            <i class="fas fa-star me-1"></i>${rv.rating}/10
                                        </span>
                                        <c:if test="${sessionScope.user.userId == rv.user.userId}">
                                            <a href="${pageContext.request.contextPath}/ReviewController?action=deleteReview&reviewId=${rv.reviewId}"
                                               class="text-muted small" style="text-decoration:none;"
                                               onclick="return confirm('Xóa đánh giá này?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </c:if>
                                    </div>
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
