<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("pageTitle", "500 - Lỗi server"); %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>
<div class="d-flex flex-column align-items-center justify-content-center" style="min-height:60vh;">
    <h1 class="display-1 text-danger fw-bold">500</h1>
    <h3 class="text-white">Đã xảy ra lỗi phía server.</h3>
    <a href="${pageContext.request.contextPath}/HomeController" class="btn btn-danger mt-3">Về trang chủ</a>
</div>
<%@ include file="../common/footer.jsp" %>
