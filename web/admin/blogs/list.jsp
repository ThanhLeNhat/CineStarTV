<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Quản lý Blog - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-newspaper text-danger me-2"></i>Quản lý Blog</h2>
            <a href="${pageContext.request.contextPath}/BlogPostController?action=blogAdd" class="btn btn-danger">
                <i class="fas fa-plus me-2"></i>Thêm bài viết
            </a>
        </div>

        <c:if test="${param.msg == 'added'}"><div class="alert alert-success">Thêm bài viết thành công!</div></c:if>
        <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Cập nhật bài viết thành công!</div></c:if>
        <c:if test="${param.msg == 'deleted'}"><div class="alert alert-warning">Đã ẩn bài viết.</div></c:if>

        <div style="overflow-x:auto;">
            <table class="csn-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tiêu đề</th>
                        <th>Danh mục</th>
                        <th>Tác giả</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${posts}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td><div class="text-white fw-semibold">${p.title}</div></td>
                            <td>
                                <span class="badge ${p.category == 'NEWS' ? 'bg-info' : p.category == 'PROMOTION' ? 'bg-warning text-dark' : 'bg-success'}">
                                    ${p.category == 'NEWS' ? 'Tin tức' : p.category == 'PROMOTION' ? 'Khuyến mãi' : 'Sự kiện'}
                                </span>
                            </td>
                            <td>${p.user.fullName}</td>
                            <td>
                                <span class="badge ${p.status == 'PUBLISHED' ? 'bg-success' : p.status == 'DRAFT' ? 'bg-secondary' : 'bg-danger'}">
                                    ${p.status == 'PUBLISHED' ? 'Đã xuất bản' : p.status == 'DRAFT' ? 'Bản nháp' : 'Đã ẩn'}
                                </span>
                            </td>
                            <td><fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/BlogPostController?action=blogEdit&id=${p.postId}"
                                   class="btn btn-sm btn-outline-warning me-1" title="Sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/BlogPostController?action=blogDelete&id=${p.postId}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xác nhận ẩn bài viết này?')" title="Ẩn">
                                    <i class="fas fa-eye-slash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty posts}">
                        <tr><td colspan="7" class="text-center text-muted py-4">Chưa có bài viết nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
