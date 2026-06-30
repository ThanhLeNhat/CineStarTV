<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% request.setAttribute("pageTitle", "Quản lý ghế - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<style>
    .seat-map { display: flex; flex-direction: column; align-items: center; gap: 6px; }
    .seat-row { display: flex; gap: 6px; align-items: center; }
    .seat-row-label { width: 25px; text-align: center; color: #888; font-weight: 600; font-size: .85rem; }
    .seat-btn {
        width: 36px; height: 36px; border: 2px solid #444; border-radius: 6px;
        background: #1a1a1a; color: #ccc; font-size: .7rem;
        display: flex; align-items: center; justify-content: center;
    }
    .seat-btn.vip { border-color: #ffc107; color: #ffc107; }
    .seat-btn.sweetbox { border-color: #e91e63; color: #e91e63; }
    .screen-indicator {
        width: 60%; max-width: 500px; height: 6px;
        background: linear-gradient(90deg, transparent, #e50914, transparent);
        border-radius: 50%; margin: 0 auto 2rem;
    }
    .seat-legend { display: flex; gap: 1.5rem; justify-content: center; margin-top: 1.5rem; flex-wrap: wrap; }
    .seat-legend-item { display: flex; align-items: center; gap: 6px; color: #aaa; font-size: .85rem; }
    .seat-legend-box { width: 20px; height: 20px; border-radius: 4px; border: 2px solid; }
</style>

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
            <!-- Form tạo ghế -->
            <div class="col-md-3">
                <div class="csn-form-card">
                    <h5 class="text-white mb-3">Tạo ghế tự động</h5>
                    <p class="text-muted small">Hàng cuối: Sweetbox. Hai hàng trước cuối: VIP. Còn lại: Standard.</p>
                    <form action="${pageContext.request.contextPath}/ShowtimeController" method="post">
                        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
                        <input type="hidden" name="action" value="seatGenerate">
                        <input type="hidden" name="screenId" value="${screen.screenId}">
                        <div class="mb-3">
                            <label class="form-label">Số hàng (tối đa 12)</label>
                            <input type="number" name="rows" class="form-control" min="3" max="12" value="8" required>
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
            <div class="col-md-9">
                <c:if test="${not empty seats}">
                    <div class="text-center text-muted small mb-1">MÀN HÌNH</div>
                    <div class="screen-indicator"></div>

                    <div class="seat-map">
                        <c:set var="currentRow" value=""/>
                        <c:forEach var="seat" items="${seats}">
                            <c:if test="${seat.seatRow != currentRow}">
                                <c:if test="${not empty currentRow}"></div></c:if>
                                <div class="seat-row">
                                    <div class="seat-row-label">${seat.seatRow}</div>
                                <c:set var="currentRow" value="${seat.seatRow}"/>
                            </c:if>
                            <div class="seat-btn ${seat.seatType == 'VIP' ? 'vip' : seat.seatType == 'SWEETBOX' ? 'sweetbox' : ''}"
                                 title="${seat.seatRow}${seat.seatNumber} - ${seat.seatType}">
                                ${seat.seatNumber}
                            </div>
                        </c:forEach>
                        <c:if test="${not empty currentRow}"></div></c:if>
                    </div>

                    <div class="seat-legend">
                        <div class="seat-legend-item">
                            <div class="seat-legend-box" style="background:#1a1a1a;border-color:#444;"></div>Standard
                        </div>
                        <div class="seat-legend-item">
                            <div class="seat-legend-box" style="background:#1a1a1a;border-color:#ffc107;"></div>VIP (x1.3)
                        </div>
                        <div class="seat-legend-item">
                            <div class="seat-legend-box" style="background:#1a1a1a;border-color:#e91e63;"></div>Sweetbox (x1.6)
                        </div>
                    </div>
                    <p class="text-center text-muted mt-3">Tổng: ${seats.size()} ghế</p>
                </c:if>
                <c:if test="${empty seats}">
                    <div class="text-center text-muted py-5">
                        <i class="fas fa-chair fa-3x mb-3 d-block"></i>
                        Phòng này chưa có ghế. Dùng form bên trái để tạo ghế tự động.
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
