<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<% request.setAttribute("pageTitle", "Quản lý Voucher - Admin"); %>
<%@ include file="../../common/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../sidebar.jsp" %>
    <main class="admin-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white mb-0"><i class="fas fa-tag text-danger me-2"></i>Quản lý Voucher</h2>
            <a href="${pageContext.request.contextPath}/VoucherController?action=voucherAdd" class="btn btn-danger">
                <i class="fas fa-plus me-2"></i>Thêm voucher
            </a>
        </div>

        <c:if test="${param.msg == 'added'}"><div class="alert alert-success">Thêm voucher thành công!</div></c:if>
        <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Cập nhật voucher thành công!</div></c:if>
        <c:if test="${param.msg == 'disabled'}"><div class="alert alert-warning">Đã vô hiệu hóa voucher.</div></c:if>

        <div style="overflow-x:auto;">
            <table class="csn-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Mã</th>
                        <th>Giảm %</th>
                        <th>Giảm tiền</th>
                        <th>Đơn tối thiểu</th>
                        <th>Đã dùng / Tổng</th>
                        <th>Hiệu lực</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="v" items="${vouchers}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td><span class="text-warning fw-bold">${v.code}</span></td>
                            <td>${v.discountPercent > 0 ? v.discountPercent : '—'}%</td>
                            <td>
                                <c:if test="${v.discountAmount > 0}">
                                    <fmt:formatNumber value="${v.discountAmount}" pattern="#,###"/>đ
                                </c:if>
                                <c:if test="${v.discountAmount == 0}">—</c:if>
                            </td>
                            <td><fmt:formatNumber value="${v.minOrder}" pattern="#,###"/>đ</td>
                            <td>${v.usedCount} / ${v.quantity}</td>
                            <td>
                                <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy"/>
                                → <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/>
                            </td>
                            <td>
                                <span class="badge ${v.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                    ${v.status == 'ACTIVE' ? 'Hoạt động' : 'Đã tắt'}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/VoucherController?action=voucherEdit&id=${v.voucherId}"
                                   class="btn btn-sm btn-outline-warning me-1" title="Sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <c:if test="${v.status == 'ACTIVE'}">
                                    <a href="${pageContext.request.contextPath}/VoucherController?action=voucherDisable&id=${v.voucherId}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Xác nhận vô hiệu hóa voucher này?')" title="Tắt">
                                        <i class="fas fa-ban"></i>
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty vouchers}">
                        <tr><td colspan="9" class="text-center text-muted py-4">Chưa có voucher nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
