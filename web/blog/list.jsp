<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Tin tức - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <h2 class="text-white mb-4">
        <i class="fas fa-newspaper text-danger me-2"></i>Tin tức & Khuyến mãi
    </h2>

    <!-- Filter danh mục -->
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/BlogPostController?action=blogList"
           class="btn ${empty selectedCategory ? 'btn-danger' : 'btn-outline-secondary'} me-2">Tất cả</a>
        <a href="${pageContext.request.contextPath}/BlogPostController?action=blogList&category=NEWS"
           class="btn ${selectedCategory == 'NEWS' ? 'btn-danger' : 'btn-outline-secondary'} me-2">Tin tức</a>
        <a href="${pageContext.request.contextPath}/BlogPostController?action=blogList&category=PROMOTION"
           class="btn ${selectedCategory == 'PROMOTION' ? 'btn-danger' : 'btn-outline-secondary'} me-2">Khuyến mãi</a>
        <a href="${pageContext.request.contextPath}/BlogPostController?action=blogList&category=EVENT"
           class="btn ${selectedCategory == 'EVENT' ? 'btn-danger' : 'btn-outline-secondary'}">Sự kiện</a>
    </div>

    <c:choose>
        <c:when test="${not empty posts}">
            <div class="row g-4">
                <c:forEach var="post" items="${posts}">
                    <div class="col-md-4">
                        <a href="${pageContext.request.contextPath}/BlogPostController?action=blogDetail&id=${post.postId}"
                           class="card bg-dark border-secondary text-decoration-none d-block movie-card">
                            <c:if test="${not empty post.thumbnailUrl}">
                                <img src="${post.thumbnailUrl}" alt="${post.title}" class="card-img-top"
                                     style="height:200px;object-fit:cover;"
                                     onerror="this.style.display='none'"/>
                            </c:if>
                            <div class="card-body">
                                <span class="badge ${post.category == 'NEWS' ? 'bg-info' : post.category == 'PROMOTION' ? 'bg-warning text-dark' : 'bg-success'} mb-2">
                                    ${post.category == 'NEWS' ? 'Tin tức' : post.category == 'PROMOTION' ? 'Khuyến mãi' : 'Sự kiện'}
                                </span>
                                <h5 class="card-title text-white">${post.title}</h5>
                                <p class="card-text text-muted small">${post.getExcerpt(120)}</p>
                                <div class="text-muted small">
                                    <i class="fas fa-clock me-1"></i>
                                    <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy"/>
                                    <span class="ms-2"><i class="fas fa-user me-1"></i>${post.user.fullName}</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="csn-form-card text-center py-5">
                <i class="fas fa-newspaper text-muted" style="font-size:3rem;"></i>
                <p class="text-muted mt-3">Chưa có bài viết nào.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
