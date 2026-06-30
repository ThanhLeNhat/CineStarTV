<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("pageTitle", "Hệ thống rạp chiếu"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <h2 class="text-white mb-4"><i class="fas fa-building text-danger me-2"></i>Hệ thống rạp chiếu</h2>

    <div class="row g-4">
        <c:forEach var="cinema" items="${cinemas}">
            <div class="col-md-6 col-lg-4">
                <div class="csn-card h-100">
                    <c:if test="${not empty cinema.imageUrl}">
                        <img src="${cinema.imageUrl}" alt="${cinema.cinemaName}"
                             style="width:100%;height:180px;object-fit:cover;border-radius:8px 8px 0 0;"
                             onerror="this.onerror=null;this.style.display='none'">
                    </c:if>
                    <div class="p-3">
                        <h5 class="text-white mb-1">${cinema.cinemaName}</h5>
                        <p class="text-muted small mb-1"><i class="fas fa-map-marker-alt me-1"></i>${cinema.address}</p>
                        <p class="text-muted small mb-3"><i class="fas fa-city me-1"></i>${cinema.city}</p>
                        <a href="${pageContext.request.contextPath}/CinemaController?action=cinemaDetail&id=${cinema.cinemaId}"
                           class="btn btn-outline-danger btn-sm w-100">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty cinemas}">
            <div class="col-12 text-center text-muted py-5">Chưa có rạp nào.</div>
        </c:if>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
