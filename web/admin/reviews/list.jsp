<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Quản lý đánh giá - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <h2 class="text-white mb-4"><i class="fas fa-star text-danger me-2"></i>Quản lý đánh giá</h2>

        <c:if test="${param.msg == 'hidden'}"><div class="alert alert-warning">Đã ẩn đánh giá.</div></c:if>
        <c:if test="${param.msg == 'shown'}"><div class="alert alert-success">Đã hiện lại đánh giá.</div></c:if>

        <div style="overflow-x:auto;">
            <table class="csn-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Người dùng</th>
                        <th>Phim</th>
                        <th>Điểm</th>
                        <th>Nhận xét</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${reviews}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td>${r.user.fullName}</td>
                            <td>${r.movie.title}</td>
                            <td>
                                <span class="text-warning"><i class="fas fa-star me-1"></i>${r.rating}/10</span>
                            </td>
                            <td>
                                <div style="max-width:300px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                    ${r.comment}
                                </div>
                            </td>
                            <td>
                                <span class="badge ${r.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                    ${r.status == 'ACTIVE' ? 'Hiển thị' : 'Đã ẩn'}
                                </span>
                            </td>
                            <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status == 'ACTIVE'}">
                                        <a href="${pageContext.request.contextPath}/ReviewController?action=hideReview&reviewId=${r.reviewId}"
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Xác nhận ẩn đánh giá này?')" title="Ẩn">
                                            <i class="fas fa-eye-slash"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/ReviewController?action=showReview&reviewId=${r.reviewId}"
                                           class="btn btn-sm btn-outline-success" title="Hiện lại">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty reviews}">
                        <tr><td colspan="8" class="text-center text-muted py-4">Chưa có đánh giá nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
