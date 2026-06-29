<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", (not empty post ? post.title : "Bài viết") + " - CineStarTV"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<div class="container py-5">
    <c:choose>
        <c:when test="${not empty post}">
            <div class="row">
                <div class="col-md-8">
                    <div class="csn-form-card">
                        <div class="mb-3">
                            <span class="badge ${post.category == 'NEWS' ? 'bg-info' : post.category == 'PROMOTION' ? 'bg-warning text-dark' : 'bg-success'}">
                                ${post.category == 'NEWS' ? 'Tin tức' : post.category == 'PROMOTION' ? 'Khuyến mãi' : 'Sự kiện'}
                            </span>
                        </div>
                        <h1 class="text-white mb-3" style="font-size:1.8rem;">${post.title}</h1>
                        <div class="text-muted mb-4">
                            <i class="fas fa-user me-1"></i>${post.user.fullName}
                            <span class="ms-3"><i class="fas fa-clock me-1"></i>
                                <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                        <c:if test="${not empty post.thumbnailUrl}">
                            <img src="${post.thumbnailUrl}" alt="${post.title}" class="img-fluid rounded mb-4"
                                 style="max-height:400px;width:100%;object-fit:cover;"
                                 onerror="this.style.display='none'"/>
                        </c:if>
                        <div class="text-light" style="line-height:1.8;white-space:pre-wrap;">${post.content}</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <h5 class="text-white mb-3">Bài viết liên quan</h5>
                    <c:forEach var="rp" items="${relatedPosts}">
                        <a href="${pageContext.request.contextPath}/BlogPostController?action=blogDetail&id=${rp.postId}"
                           class="card bg-dark border-secondary text-decoration-none d-block mb-3 movie-card">
                            <div class="card-body py-3">
                                <h6 class="card-title text-white mb-1">${rp.title}</h6>
                                <small class="text-muted">
                                    <fmt:formatDate value="${rp.createdAt}" pattern="dd/MM/yyyy"/>
                                </small>
                            </div>
                        </a>
                    </c:forEach>
                    <c:if test="${empty relatedPosts}">
                        <p class="text-muted">Không có bài viết liên quan.</p>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/BlogPostController?action=blogList"
                       class="btn btn-outline-secondary w-100 mt-2">
                        <i class="fas fa-arrow-left me-2"></i>Tất cả bài viết
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-danger">Không tìm thấy bài viết.</div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
