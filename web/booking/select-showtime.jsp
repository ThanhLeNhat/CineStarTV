<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Chọn suất chiếu - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <h2 class="text-white mb-4">
        <i class="fas fa-calendar-alt text-danger me-2"></i>Chọn suất chiếu
    </h2>

    <c:if test="${not empty movie}">
        <!-- Thông tin phim -->
        <div class="row mb-4">
            <div class="col-md-3">
                <img src="${not empty movie.posterUrl ? movie.posterUrl : pageContext.request.contextPath.concat('/images/no-poster.jpg')}"
                     alt="${movie.title}" class="img-fluid rounded"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/no-poster.jpg'"
                     style="max-height:350px;object-fit:cover;">
            </div>
            <div class="col-md-9">
                <h3 class="text-white">${movie.title}</h3>
                <p class="text-muted">${movie.titleEn}</p>
                <p class="text-light">
                    <span class="badge badge-${movie.ageRating} me-2">${movie.ageRating}</span>
                    <i class="fas fa-clock me-1"></i>${movie.duration} phút
                    <span class="ms-3"><i class="fas fa-star text-warning me-1"></i>${movie.rating}</span>
                </p>
            </div>
        </div>

        <!-- Danh sách suất chiếu -->
        <c:if test="${not empty showtimes}">
            <div class="csn-form-card">
                <h5 class="text-white mb-3">Chọn suất chiếu</h5>
                <div class="row g-3">
                    <c:forEach var="st" items="${showtimes}">
                        <div class="col-md-4 col-lg-3">
                            <a href="${pageContext.request.contextPath}/BookingController?action=selectSeat&showtimeId=${st.showtimeId}"
                               class="card bg-dark border-secondary text-center p-3 text-decoration-none d-block"
                               style="transition:border-color .2s;">
                                <div class="text-warning fw-bold mb-1">
                                    <fmt:formatDate value="${st.showDate}" pattern="dd/MM/yyyy"/>
                                </div>
                                <div class="text-white" style="font-size:1.3rem;font-weight:700;">
                                    ${st.startTime} — ${st.endTime}
                                </div>
                                <div class="text-muted small mt-1">
                                    ${st.screen.screenName} • ${st.screen.screenType}
                                </div>
                                <div class="text-danger small mt-1">
                                    <fmt:formatNumber value="${st.basePrice}" pattern="#,###"/>đ
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        <c:if test="${empty showtimes}">
            <div class="alert alert-warning">Hiện chưa có suất chiếu nào cho phim này.</div>
        </c:if>
    </c:if>
    <c:if test="${empty movie}">
        <div class="alert alert-danger">Không tìm thấy phim.</div>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
