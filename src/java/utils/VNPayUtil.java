package utils;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class VNPayUtil {

    public static final String VNP_TMN_CODE    = "UQV2MTO3";
    public static final String VNP_HASH_SECRET = "ZOI1ZKBVJ821JAJADE8FDTLGQD1V4ABG";
    public static final String VNP_URL         = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String VNP_RETURN_URL  = "https://president-endocrine-gloomy.ngrok-free.dev/CineStarTV/PaymentController?action=vnpayReturn&ngrok-skip-browser-warning=1";

    public static String buildPaymentUrl(int bookingId, long amount,
            String orderInfo, String ipAddr) throws Exception {

        // Fix IPv6 localhost → IPv4
        if (ipAddr == null || ipAddr.isEmpty() || ipAddr.contains(":")) {
            ipAddr = "127.0.0.1";
        }

        String txnRef     = bookingId + "-" + System.currentTimeMillis();
        String vnpAmount  = String.valueOf(amount * 100);
        String createDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String expireDate = new SimpleDateFormat("yyyyMMddHHmmss")
                .format(new Date(System.currentTimeMillis() + 15 * 60 * 1000));

        Map<String, String> params = new HashMap<>();
        params.put("vnp_Version",    "2.1.0");
        params.put("vnp_Command",    "pay");
        params.put("vnp_TmnCode",    VNP_TMN_CODE);
        params.put("vnp_Amount",     vnpAmount);
        params.put("vnp_CurrCode",   "VND");
        params.put("vnp_TxnRef",     txnRef);
        params.put("vnp_OrderInfo",  orderInfo);
        params.put("vnp_OrderType",  "billpayment");
        params.put("vnp_Locale",     "vn");
        params.put("vnp_ReturnUrl",  VNP_RETURN_URL);
        params.put("vnp_IpAddr",     ipAddr);
        params.put("vnp_CreateDate", createDate);
        params.put("vnp_ExpireDate", expireDate);

        // Sort theo alphabet — đúng theo spec VNPay
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query    = new StringBuilder();

        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName  = itr.next();
            String fieldValue = params.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                // hashData: key không encode, value encode US_ASCII (official VNPay spec)
                hashData.append(fieldName).append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                // query: cả key và value encode UTF-8
                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()))
                     .append('=')
                     .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                if (itr.hasNext()) {
                    hashData.append('&');
                    query.append('&');
                }
            }
        }

        String secureHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        System.out.println("[VNPay] hashData: " + hashData);
        System.out.println("[VNPay] hash:     " + secureHash);

        query.append("&vnp_SecureHash=").append(secureHash);
        return VNP_URL + "?" + query.toString();
    }

    public static boolean verifySignature(Map<String, String[]> rawParams) {
        try {
            String received = rawParams.containsKey("vnp_SecureHash")
                    ? rawParams.get("vnp_SecureHash")[0] : "";

            List<String> fieldNames = new ArrayList<>();
            Map<String, String> values = new HashMap<>();
            for (Map.Entry<String, String[]> e : rawParams.entrySet()) {
                String k = e.getKey();
                // Chỉ lấy param vnp_* (đúng spec VNPay), bỏ qua SecureHash và param lạ (vd: ngrok)
                if (k.startsWith("vnp_") && !k.equals("vnp_SecureHash") && !k.equals("vnp_SecureHashType")) {
                    fieldNames.add(k);
                    values.put(k, e.getValue()[0]);
                }
            }
            Collections.sort(fieldNames);

            StringBuilder hashData = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName  = itr.next();
                String fieldValue = values.get(fieldName);
                if (fieldValue != null && fieldValue.length() > 0) {
                    hashData.append(fieldName).append('=')
                            .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) hashData.append('&');
                }
            }

            String expected = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
            return expected.equalsIgnoreCase(received);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String hmacSHA512(String key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA512");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
        byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    public static String getIpAddress(javax.servlet.http.HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) ip = request.getRemoteAddr();
        if (ip != null && ip.contains(",")) ip = ip.split(",")[0].trim();
        return ip;
    }
}
