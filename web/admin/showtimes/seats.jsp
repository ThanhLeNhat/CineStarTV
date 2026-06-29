<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% request.setAttribute("pageTitle", "Quản lý ghế - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex align-items-center gap-3 mb-4">
            <a href="${pageContext.request.contextPath}/CinemaController?action=screenList&cinemaId=${screen.cinema.cinemaId}"
               class="btn btn-outline-secondary btn-sm"><i class="fas fa-arrow-left"></i></a>
            <h2 class="text-white mb-0">
                <i class="fas fa-chair text-danger me-2"></i>
                Ghế — ${screen.screenName} (${screen.cinema.cinemaName})
            </h2>
        </div>

        <c:if test="${param.msg == 'generated'}"><div class="alert alert-success">Tạo ghế thành công!</div></c:if>
        <c:if test="${param.msg == 'deleted'}"><div class="alert alert-warning">Đã xóa ghế.</div></c:if>

        <div class="row g-4">
            <!-- Form tạo ghế tự động -->
            <div class="col-md-4">
                <div class="csn-form-card">
                    <h5 class="text-white mb-3">Tạo ghế tự động</h5>
                    <p class="text-muted small">Tự động tạo ghế theo số hàng và số cột. Hàng cuối sẽ là ghế VIP.</p>
                    <form action="${pageContext.request.contextPath}/ShowtimeController" method="post">
                        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                        <input type="hidden" name="action" value="seatGenerate">
                        <input type="hidden" name="screenId" value="${screen.screenId}">
                        <div class="mb-3">
                            <label class="form-label">Số hàng (A-L, tối đa 12)</label>
                            <input type="number" name="rows" class="form-control" min="1" max="12" value="8" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số ghế mỗi hàng</label>
                            <input type="number" name="cols" class="form-control" min="1" max="20" value="10" required>
                        </div>
                        <button type="submit" class="btn btn-danger w-100"
                                onclick="return confirm('Tạo ghế sẽ xóa toàn bộ ghế cũ. Tiếp tục?')">
                            <i class="fas fa-magic me-2"></i>Tạo ghế
                        </button>
                    </form>
                </div>
            </div>

            <!-- Sơ đồ ghế -->
            <div class="col-md-8">
                <c:if test="${not empty seats}">
                    <div class="text-center mb-3">
                        <div class="bg-secondary text-white rounded py-2 px-4 d-inline-block mb-3">MÀN HÌNH</div>
                        <div>
                            <c:set var="currentRow" value=""/>
                            <c:forEach var="seat" items="${seats}">
                                <c:if test="${seat.seatRow != currentRow}">
                                    <c:if test="${currentRow != ''}"></div></c:if>
                                    <div class="d-flex justify-content-center gap-1 mb-1">
                                    <c:set var="currentRow" value="${seat.seatRow}"/>
                                    <span class="text-muted me-2" style="width:20px;line-height:32px;">${seat.seatRow}</span>
                                </c:if>
                                <span class="badge ${seat.seatType == 'VIP' ? 'bg-warning text-dark' : 'bg-secondary'}"
                                      style="width:32px;height:32px;line-height:20px;cursor:pointer;"
                                      title="${seat.seatRow}${seat.seatNumber} - ${seat.seatType}">
                                    ${seat.seatNumber}
                                </span>
                            </c:forEach>
                            </div>
                        </div>
                        <div class="mt-3 d-flex justify-content-center gap-3">
                            <span><span class="badge bg-secondary me-1">■</span>Thường</span>
                            <span><span class="badge bg-warning text-dark me-1">■</span>VIP</span>
                        </div>
                    </div>
                    <p class="text-center text-muted">Tổng: ${seats.size()} ghế</p>
                </c:if>
                <c:if test="${empty seats}">
                    <div class="text-center text-muted py-5">
                        <i class="fas fa-chair fa-3x mb-3"></i>
                        <p>Phòng này chưa có ghế. Dùng form bên trái để tạo ghế tự động.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
