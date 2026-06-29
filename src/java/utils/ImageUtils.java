package utils;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;
import javax.servlet.http.Part;

public class ImageUtils {

    private static final String UPLOAD_ROOT = "D:/PRJ301/uploads/cinestar/";
    private static final long MAX_SIZE = 2 * 1024 * 1024;

    public static String saveImage(Part part, String subfolder) throws Exception {
        if (part == null || part.getSize() == 0) return null;
        if (part.getSize() > MAX_SIZE) {
            throw new IllegalArgumentException("Anh qua lon. Toi da 2MB.");
        }
        String contentType = part.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("File khong phai anh (jpg, png, gif, webp).");
        }
        String originalName = part.getSubmittedFileName();
        String ext = "jpg";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf('.') + 1).toLowerCase();
        }
        String fileName = UUID.randomUUID().toString() + "." + ext;
        String dir = UPLOAD_ROOT + subfolder + "/";
        new File(dir).mkdirs();
        try (InputStream is = part.getInputStream()) {
            Files.copy(is, Paths.get(dir + fileName));
        }
        return "/uploads/" + subfolder + "/" + fileName;
    }

    public static boolean hasFile(Part part) {
        return part != null && part.getSize() > 0
                && part.getSubmittedFileName() != null
                && !part.getSubmittedFileName().isEmpty();
    }

    public static void deleteImage(String dbPath) {
        if (dbPath == null || dbPath.isEmpty()) return;
        String filePath = UPLOAD_ROOT + dbPath.replace("/uploads/", "");
        File f = new File(filePath);
        if (f.exists()) f.delete();
    }
}
