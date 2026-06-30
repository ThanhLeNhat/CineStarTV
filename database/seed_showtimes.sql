-- ============================================================
-- Seed showtimes: mỗi phim NOW_SHOWING × mỗi phòng ACTIVE
-- Tạo 30 ngày tới, mỗi ngày 3-4 suất chiếu
-- Chạy trong SSMS
-- ============================================================

-- Xóa showtimes cũ (nếu muốn reset sạch)
-- DELETE FROM BookingDetails;
-- DELETE FROM Bookings;
-- DELETE FROM Showtimes;

DECLARE @today DATE = CAST(GETDATE() AS DATE);
DECLARE @days  INT  = 30;

-- Xóa showtimes quá khứ chưa có booking
DELETE FROM Showtimes
WHERE showDate < @today
  AND showtimeId NOT IN (SELECT DISTINCT showtimeId FROM Bookings WHERE showtimeId IS NOT NULL);

-- Generate showtimes mới
DECLARE @d     INT = 0;
DECLARE @date  DATE;
DECLARE @movieId  INT;
DECLARE @screenId INT;
DECLARE @duration INT;
DECLARE @price    DECIMAL(10,2);

-- Cursor qua từng cặp (phim × phòng)
DECLARE cur CURSOR FOR
    SELECT m.movieId, s.screenId, m.duration,
           CASE s.screenType
               WHEN 'IMAX' THEN 150000
               WHEN '4DX'  THEN 130000
               ELSE 75000
           END AS basePrice
    FROM Movies m
    CROSS JOIN Screens s
    WHERE m.status = 'NOW_SHOWING'
      AND s.status = 'ACTIVE';

OPEN cur;
FETCH NEXT FROM cur INTO @movieId, @screenId, @duration, @price;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @d = 0;
    WHILE @d < @days
    BEGIN
        SET @date = DATEADD(DAY, @d, @today);

        -- Suất sáng 09:00
        IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE movieId=@movieId AND screenId=@screenId AND showDate=@date AND startTime='09:00')
        INSERT INTO Showtimes (movieId, screenId, showDate, startTime, endTime, basePrice, status)
        VALUES (@movieId, @screenId, @date, '09:00',
                RIGHT('0' + CAST((9*60 + @duration + 12) / 60 AS VARCHAR), 2) + ':' + RIGHT('0' + CAST((9*60 + @duration + 12) % 60 AS VARCHAR), 2),
                @price, 'ACTIVE');

        -- Suất trưa 13:30
        IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE movieId=@movieId AND screenId=@screenId AND showDate=@date AND startTime='13:30')
        INSERT INTO Showtimes (movieId, screenId, showDate, startTime, endTime, basePrice, status)
        VALUES (@movieId, @screenId, @date, '13:30',
                RIGHT('0' + CAST((13*60 + 30 + @duration + 12) / 60 AS VARCHAR), 2) + ':' + RIGHT('0' + CAST((13*60 + 30 + @duration + 12) % 60 AS VARCHAR), 2),
                @price * 1.1, 'ACTIVE');

        -- Suất chiều 17:00
        IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE movieId=@movieId AND screenId=@screenId AND showDate=@date AND startTime='17:00')
        INSERT INTO Showtimes (movieId, screenId, showDate, startTime, endTime, basePrice, status)
        VALUES (@movieId, @screenId, @date, '17:00',
                RIGHT('0' + CAST((17*60 + @duration + 12) / 60 AS VARCHAR), 2) + ':' + RIGHT('0' + CAST((17*60 + @duration + 12) % 60 AS VARCHAR), 2),
                @price * 1.15, 'ACTIVE');

        -- Suất tối 20:30
        IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE movieId=@movieId AND screenId=@screenId AND showDate=@date AND startTime='20:30')
        INSERT INTO Showtimes (movieId, screenId, showDate, startTime, endTime, basePrice, status)
        VALUES (@movieId, @screenId, @date, '20:30',
                RIGHT('0' + CAST((20*60 + 30 + @duration + 12) / 60 AS VARCHAR), 2) + ':' + RIGHT('0' + CAST((20*60 + 30 + @duration + 12) % 60 AS VARCHAR), 2),
                @price * 1.2, 'ACTIVE');

        SET @d = @d + 1;
    END;

    FETCH NEXT FROM cur INTO @movieId, @screenId, @duration, @price;
END;

CLOSE cur;
DEALLOCATE cur;

-- Kiểm tra kết quả
SELECT COUNT(*) AS total_showtimes FROM Showtimes WHERE showDate >= CAST(GETDATE() AS DATE);
SELECT m.title, sc.screenName, sc.screenType, COUNT(*) AS so_suat
FROM Showtimes st
JOIN Movies m ON st.movieId = m.movieId
JOIN Screens sc ON st.screenId = sc.screenId
WHERE st.showDate >= CAST(GETDATE() AS DATE)
GROUP BY m.title, sc.screenName, sc.screenType
ORDER BY m.title;
