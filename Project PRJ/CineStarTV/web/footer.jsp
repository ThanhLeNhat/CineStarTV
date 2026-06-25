<%-- 
    Document   : footer
    Created on : Jun 24, 2026, 3:13:44 AM
    Author     : TRI VY
--%>

<%-- 
    footer.jsp — Chân trang chung
    Chứa: thông tin liên hệ, links, copyright, JS scripts
    Dùng: <%@ include file="footer.jsp" %>
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<footer class="footer">
    <div class="footer-container">
        <!-- Cột 1: Giới thiệu -->
        <div class="footer-col">
            <h3><i class="fas fa-film"></i> CineStarTV</h3>
            <p>Hệ thống rạp chiếu phim hiện đại hàng đầu Việt Nam. 
               Trải nghiệm điện ảnh đỉnh cao với công nghệ IMAX, 4DX.</p>
            <div class="footer-social">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-youtube"></i></a>
                <a href="#"><i class="fab fa-tiktok"></i></a>
            </div>
        </div>

        <!-- Cột 2: Links nhanh -->
        <div class="footer-col">
            <h3>Khám phá</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/MainController?action=movieList">Phim đang chiếu</a></li>
                <li><a href="${pageContext.request.contextPath}/MainController?action=cinemaList">Hệ thống rạp</a></li>
                <li><a href="${pageContext.request.contextPath}/MainController?action=blogList">Tin tức & Ưu đãi</a></li>
                <li><a href="#">Giá vé</a></li>
            </ul>
        </div>

        <!-- Cột 3: Chính sách -->
        <div class="footer-col">
            <h3>Chính sách</h3>
            <ul>
                <li><a href="#">Điều khoản sử dụng</a></li>
                <li><a href="#">Chính sách bảo mật</a></li>
                <li><a href="#">Chính sách thanh toán</a></li>
                <li><a href="#">FAQ</a></li>
            </ul>
        </div>

        <!-- Cột 4: Liên hệ -->
        <div class="footer-col">
            <h3>Liên hệ</h3>
            <ul class="footer-contact">
                <li><i class="fas fa-phone"></i> 1900 6789</li>
                <li><i class="fas fa-envelope"></i> cinestarthanhvy@gmail.com</li>
                <li><i class="fas fa-map-marker-alt"></i> TP. Hồ Chí Minh, Việt Nam</li>
            </ul>
        </div>
    </div>

    <!-- Copyright -->
    <div class="footer-bottom">
        <p>&copy; 2026 CineStarTV. All rights reserved. | PRJ301 - SE2041</p>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle (with Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Validation JS -->
<script src="${pageContext.request.contextPath}/js/validation.js"></script>

<!-- Main JS -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>