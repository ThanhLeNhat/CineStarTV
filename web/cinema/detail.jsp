<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("pageTitle", "Chi tiết rạp"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">

    <!-- Header rạp -->
    <div class="csn-form-card mb-5">
        <div class="row align-items-center g-4">
            <c:if test="${not empty cinema.imageUrl}">
                <div class="col-md-3">
                    <img src="${cinema.imageUrl}" alt="${cinema.cinemaName}"
                         class="img-fluid rounded shadow"
                         style="width:100%;height:180px;object-fit:cover;"
                         onerror="this.onerror=null;this.style.display='none'">
                </div>
            </c:if>
            <div class="${not empty cinema.imageUrl ? 'col-md-9' : 'col-12'}">
                <h2 class="text-white fw-bold mb-3">
                    <i class="fas fa-building text-danger me-2"></i>${cinema.cinemaName}
                </h2>
                <div class="d-flex flex-column gap-2">
                    <div class="text-white">
                        <i class="fas fa-map-marker-alt text-danger me-2"></i>${cinema.address}, ${cinema.city}
                    </div>
                    <c:if test="${not empty cinema.phone}">
                        <div class="text-white">
                            <i class="fas fa-phone text-danger me-2"></i>${cinema.phone}
                        </div>
                    </c:if>
                    <c:if test="${not empty cinema.description}">
                        <p class="text-muted mb-0 mt-1">${cinema.description}</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Phòng chiếu -->
    <h4 class="text-white mb-4">
        <i class="fas fa-door-open text-danger me-2"></i>Phòng chiếu
    </h4>
    <div class="row g-3">
        <c:forEach var="screen" items="${screens}">
            <div class="col-md-4 col-sm-6">
                <div class="csn-form-card h-100" style="border-left: 3px solid #e50914;">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <h5 class="text-white mb-0 fw-bold">${screen.screenName}</h5>
                        <span class="badge ${screen.screenType == 'IMAX' ? 'bg-warning text-dark' : screen.screenType == '4DX' ? 'bg-danger' : 'bg-info text-dark'}">
                            ${screen.screenType}
                        </span>
                    </div>
                    <div class="text-muted small">
                        <div><i class="fas fa-chair me-2 text-danger"></i>${screen.capacity} ghế</div>
                        <div class="mt-1">
                            <span class="badge ${screen.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'} mt-1">
                                ${screen.status == 'ACTIVE' ? 'Hoạt động' : 'Bảo trì'}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty screens}">
            <div class="col-12">
                <div class="csn-form-card text-center py-4 text-muted">
                    <i class="fas fa-door-open fa-2x mb-2 d-block"></i>Chưa có phòng chiếu nào.
                </div>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
