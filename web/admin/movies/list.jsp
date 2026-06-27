<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Quản lý phim - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-film text-danger me-2"></i>Quản lý phim</h2>
            <a href="${pageContext.request.contextPath}/AdminController?action=movieAdd" class="btn btn-danger">
                <i class="fas fa-plus me-2"></i>Thêm phim
            </a>
        </div>

        <!-- Thông báo -->
        <c:if test="${param.msg == 'added'}">
            <div class="alert alert-success">Thêm phim thành công!</div>
        </c:if>
        <c:if test="${param.msg == 'updated'}">
            <div class="alert alert-success">Cập nhật phim thành công!</div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning">Đã xóa phim.</div>
        </c:if>

        <!-- Bảng phim -->
        <div style="overflow-x:auto;">
            <table class="csn-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Poster</th>
                        <th>Tên phim</th>
                        <th>Thể loại</th>
                        <th>Thời lượng</th>
                        <th>Ngày chiếu</th>
                        <th>Trạng thái</th>
                        <th>Rating</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="movie" items="${movies}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td>
                                <img src="${not empty movie.posterUrl ? movie.posterUrl : pageContext.request.contextPath.concat('/images/no-poster.jpg')}"
                                     alt="" style="width:45px;height:60px;object-fit:cover;border-radius:4px;"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/no-poster.jpg'">
                            </td>
                            <td>
                                <div class="text-white fw-semibold">${movie.title}</div>
                                <small class="text-muted">${movie.titleEn}</small>
                            </td>
                            <td><span class="badge bg-secondary">${movie.language}</span></td>
                            <td>${movie.durationFormatted}</td>
                            <td>
                                <c:if test="${not empty movie.releaseDate}">
                                    <fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/>
                                </c:if>
                            </td>
                            <td>
                                <span class="badge ${movie.status == 'NOW_SHOWING' ? 'bg-success' : movie.status == 'COMING_SOON' ? 'bg-warning text-dark' : 'bg-secondary'}">
                                    ${movie.status == 'NOW_SHOWING' ? 'Đang chiếu' : movie.status == 'COMING_SOON' ? 'Sắp chiếu' : 'Đã kết thúc'}
                                </span>
                            </td>
                            <td><span class="text-warning"><i class="fas fa-star me-1"></i>${movie.rating}</span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/AdminController?action=movieEdit&id=${movie.movieId}"
                                   class="btn btn-sm btn-outline-warning me-1" title="Sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/AdminController?action=movieDelete&id=${movie.movieId}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xác nhận xóa phim này?')" title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty movies}">
                        <tr>
                            <td colspan="9" class="text-center text-muted py-4">Chưa có phim nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
