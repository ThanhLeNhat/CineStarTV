<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<%
    boolean isEdit = request.getAttribute("movie") != null;
    request.setAttribute("pageTitle", isEdit ? "Sửa phim - Admin" : "Thêm phim - Admin");
%>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex align-items-center gap-3 mb-4">
            <a href="${pageContext.request.contextPath}/MovieController?action=movieList"
               class="btn btn-outline-secondary btn-sm"><i class="fas fa-arrow-left"></i></a>
            <h2 class="text-white mb-0">
                <i class="fas fa-film text-danger me-2"></i>
                ${not empty movie ? 'Sửa phim' : 'Thêm phim mới'}
            </h2>
        </div>

        <div class="csn-form-card" style="max-width:800px;">
            <form action="${pageContext.request.contextPath}/MovieController" method="post" id="movieForm" novalidate>
                <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                <input type="hidden" name="action" value="${not empty movie ? 'movieDoEdit' : 'movieDoAdd'}">
                <c:if test="${not empty movie}">
                    <input type="hidden" name="movieId" value="${movie.movieId}">
                </c:if>

                <div class="row g-3">
                    <div class="col-md-8">
                        <label class="form-label">Tên phim (Tiếng Việt) *</label>
                        <input type="text" name="title" class="form-control" required
                               value="${not empty movie ? movie.title : ''}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Tên tiếng Anh</label>
                        <input type="text" name="titleEn" class="form-control"
                               value="${not empty movie ? movie.titleEn : ''}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Thời lượng (phút) *</label>
                        <input type="number" name="duration" class="form-control" required min="30" max="360"
                               value="${not empty movie ? movie.duration : 90}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Ngày chiếu</label>
                        <input type="date" name="releaseDate" class="form-control"
                               value="${not empty movie ? '' : ''}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="NOW_SHOWING" ${not empty movie && movie.status == 'NOW_SHOWING' ? 'selected' : ''}>Đang chiếu</option>
                            <option value="COMING_SOON" ${not empty movie && movie.status == 'COMING_SOON' ? 'selected' : ''}>Sắp chiếu</option>
                            <option value="ENDED" ${not empty movie && movie.status == 'ENDED' ? 'selected' : ''}>Đã kết thúc</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Đạo diễn</label>
                        <input type="text" name="director" class="form-control"
                               value="${not empty movie ? movie.director : ''}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Diễn viên chính</label>
                        <input type="text" name="actors" class="form-control"
                               value="${not empty movie ? movie.actors : ''}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Phân loại tuổi</label>
                        <select name="ageRating" class="form-select">
                            <option value="P"   ${not empty movie && movie.ageRating == 'P'   ? 'selected' : ''}>P — Mọi lứa tuổi</option>
                            <option value="C13" ${not empty movie && movie.ageRating == 'C13' ? 'selected' : ''}>C13 — Trên 13 tuổi</option>
                            <option value="C16" ${not empty movie && movie.ageRating == 'C16' ? 'selected' : ''}>C16 — Trên 16 tuổi</option>
                            <option value="C18" ${not empty movie && movie.ageRating == 'C18' ? 'selected' : ''}>C18 — Trên 18 tuổi</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Ngôn ngữ</label>
                        <select name="language" class="form-select">
                            <option value="Phụ đề"    ${not empty movie && movie.language == 'Phụ đề'    ? 'selected' : ''}>Phụ đề</option>
                            <option value="Lồng tiếng" ${not empty movie && movie.language == 'Lồng tiếng' ? 'selected' : ''}>Lồng tiếng</option>
                            <option value="Nguyên bản" ${not empty movie && movie.language == 'Nguyên bản' ? 'selected' : ''}>Nguyên bản</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Rating (0-10)</label>
                        <input type="number" name="rating" class="form-control" min="0" max="10" step="0.1"
                               value="${not empty movie ? movie.rating : 0}">
                    </div>
                    <div class="col-12">
                        <label class="form-label">URL Poster</label>
                        <input type="url" name="posterUrl" class="form-control"
                               placeholder="https://..." value="${not empty movie ? movie.posterUrl : ''}">
                    </div>
                    <div class="col-12">
                        <label class="form-label">URL Trailer (YouTube)</label>
                        <input type="url" name="trailerUrl" class="form-control"
                               placeholder="https://youtube.com/..." value="${not empty movie ? movie.trailerUrl : ''}">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Nội dung / Mô tả</label>
                        <textarea name="description" class="form-control" rows="5">${not empty movie ? movie.description : ''}</textarea>
                    </div>
                    <div class="col-12 d-flex gap-3 mt-2">
                        <button type="submit" class="btn btn-csn-red px-5">
                            <i class="fas fa-save me-2"></i>${not empty movie ? 'Cập nhật' : 'Thêm phim'}
                        </button>
                        <a href="${pageContext.request.contextPath}/MovieController?action=movieList"
                           class="btn btn-outline-secondary px-4">Hủy</a>
                    </div>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
document.getElementById('movieForm').addEventListener('submit', function(e) {
    if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
    this.classList.add('was-validated');
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
