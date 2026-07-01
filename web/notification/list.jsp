<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Thông báo - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-white mb-0">
            <i class="fas fa-bell text-danger me-2"></i>Thông báo
            <c:if test="${unreadCount > 0}">
                <span class="badge bg-danger ms-2">${unreadCount}</span>
            </c:if>
        </h2>
        <c:if test="${unreadCount > 0}">
            <a href="${pageContext.request.contextPath}/NotificationController?action=markAllRead"
               class="btn btn-sm btn-outline-secondary">
                <i class="fas fa-check-double me-1"></i>Đánh dấu tất cả đã đọc
            </a>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${not empty notifications}">
            <div class="d-flex flex-column gap-3">
                <c:forEach var="n" items="${notifications}">
                    <div class="csn-form-card d-flex gap-3 align-items-start ${n.read ? '' : 'border-start border-danger border-3'}"
                         style="${n.read ? 'opacity:.7;' : ''}">
                        <div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0"
                             style="width:42px;height:42px;background:rgba(229,9,20,.15);">
                            <i class="fas ${n.type == 'BOOKING' ? 'fa-ticket-alt' : n.type == 'PAYMENT' ? 'fa-credit-card' : n.type == 'SYSTEM' ? 'fa-bullhorn' : 'fa-info-circle'} text-danger" style="font-size:1.1rem;"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between align-items-start">
                                <h6 class="text-white mb-1 ${n.read ? '' : 'fw-bold'}">${n.title}</h6>
                                <small class="text-muted">
                                    <fmt:formatDate value="${n.createdAt}" pattern="dd/MM HH:mm"/>
                                </small>
                            </div>
                            <p class="text-muted small mb-2">${n.message}</p>
                            <div class="d-flex gap-2">
                                <c:if test="${!n.read}">
                                    <a href="${pageContext.request.contextPath}/NotificationController?action=markRead&id=${n.notificationId}"
                                       class="btn btn-sm btn-outline-secondary">
                                        <i class="fas fa-check me-1"></i>Đã đọc
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/NotificationController?action=deleteNotification&id=${n.notificationId}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Xóa thông báo này?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="csn-form-card text-center py-5">
                <i class="fas fa-bell-slash text-muted" style="font-size:3rem;"></i>
                <p class="text-muted mt-3">Bạn chưa có thông báo nào.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
