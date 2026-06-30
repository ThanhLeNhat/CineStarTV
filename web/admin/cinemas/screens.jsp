<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% request.setAttribute("pageTitle", "Quản lý phòng chiếu - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex align-items-center gap-3 mb-4">
            <a href="${pageContext.request.contextPath}/CinemaController?action=cinemaList"
               class="btn btn-outline-secondary btn-sm"><i class="fas fa-arrow-left"></i></a>
            <h2 class="text-white mb-0">
                <i class="fas fa-door-open text-danger me-2"></i>
                Phòng chiếu — ${cinema.cinemaName}
            </h2>
        </div>

        <c:if test="${param.msg == 'added'}"><div class="alert alert-success">Thêm phòng thành công!</div></c:if>
        <c:if test="${param.msg == 'deleted'}"><div class="alert alert-warning">Đã xóa phòng chiếu.</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

        <div class="row g-4">
            <!-- Form thêm phòng -->
            <div class="col-md-4">
                <div class="csn-form-card">
                    <h5 class="text-white mb-3">Thêm phòng chiếu</h5>
                    <form action="${pageContext.request.contextPath}/CinemaController" method="post">
                        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                        <input type="hidden" name="action" value="screenDoAdd">
                        <input type="hidden" name="cinemaId" value="${cinema.cinemaId}">
                        <div class="mb-3">
                            <label class="form-label">Tên phòng *</label>
                            <input type="text" name="screenName" class="form-control" required
                                   placeholder="Phòng 1, Screen A...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Loại phòng</label>
                            <select name="screenType" class="form-select">
                                <option value="2D">2D</option>
                                <option value="3D">3D</option>
                                <option value="IMAX">IMAX</option>
                                <option value="4DX">4DX</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Sức chứa (ghế)</label>
                            <input type="number" name="capacity" class="form-control"
                                   min="10" max="500" value="100">
                        </div>
                        <button type="submit" class="btn btn-danger w-100">
                            <i class="fas fa-plus me-2"></i>Thêm phòng
                        </button>
                    </form>
                </div>
            </div>

            <!-- Danh sách phòng -->
            <div class="col-md-8">
                <div style="overflow-x:auto;">
                    <table class="csn-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tên phòng</th>
                                <th>Loại</th>
                                <th>Sức chứa</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="screen" items="${screens}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td class="text-white">${screen.screenName}</td>
                                    <td><span class="badge bg-info text-dark">${screen.screenType}</span></td>
                                    <td>${screen.capacity} ghế</td>
                                    <td>
                                        <span class="badge ${screen.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                            ${screen.status == 'ACTIVE' ? 'Hoạt động' : 'Bảo trì'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/ShowtimeController?action=seatList&screenId=${screen.screenId}"
                                           class="btn btn-sm btn-outline-info me-1" title="Quản lý ghế">
                                            <i class="fas fa-chair"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/CinemaController?action=screenDelete&id=${screen.screenId}&cinemaId=${cinema.cinemaId}"
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Xác nhận xóa phòng này?')" title="Xóa">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty screens}">
                                <tr><td colspan="6" class="text-center text-muted py-4">Chưa có phòng chiếu nào.</td></tr>
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
