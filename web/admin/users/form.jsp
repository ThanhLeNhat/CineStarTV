<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Sửa người dùng - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <h2 class="text-white mb-4"><i class="fas fa-user-edit text-danger me-2"></i>Sửa thông tin người dùng</h2>

        <div class="csn-form-card" style="max-width:600px;">
            <form action="${pageContext.request.contextPath}/UserController" method="POST">
                <input type="hidden" name="action" value="userDoEdit"/>
                <input type="hidden" name="userId" value="${editUser.userId}"/>

                <div class="mb-3">
                    <label class="form-label">Họ tên</label>
                    <input type="text" class="form-control" value="${editUser.fullName}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="text" class="form-control" value="${editUser.email}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" name="phone" value="${editUser.phone}"/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Vai trò</label>
                    <select name="roleId" class="form-select">
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.roleId}" ${editUser.role.roleId == role.roleId ? 'selected' : ''}>${role.roleName} — ${role.description}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="ACTIVE" ${editUser.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                        <option value="BANNED" ${editUser.status == 'BANNED' ? 'selected' : ''}>Đã khóa</option>
                        <option value="INACTIVE" ${editUser.status == 'INACTIVE' ? 'selected' : ''}>Ngưng hoạt động</option>
                    </select>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-danger"><i class="fas fa-save me-2"></i>Lưu</button>
                    <a href="${pageContext.request.contextPath}/UserController?action=userList" class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
