-- Cập nhật tất cả suất chiếu sang 7 ngày tới (tính từ hôm nay)
-- Chạy script này trong SSMS

DECLARE @today DATE = CAST(GETDATE() AS DATE);
DECLARE @oldest DATE = (SELECT MIN(showDate) FROM Showtimes);
DECLARE @diff INT = DATEDIFF(DAY, @oldest, @today) + 1;

-- Dịch tất cả suất chiếu lên đúng số ngày chênh lệch
UPDATE Showtimes
SET showDate = DATEADD(DAY, @diff, showDate);

-- Kiểm tra kết quả
SELECT showtimeId, showDate, startTime, status FROM Showtimes ORDER BY showDate;
