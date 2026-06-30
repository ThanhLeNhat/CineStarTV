<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", request.getAttribute("post") == null ? "Thêm bài viết - Admin" : "Sửa bài viết - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <h2 class="text-white mb-4">
            <i class="fas fa-newspaper text-danger me-2"></i>
            ${not empty post ? 'Sửa bài viết' : 'Thêm bài viết'}
        </h2>

        <div class="csn-form-card" style="max-width:800px;">
            <form action="${pageContext.request.contextPath}/BlogPostController" method="POST">
                <input type="hidden" name="action" value="${not empty post ? 'blogDoEdit' : 'blogDoAdd'}"/>
                <c:if test="${not empty post}">
                    <input type="hidden" name="postId" value="${post.postId}"/>
                </c:if>

                <div class="mb-3">
                    <label class="form-label">Tiêu đề *</label>
                    <input type="text" class="form-control" name="title" value="${post.title}" required/>
                </div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Danh mục</label>
                        <select name="category" class="form-select">
                            <option value="NEWS" ${post.category == 'NEWS' || empty post ? 'selected' : ''}>Tin tức</option>
                            <option value="PROMOTION" ${post.category == 'PROMOTION' ? 'selected' : ''}>Khuyến mãi</option>
                            <option value="EVENT" ${post.category == 'EVENT' ? 'selected' : ''}>Sự kiện</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="PUBLISHED" ${post.status == 'PUBLISHED' || empty post ? 'selected' : ''}>Xuất bản</option>
                            <option value="DRAFT" ${post.status == 'DRAFT' ? 'selected' : ''}>Bản nháp</option>
                            <option value="HIDDEN" ${post.status == 'HIDDEN' ? 'selected' : ''}>Ẩn</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">URL ảnh thumbnail</label>
                        <input type="text" class="form-control" name="thumbnailUrl" value="${post.thumbnailUrl}" placeholder="https://..."/>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nội dung *</label>
                    <textarea class="form-control" name="content" rows="12" required>${post.content}</textarea>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-danger"><i class="fas fa-save me-2"></i>Lưu</button>
                    <a href="${pageContext.request.contextPath}/BlogPostController?action=adminBlogList" class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
