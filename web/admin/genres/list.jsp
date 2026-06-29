<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% request.setAttribute("pageTitle", "Quản lý thể loại - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-tags text-danger me-2"></i>Quản lý thể loại</h2>
        </div>

        <!-- Thông báo -->
        <c:if test="${param.msg == 'added'}">
            <div class="alert alert-success">Thêm thể loại thành công!</div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning">Đã xóa thể loại.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <div class="row g-4">
            <!-- Form thêm thể loại -->
            <div class="col-md-4">
                <div class="csn-form-card">
                    <h5 class="text-white mb-3">Thêm thể loại mới</h5>
                    <form action="${pageContext.request.contextPath}/MovieController" method="post">
                        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                        <input type="hidden" name="action" value="genreDoAdd">
                        <div class="mb-3">
                            <label class="form-label">Tên thể loại (Tiếng Việt) *</label>
                            <input type="text" name="genreName" class="form-control" required
                                   placeholder="Hành động, Tình cảm...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tên tiếng Anh</label>
                            <input type="text" name="genreNameEn" class="form-control"
                                   placeholder="Action, Romance...">
                        </div>
                        <button type="submit" class="btn btn-danger w-100">
                            <i class="fas fa-plus me-2"></i>Thêm thể loại
                        </button>
                    </form>
                </div>
            </div>

            <!-- Danh sách thể loại -->
            <div class="col-md-8">
                <div style="overflow-x:auto;">
                    <table class="csn-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tên thể loại</th>
                                <th>Tên tiếng Anh</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="genre" items="${genres}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td class="text-white">${genre.genreName}</td>
                                    <td class="text-muted">${genre.genreNameEn}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/MovieController?action=genreDelete&id=${genre.genreId}"
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Xóa thể loại này?')" title="Xóa">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty genres}">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-4">Chưa có thể loại nào.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
