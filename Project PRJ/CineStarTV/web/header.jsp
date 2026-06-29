<%-- 
    Document   : header
    Created on : Jun 24, 2026, 3:13:54 AM
    Author     : TRI VY
--%>

<%-- 
    header.jsp — Phần <head> chung cho mọi trang
    Chứa: meta tags, CSS links, Google Fonts, favicon
    Dùng: <%@ include file="/common/header.jsp" %>
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="CineStarTV - Hệ thống đặt vé xem phim trực tuyến hàng đầu Việt Nam">
    <meta name="author" content="CineStarTV">

    <title>${pageTitle != null ? pageTitle : 'CineStarTV - Rạp chiếu phim trực tuyến'}</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>