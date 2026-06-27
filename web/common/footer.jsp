<%-- common/footer.jsp --%>
<footer class="csn-footer mt-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <h5><i class="fas fa-film text-danger me-2"></i>CineStarTV</h5>
                <p>Hệ thống rạp chiếu phim hiện đại hàng đầu Việt Nam.</p>
                <div class="social mt-3">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-youtube"></i></a>
                    <a href="#"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>
            <div class="col-md-4">
                <h5>Khám phá</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/MovieController">Phim đang chiếu</a></li>
                    <li><a href="${pageContext.request.contextPath}/MainController?action=cinemaList">Hệ thống rạp</a></li>
                    <li><a href="${pageContext.request.contextPath}/MainController?action=blogList">Tin tức</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5>Liên hệ</h5>
                <ul class="list-unstyled">
                    <li><i class="fas fa-phone me-2 text-danger"></i>1900 6789</li>
                    <li><i class="fas fa-envelope me-2 text-danger"></i>cinestarthanhvy@gmail.com</li>
                    <li><i class="fas fa-map-marker-alt me-2 text-danger"></i>TP. Hồ Chí Minh</li>
                </ul>
            </div>
        </div>
    </div>
    <div class="csn-footer-bottom">
        <p>&copy; 2026 CineStarTV. All rights reserved. | PRJ301 - SE2041</p>
    </div>
</footer>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
