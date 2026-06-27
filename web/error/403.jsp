<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("pageTitle", "403 - Không có quyền"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>
<div class="d-flex flex-column align-items-center justify-content-center" style="min-height:60vh;">
    <h1 class="display-1 text-danger fw-bold">403</h1>
    <h3 class="text-white">Bạn không có quyền truy cập trang này.</h3>
    <a href="${pageContext.request.contextPath}/HomeController" class="btn btn-danger mt-3">Về trang chủ</a>
</div>
<%@ include file="../common/footer.jsp" %>
