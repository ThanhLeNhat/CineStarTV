<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% request.setAttribute("pageTitle", "Quản lý rạp - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-building text-danger me-2"></i>Quản lý rạp chiếu</h2>
            <a href="${pageContext.request.contextPath}/CinemaController?action=cinemaAdd" class="btn btn-danger">
                <i class="fas fa-plus me-2"></i>Thêm rạp
            </a>
        </div>

        <c:if test="${param.msg == 'added'}"><div class="alert alert-success">Thêm rạp thành công!</div></c:if>
        <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Cập nhật rạp thành công!</div></c:if>
        <c:if test="${param.msg == 'deleted'}"><div class="alert alert-warning">Đã xóa rạp.</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

        <div style="overflow-x:auto;">
            <table class="csn-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tên rạp</th>
                        <th>Địa chỉ</th>
                        <th>Thành phố</th>
                        <th>Điện thoại</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cinema" items="${cinemas}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td class="text-white fw-semibold">${cinema.cinemaName}</td>
                            <td class="text-muted">${cinema.address}</td>
                            <td>${cinema.city}</td>
                            <td>${cinema.phone}</td>
                            <td>
                                <span class="badge ${cinema.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                    ${cinema.status == 'ACTIVE' ? 'Hoạt động' : 'Ngừng hoạt động'}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/CinemaController?action=screenList&cinemaId=${cinema.cinemaId}"
                                   class="btn btn-sm btn-outline-info me-1" title="Phòng chiếu">
                                    <i class="fas fa-door-open"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/CinemaController?action=cinemaEdit&id=${cinema.cinemaId}"
                                   class="btn btn-sm btn-outline-warning me-1" title="Sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/CinemaController?action=cinemaDelete&id=${cinema.cinemaId}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xác nhận xóa rạp này? Tất cả phòng chiếu sẽ bị xóa theo.')"
                                   title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty cinemas}">
                        <tr><td colspan="7" class="text-center text-muted py-4">Chưa có rạp nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
