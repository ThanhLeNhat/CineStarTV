<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("pageTitle", "Đổi mật khẩu"); %>
<%@ include file="../common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="csn-form-card">
                <h4 class="text-white mb-4"><i class="fas fa-key text-danger me-2"></i>Đổi mật khẩu</h4>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/ProfileController" method="post">
                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="doChangePassword">

                    <div class="mb-3">
                        <label class="form-label">Mật khẩu hiện tại *</label>
                        <input type="password" name="oldPassword" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu mới * (ít nhất 6 ký tự)</label>
                        <input type="password" name="newPassword" class="form-control"
                               required minlength="6">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Xác nhận mật khẩu mới *</label>
                        <input type="password" name="confirmPassword" class="form-control" required>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-save me-2"></i>Đổi mật khẩu
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
