<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", (empty voucher ? "Thêm" : "Sửa").concat(" Voucher - Admin")); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <h2 class="text-white mb-4">
            <i class="fas fa-tag text-danger me-2"></i>
            ${not empty voucher ? 'Sửa Voucher' : 'Thêm Voucher'}
        </h2>

        <div class="csn-form-card" style="max-width:700px;">
            <form action="${pageContext.request.contextPath}/VoucherController" method="POST">
                <input type="hidden" name="action" value="${not empty voucher ? 'voucherDoEdit' : 'voucherDoAdd'}"/>
                <c:if test="${not empty voucher}">
                    <input type="hidden" name="voucherId" value="${voucher.voucherId}"/>
                </c:if>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã voucher *</label>
                        <input type="text" class="form-control" name="code" value="${voucher.code}"
                               required placeholder="VD: SUMMER2026" style="text-transform:uppercase;"/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE" ${voucher.status == 'ACTIVE' || empty voucher ? 'selected' : ''}>Hoạt động</option>
                            <option value="DISABLED" ${voucher.status == 'DISABLED' ? 'selected' : ''}>Đã tắt</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Giảm theo %</label>
                        <input type="number" class="form-control" name="discountPercent"
                               value="${voucher.discountPercent}" min="0" max="100" placeholder="0"/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Giảm theo số tiền (đ)</label>
                        <input type="number" class="form-control" name="discountAmount"
                               value="${voucher.discountAmount}" min="0" placeholder="0"/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Giảm tối đa (đ)</label>
                        <input type="number" class="form-control" name="maxDiscount"
                               value="${voucher.maxDiscount}" min="0" placeholder="Không giới hạn"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Đơn tối thiểu (đ)</label>
                        <input type="number" class="form-control" name="minOrder"
                               value="${voucher.minOrder}" min="0" placeholder="0"/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Số lượng</label>
                        <input type="number" class="form-control" name="quantity"
                               value="${not empty voucher ? voucher.quantity : 100}" min="1" required/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Ngày bắt đầu *</label>
                        <input type="date" class="form-control" name="startDate" required
                               value="<fmt:formatDate value='${voucher.startDate}' pattern='yyyy-MM-dd'/>"/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Ngày kết thúc *</label>
                        <input type="date" class="form-control" name="endDate" required
                               value="<fmt:formatDate value='${voucher.endDate}' pattern='yyyy-MM-dd'/>"/>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-danger"><i class="fas fa-save me-2"></i>Lưu</button>
                    <a href="${pageContext.request.contextPath}/VoucherController?action=voucherList" class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
