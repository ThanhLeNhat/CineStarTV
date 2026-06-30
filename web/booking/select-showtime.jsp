<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Chọn suất chiếu - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<style>
.date-btn {
    min-width: 60px; padding: 6px 10px; border: 1px solid #333;
    border-radius: 8px; background: #1a1a1a; color: #aaa;
    text-align: center; cursor: pointer; text-decoration: none;
    transition: all .15s; display: inline-block;
}
.date-btn:hover { border-color: #e50914; color: #e50914; }
.date-btn.active { background: #e50914; border-color: #e50914; color: #fff; }
.date-btn .day-num { font-size: 1.3rem; font-weight: 700; line-height: 1; }
.date-btn .day-label { font-size: .65rem; }
.city-tab { padding: 6px 18px; border-radius: 20px; border: 1px solid #333;
    background: transparent; color: #aaa; cursor: pointer; text-decoration: none; font-size: .9rem; }
.city-tab:hover { border-color: #e50914; color: #e50914; }
.city-tab.active { background: #e50914; border-color: #e50914; color: #fff; }
</style>

<div class="container py-5">
    <c:if test="${not empty movie}">
        <!-- Thông tin phim -->
        <div class="csn-form-card mb-4">
            <div class="row g-4 align-items-center">
                <div class="col-md-2">
                    <img src="${not empty movie.posterUrl ? pageContext.request.contextPath.concat(movie.posterUrl) : pageContext.request.contextPath.concat('/images/no-poster.jpg')}"
                         alt="${movie.title}" class="img-fluid rounded"
                         style="width:100%;object-fit:cover;border-radius:8px;">
                </div>
                <div class="col-md-10">
                    <h3 class="text-white mb-1">${movie.title}</h3>
                    <p class="text-muted mb-2">${movie.titleEn}</p>
                    <div class="d-flex gap-3 flex-wrap align-items-center">
                        <span class="badge ${movie.ageRating == 'P' ? 'bg-success' : movie.ageRating == 'C13' ? 'bg-warning text-dark' : 'bg-danger'}">${movie.ageRating}</span>
                        <span class="text-white"><i class="fas fa-clock me-1 text-danger"></i>${movie.duration} phút</span>
                        <span class="text-warning"><i class="fas fa-star me-1"></i>${movie.rating}/10</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chọn ngày (30 ngày tới) -->
        <div class="mb-4">
            <p class="text-muted small mb-2">CHỌN NGÀY</p>
            <div class="d-flex gap-2 flex-wrap">
                <%
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                    java.text.SimpleDateFormat dayName = new java.text.SimpleDateFormat("EEE", new java.util.Locale("vi","VN"));
                    java.text.SimpleDateFormat dayNum  = new java.text.SimpleDateFormat("dd");
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    String selectedDate = (String) request.getAttribute("selectedDate");
                    int movieId = ((model.MovieDTO) request.getAttribute("movie")).getMovieId();
                    String selectedCity = (String) request.getAttribute("selectedCity");
                    for (int i = 0; i < 30; i++) {
                        String dateStr = sdf.format(cal.getTime());
                        String dayN = dayName.format(cal.getTime());
                        String dayD = dayNum.format(cal.getTime());
                        boolean isActive = dateStr.equals(selectedDate);
                        String href = request.getContextPath() + "/BookingController?action=selectShowtime&movieId=" + movieId
                                + "&date=" + dateStr + (selectedCity != null ? "&city=" + java.net.URLEncoder.encode(selectedCity,"UTF-8") : "");
                %>
                <a href="<%= href %>" class="date-btn <%= isActive ? "active" : "" %>">
                    <div class="day-label"><%= dayN %></div>
                    <div class="day-num"><%= dayD %></div>
                </a>
                <% cal.add(java.util.Calendar.DATE, 1); } %>
            </div>
        </div>

        <!-- Tab thành phố -->
        <c:if test="${not empty cities}">
            <div class="mb-4">
                <p class="text-muted small mb-2">CHỌN THÀNH PHỐ</p>
                <div class="d-flex gap-2 flex-wrap">
                    <c:forEach var="city" items="${cities}">
                        <a href="${pageContext.request.contextPath}/BookingController?action=selectShowtime&movieId=${movie.movieId}&date=${selectedDate}&city=${city}"
                           class="city-tab ${city == selectedCity ? 'active' : ''}">
                            ${city}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Suất chiếu group theo rạp -->
        <c:choose>
            <c:when test="${not empty showtimes}">
                <c:set var="lastCinemaId" value="-1"/>
                <c:forEach var="st" items="${showtimes}">
                    <c:if test="${st.screen.cinema.cinemaId != lastCinemaId}">
                        <c:if test="${lastCinemaId != -1}"></div></div></c:if>
                        <div class="csn-form-card mb-3">
                            <div class="d-flex align-items-start gap-3 mb-3">
                                <i class="fas fa-building text-danger mt-1"></i>
                                <div>
                                    <h5 class="text-white mb-0">${st.screen.cinema.cinemaName}</h5>
                                    <small class="text-muted"><i class="fas fa-map-marker-alt me-1"></i>${st.screen.cinema.address}</small>
                                </div>
                            </div>
                            <div class="d-flex gap-2 flex-wrap">
                        <c:set var="lastCinemaId" value="${st.screen.cinema.cinemaId}"/>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/BookingController?action=selectSeat&showtimeId=${st.showtimeId}"
                       class="date-btn text-center" style="min-width:80px;">
                        <div style="font-size:1.1rem;font-weight:700;">${st.startTime}</div>
                        <div style="font-size:.7rem;color:#aaa;">${st.screen.screenType}</div>
                        <div style="font-size:.75rem;color:#e50914;"><fmt:formatNumber value="${st.basePrice}" pattern="#,###"/>đ</div>
                    </a>
                </c:forEach>
                <c:if test="${lastCinemaId != -1}"></div></div></c:if>
            </c:when>
            <c:otherwise>
                <div class="csn-form-card text-center py-5">
                    <i class="fas fa-calendar-times fa-3x text-muted mb-3 d-block"></i>
                    <p class="text-muted">Không có suất chiếu nào vào ngày này tại khu vực đã chọn.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
