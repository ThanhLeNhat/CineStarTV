<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Quản lý người dùng - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-users text-danger me-2"></i>Quản lý người dùng</h2>
        </div>

        <!-- Thông báo -->
        <c:if test="${param.msg == 'updated'}">
            <div class="alert alert-success">Cập nhật thành công!</div>
        </c:if>
        <c:if test="${param.msg == 'banned'}">
            <div class="alert alert-warning">Đã khóa tài khoản.</div>
        </c:if>
        <c:if test="${param.msg == 'activated'}">
            <div class="alert alert-success">Đã kích hoạt tài khoản.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Bảng users -->
        <div style="overflow-x:auto;">
            <table class="csn-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>SĐT</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td>
                                <div class="text-white fw-semibold">${u.fullName}</div>
                            </td>
                            <td>${u.email}</td>
                            <td>${u.phone}</td>
                            <td>
                                <span class="badge ${u.role.roleName == 'ADMIN' ? 'bg-danger' : u.role.roleName == 'STAFF' ? 'bg-warning text-dark' : 'bg-info'}">
                                    ${u.role.roleName}
                                </span>
                            </td>
                            <td>
                                <span class="badge ${u.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                    ${u.status == 'ACTIVE' ? 'Hoạt động' : u.status == 'BANNED' ? 'Đã khóa' : u.status}
                                </span>
                            </td>
                            <td>
                                <c:if test="${not empty u.createdAt}">
                                    <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/>
                                </c:if>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/UserController?action=userEdit&id=${u.userId}"
                                   class="btn btn-sm btn-outline-warning me-1" title="Sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <c:choose>
                                    <c:when test="${u.status == 'ACTIVE' && u.role.roleName != 'ADMIN'}">
                                        <a href="${pageContext.request.contextPath}/UserController?action=userBan&id=${u.userId}"
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Xác nhận khóa tài khoản này?')" title="Khóa">
                                            <i class="fas fa-ban"></i>
                                        </a>
                                    </c:when>
                                    <c:when test="${u.status == 'BANNED'}">
                                        <a href="${pageContext.request.contextPath}/UserController?action=userActivate&id=${u.userId}"
                                           class="btn btn-sm btn-outline-success" title="Mở khóa">
                                            <i class="fas fa-check"></i>
                                        </a>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">Chưa có người dùng nào.</td>
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
