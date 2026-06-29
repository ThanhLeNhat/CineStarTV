<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Gửi thông báo - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <h2 class="text-white mb-4"><i class="fas fa-bell text-danger me-2"></i>Gửi thông báo</h2>

        <c:if test="${param.msg == 'sent'}">
            <div class="alert alert-success">Đã gửi thông báo thành công!</div>
        </c:if>

        <div class="csn-form-card" style="max-width:700px;">
            <form action="${pageContext.request.contextPath}/NotificationController" method="POST">
                <input type="hidden" name="action" value="sendNotification"/>

                <div class="mb-3">
                    <label class="form-label">Gửi đến</label>
                    <select name="targetUserId" class="form-select" required>
                        <option value="all">📢 Tất cả người dùng</option>
                        <c:forEach var="u" items="${users}">
                            <option value="${u.userId}">${u.fullName} (${u.email})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label class="form-label">Tiêu đề *</label>
                        <input type="text" class="form-control" name="title" required placeholder="VD: Khuyến mãi cuối tuần"/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Loại</label>
                        <select name="type" class="form-select">
                            <option value="SYSTEM">Hệ thống</option>
                            <option value="BOOKING">Đặt vé</option>
                            <option value="PAYMENT">Thanh toán</option>
                            <option value="INFO">Thông tin</option>
                        </select>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nội dung *</label>
                    <textarea class="form-control" name="message" rows="5" required
                              placeholder="Nội dung thông báo..."></textarea>
                </div>
                <button type="submit" class="btn btn-danger"
                        onclick="return confirm('Xác nhận gửi thông báo?')">
                    <i class="fas fa-paper-plane me-2"></i>Gửi thông báo
                </button>
            </form>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
