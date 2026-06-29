<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Chọn ghế - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<style>
    .seat-map { display: flex; flex-direction: column; align-items: center; gap: 6px; }
    .seat-row { display: flex; gap: 6px; align-items: center; }
    .seat-row-label { width: 25px; text-align: center; color: #888; font-weight: 600; font-size: .85rem; }
    .seat-btn {
        width: 36px; height: 36px; border: 2px solid #444; border-radius: 6px;
        background: #1a1a1a; color: #ccc; font-size: .7rem; cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        transition: all .15s;
    }
    .seat-btn:hover:not(.booked):not(:disabled) { border-color: #e50914; color: #e50914; }
    .seat-btn.selected { background: #e50914; border-color: #e50914; color: #fff; }
    .seat-btn.booked { background: #333; border-color: #333; color: #555; cursor: not-allowed; }
    .seat-btn.vip { border-color: #ffc107; }
    .seat-btn.sweetbox { border-color: #e91e63; }
    .screen-indicator {
        width: 60%; max-width: 500px; height: 6px; background: linear-gradient(90deg, transparent, #e50914, transparent);
        border-radius: 50%; margin: 0 auto 2rem; text-align: center;
    }
    .seat-legend { display: flex; gap: 1.5rem; justify-content: center; margin-top: 1.5rem; flex-wrap: wrap; }
    .seat-legend-item { display: flex; align-items: center; gap: 6px; color: #aaa; font-size: .85rem; }
    .seat-legend-box { width: 20px; height: 20px; border-radius: 4px; border: 2px solid; }
</style>

<div class="container py-5">
    <h2 class="text-white mb-2">
        <i class="fas fa-chair text-danger me-2"></i>Chọn ghế ngồi
    </h2>
    <c:if test="${not empty showtime}">
        <p class="text-muted mb-4">
            <strong class="text-white">${showtime.movie.title}</strong> —
            <fmt:formatDate value="${showtime.showDate}" pattern="dd/MM/yyyy"/>
            • ${showtime.startTime} — ${showtime.endTime}
            • ${showtime.screen.screenName} (${showtime.screen.screenType})
        </p>

        <form action="${pageContext.request.contextPath}/BookingController" method="POST" id="seatForm">
            <input type="hidden" name="action" value="confirmBooking"/>
            <input type="hidden" name="showtimeId" value="${showtime.showtimeId}"/>

            <!-- Màn hình -->
            <div class="text-center text-muted small mb-1">MÀN HÌNH</div>
            <div class="screen-indicator"></div>

            <!-- Sơ đồ ghế -->
            <div class="seat-map mb-4">
                <c:set var="currentRow" value=""/>
                <c:forEach var="seat" items="${seats}">
                    <c:if test="${seat.seatRow != currentRow}">
                        <c:if test="${not empty currentRow}">
                            </div> <%-- đóng row cũ --%>
                        </c:if>
                        <div class="seat-row">
                            <div class="seat-row-label">${seat.seatRow}</div>
                        <c:set var="currentRow" value="${seat.seatRow}"/>
                    </c:if>

                    <c:choose>
                        <c:when test="${seat.booked}">
                            <div class="seat-btn booked" title="Đã đặt">✕</div>
                        </c:when>
                        <c:otherwise>
                            <label class="seat-btn ${seat.seatType == 'VIP' ? 'vip' : seat.seatType == 'SWEETBOX' ? 'sweetbox' : ''}"
                                   title="${seat.label} (${seat.seatType})" id="label-${seat.seatId}">
                                <input type="checkbox" name="seatIds" value="${seat.seatId}"
                                       style="display:none;" onchange="toggleSeat(this, ${seat.seatId})"/>
                                ${seat.seatNumber}
                            </label>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${not empty currentRow}">
                    </div>
                </c:if>
            </div>

            <!-- Legend -->
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
                <div class="seat-legend-item">
                    <div class="seat-legend-box" style="background:#e50914;border-color:#e50914;"></div>Đang chọn
                </div>
                <div class="seat-legend-item">
                    <div class="seat-legend-box" style="background:#333;border-color:#333;"></div>Đã đặt
                </div>
            </div>

            <!-- Thông tin chọn -->
            <div class="csn-form-card mt-4">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <p class="text-muted mb-1">Ghế đã chọn:</p>
                        <div id="selectedSeatsDisplay" class="text-white fw-bold">Chưa chọn ghế</div>
                    </div>
                    <div class="col-md-3">
                        <p class="text-muted mb-1">Tạm tính:</p>
                        <div id="totalPriceDisplay" class="text-danger fw-bold" style="font-size:1.2rem;">0đ</div>
                    </div>
                    <div class="col-md-3 text-end">
                        <button type="submit" class="btn btn-danger btn-lg" id="btnContinue" disabled>
                            <i class="fas fa-arrow-right me-2"></i>Tiếp tục
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var basePrice = ${showtime.basePrice};
    var seatPrices = {};
    <c:forEach var="seat" items="${seats}">
        <c:if test="${!seat.booked}">
            seatPrices[${seat.seatId}] = {label: '${seat.label}', multiplier: ${seat.priceMultiplier}};
        </c:if>
    </c:forEach>

    function toggleSeat(cb, seatId) {
        var label = document.getElementById('label-' + seatId);
        if (cb.checked) {
            label.classList.add('selected');
        } else {
            label.classList.remove('selected');
        }
        updateSummary();
    }

    function updateSummary() {
        var checkboxes = document.querySelectorAll('input[name="seatIds"]:checked');
        var labels = [];
        var total = 0;
        checkboxes.forEach(function(cb) {
            var id = parseInt(cb.value);
            if (seatPrices[id]) {
                labels.push(seatPrices[id].label);
                total += basePrice * seatPrices[id].multiplier;
            }
        });
        document.getElementById('selectedSeatsDisplay').textContent = labels.length > 0 ? labels.join(', ') : 'Chưa chọn ghế';
        document.getElementById('totalPriceDisplay').textContent = total.toLocaleString('vi-VN') + 'đ';
        document.getElementById('btnContinue').disabled = labels.length === 0;
    }
</script>
</body>
</html>
