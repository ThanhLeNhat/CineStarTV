<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    boolean isEdit = request.getAttribute("cinema") != null;
    request.setAttribute("pageTitle", isEdit ? "Sửa rạp - Admin" : "Thêm rạp - Admin");
%>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex align-items-center gap-3 mb-4">
            <a href="${pageContext.request.contextPath}/CinemaController?action=cinemaList"
               class="btn btn-outline-secondary btn-sm"><i class="fas fa-arrow-left"></i></a>
            <h2 class="text-white mb-0">
                <i class="fas fa-building text-danger me-2"></i>
                ${not empty cinema ? 'Sửa rạp' : 'Thêm rạp mới'}
            </h2>
        </div>

        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

        <div class="csn-form-card" style="max-width:700px;">
            <form action="${pageContext.request.contextPath}/CinemaController" method="post">
                <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                <input type="hidden" name="action" value="${not empty cinema ? 'cinemaDoEdit' : 'cinemaDoAdd'}">
                <c:if test="${not empty cinema}">
                    <input type="hidden" name="cinemaId" value="${cinema.cinemaId}">
                </c:if>

                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label">Tên rạp *</label>
                        <input type="text" name="cinemaName" class="form-control" required
                               value="${not empty cinema ? cinema.cinemaName : ''}">
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" name="address" class="form-control"
                               value="${not empty cinema ? cinema.address : ''}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Thành phố</label>
                        <input type="text" name="city" class="form-control"
                               value="${not empty cinema ? cinema.city : ''}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Điện thoại</label>
                        <input type="text" name="phone" class="form-control"
                               value="${not empty cinema ? cinema.phone : ''}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE"   ${not empty cinema && cinema.status == 'ACTIVE'   ? 'selected' : ''}>Hoạt động</option>
                            <option value="INACTIVE" ${not empty cinema && cinema.status == 'INACTIVE' ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label">URL Hình ảnh</label>
                        <input type="url" name="imageUrl" class="form-control"
                               placeholder="https://..." value="${not empty cinema ? cinema.imageUrl : ''}">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" class="form-control" rows="3">${not empty cinema ? cinema.description : ''}</textarea>
                    </div>
                    <div class="col-12 d-flex gap-3 mt-2">
                        <button type="submit" class="btn btn-danger px-5">
                            <i class="fas fa-save me-2"></i>${not empty cinema ? 'Cập nhật' : 'Thêm rạp'}
                        </button>
                        <a href="${pageContext.request.contextPath}/CinemaController?action=cinemaList"
                           class="btn btn-outline-secondary px-4">Hủy</a>
                    </div>
                </div>
            </form>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
