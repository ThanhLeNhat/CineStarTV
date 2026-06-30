<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% request.setAttribute("pageTitle", "Trang cá nhân"); %>
<%@ include file="../common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success">Cập nhật thông tin thành công!</div>
            </c:if>
            <c:if test="${param.msg == 'pwchanged'}">
                <div class="alert alert-success">Đổi mật khẩu thành công!</div>
            </c:if>

            <div class="csn-form-card">
                <div class="text-center mb-4">
                    <img src="${profileUser.avatar != null && profileUser.avatar.startsWith('/uploads') ? pageContext.request.contextPath.concat(profileUser.avatar) : pageContext.request.contextPath.concat('/assets/images/').concat(profileUser.avatar != null ? profileUser.avatar : 'default-avatar.png')}"
                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.png'"
                         alt="Avatar" class="rounded-circle"
                         style="width:100px;height:100px;object-fit:cover;border:3px solid #e71a0f;">
                    <h4 class="text-white mt-3">${profileUser.fullName}</h4>
                    <span class="badge bg-danger">${profileUser.role.roleName}</span>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label text-muted">Email</label>
                        <p class="text-white">${profileUser.email}</p>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted">Số điện thoại</label>
                        <p class="text-white">${not empty profileUser.phone ? profileUser.phone : '—'}</p>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted">Trạng thái</label>
                        <p>
                            <span class="badge ${profileUser.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                ${profileUser.status}
                            </span>
                        </p>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted">Ngày tham gia</label>
                        <p class="text-white">
                            <fmt:formatDate value="${profileUser.createdAt}" pattern="dd/MM/yyyy"/>
                        </p>
                    </div>
                </div>

                <hr class="border-secondary my-4">

                <div class="d-flex gap-2 flex-wrap">
                    <a href="${pageContext.request.contextPath}/ProfileController?action=profileEdit"
                       class="btn btn-danger">
                        <i class="fas fa-edit me-2"></i>Sửa thông tin
                    </a>
                    <a href="${pageContext.request.contextPath}/ProfileController?action=changePassword"
                       class="btn btn-outline-light">
                        <i class="fas fa-key me-2"></i>Đổi mật khẩu
                    </a>
                    <a href="${pageContext.request.contextPath}/BookingController?action=bookingHistory"
                       class="btn btn-outline-secondary">
                        <i class="fas fa-ticket-alt me-2"></i>Lịch sử đặt vé
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
