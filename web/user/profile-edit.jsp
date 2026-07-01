<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("pageTitle", "Sửa thông tin cá nhân"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="csn-form-card">
                <h4 class="text-white mb-4"><i class="fas fa-user-edit text-danger me-2"></i>Sửa thông tin</h4>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/ProfileController" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="profileDoEdit">

                    <div class="mb-3">
                        <label class="form-label">Họ và tên *</label>
                        <input type="text" name="fullName" class="form-control"
                               value="${editUser.fullName}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" value="${editUser.email}" disabled>
                        <small class="text-muted">Email không thể thay đổi.</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control"
                               value="${editUser.phone}" placeholder="0912345678">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Ảnh đại diện</label>
                        <c:if test="${not empty editUser.avatar && editUser.avatar != 'default-avatar.png'}">
                            <div class="mb-2">
                                <img src="${pageContext.request.contextPath}${editUser.avatar}" alt="Avatar"
                                     class="rounded-circle"
                                     style="width:60px;height:60px;object-fit:cover;">
                            </div>
                        </c:if>
                        <input type="file" name="avatarFile" class="form-control" accept="image/*">
                        <small class="text-muted">Tối đa 2MB. Định dạng: jpg, png, webp.</small>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/ProfileController"
                           class="btn btn-outline-secondary">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
