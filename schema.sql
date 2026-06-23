-- ============================================
-- CineStarTV Cinema Booking System
-- SQL Server 2022 — Full Schema + Sample Data
-- ============================================

-- 1. Tạo database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'CineStarTV')
BEGIN
    CREATE DATABASE CineStarTV;
END
GO

USE CineStarTV;
GO

-- ============================================
-- TẠO BẢNG (16 bảng)
-- ============================================

-- 1. Roles
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Roles')
CREATE TABLE Roles (
    roleId      INT IDENTITY(1,1) PRIMARY KEY,
    roleName    NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255),
    createdAt   DATETIME DEFAULT GETDATE()
);
GO

-- 2. Users
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
CREATE TABLE Users (
    userId      INT IDENTITY(1,1) PRIMARY KEY,
    fullName    NVARCHAR(100) NOT NULL,
    email       NVARCHAR(150) NOT NULL UNIQUE,
    password    NVARCHAR(255),
    phone       NVARCHAR(20),
    avatar      NVARCHAR(500) DEFAULT 'default-avatar.png',
    googleId    NVARCHAR(255),
    roleId      INT NOT NULL DEFAULT 2,
    status      NVARCHAR(20) DEFAULT 'ACTIVE',
    resetToken  NVARCHAR(255),
    tokenExpiry DATETIME,
    createdAt   DATETIME DEFAULT GETDATE(),
    updatedAt   DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (roleId) REFERENCES Roles(roleId)
);
GO

-- 3. Movies
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Movies')
CREATE TABLE Movies (
    movieId     INT IDENTITY(1,1) PRIMARY KEY,
    title       NVARCHAR(255) NOT NULL,
    titleEn     NVARCHAR(255),
    description NTEXT,
    posterUrl   NVARCHAR(500),
    trailerUrl  NVARCHAR(500),
    duration    INT NOT NULL,
    releaseDate DATE,
    endDate     DATE,
    director    NVARCHAR(100),
    actors      NVARCHAR(500),
    rating      FLOAT DEFAULT 0,
    ratingCount INT DEFAULT 0,
    ageRating   NVARCHAR(10) DEFAULT 'P',
    language    NVARCHAR(50) DEFAULT N'Phụ đề',
    status      NVARCHAR(20) DEFAULT 'NOW_SHOWING',
    createdAt   DATETIME DEFAULT GETDATE(),
    updatedAt   DATETIME DEFAULT GETDATE()
);
GO

-- 4. Genres
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Genres')
CREATE TABLE Genres (
    genreId     INT IDENTITY(1,1) PRIMARY KEY,
    genreName   NVARCHAR(100) NOT NULL UNIQUE,
    genreNameEn NVARCHAR(100)
);
GO

-- 5. MovieGenres (N-N)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'MovieGenres')
CREATE TABLE MovieGenres (
    movieId INT NOT NULL,
    genreId INT NOT NULL,
    PRIMARY KEY (movieId, genreId),
    CONSTRAINT FK_MG_Movie FOREIGN KEY (movieId) REFERENCES Movies(movieId) ON DELETE CASCADE,
    CONSTRAINT FK_MG_Genre FOREIGN KEY (genreId) REFERENCES Genres(genreId) ON DELETE CASCADE
);
GO

-- 6. Cinemas
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Cinemas')
CREATE TABLE Cinemas (
    cinemaId    INT IDENTITY(1,1) PRIMARY KEY,
    cinemaName  NVARCHAR(150) NOT NULL,
    address     NVARCHAR(500) NOT NULL,
    city        NVARCHAR(100) NOT NULL,
    phone       NVARCHAR(20),
    imageUrl    NVARCHAR(500),
    description NTEXT,
    status      NVARCHAR(20) DEFAULT 'ACTIVE',
    createdAt   DATETIME DEFAULT GETDATE()
);
GO

-- 7. Screens
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Screens')
CREATE TABLE Screens (
    screenId    INT IDENTITY(1,1) PRIMARY KEY,
    cinemaId    INT NOT NULL,
    screenName  NVARCHAR(50) NOT NULL,
    screenType  NVARCHAR(20) DEFAULT '2D',
    capacity    INT DEFAULT 0,
    status      NVARCHAR(20) DEFAULT 'ACTIVE',
    CONSTRAINT FK_Screens_Cinema FOREIGN KEY (cinemaId) REFERENCES Cinemas(cinemaId) ON DELETE CASCADE
);
GO

-- 8. Seats
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Seats')
CREATE TABLE Seats (
    seatId      INT IDENTITY(1,1) PRIMARY KEY,
    screenId    INT NOT NULL,
    seatRow     NVARCHAR(5) NOT NULL,
    seatNumber  INT NOT NULL,
    seatType    NVARCHAR(20) DEFAULT 'STANDARD',
    status      NVARCHAR(20) DEFAULT 'ACTIVE',
    CONSTRAINT FK_Seats_Screen FOREIGN KEY (screenId) REFERENCES Screens(screenId) ON DELETE CASCADE,
    CONSTRAINT UQ_Seat_Position UNIQUE (screenId, seatRow, seatNumber)
);
GO

-- 9. Showtimes
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Showtimes')
CREATE TABLE Showtimes (
    showtimeId  INT IDENTITY(1,1) PRIMARY KEY,
    movieId     INT NOT NULL,
    screenId    INT NOT NULL,
    showDate    DATE NOT NULL,
    startTime   NVARCHAR(8) NOT NULL,
    endTime     NVARCHAR(8) NOT NULL,
    basePrice   BIGINT NOT NULL DEFAULT 75000,
    status      NVARCHAR(20) DEFAULT 'ACTIVE',
    createdAt   DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Showtimes_Movie FOREIGN KEY (movieId) REFERENCES Movies(movieId),
    CONSTRAINT FK_Showtimes_Screen FOREIGN KEY (screenId) REFERENCES Screens(screenId)
);
GO

-- 10. Vouchers
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Vouchers')
CREATE TABLE Vouchers (
    voucherId       INT IDENTITY(1,1) PRIMARY KEY,
    code            NVARCHAR(50) NOT NULL UNIQUE,
    discountPercent INT DEFAULT 0,
    discountAmount  BIGINT DEFAULT 0,
    maxDiscount     BIGINT,
    minOrder        BIGINT DEFAULT 0,
    quantity        INT DEFAULT 100,
    usedCount       INT DEFAULT 0,
    startDate       DATE NOT NULL,
    endDate         DATE NOT NULL,
    status          NVARCHAR(20) DEFAULT 'ACTIVE',
    createdAt       DATETIME DEFAULT GETDATE()
);
GO

-- 11. Bookings
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Bookings')
CREATE TABLE Bookings (
    bookingId       INT IDENTITY(1,1) PRIMARY KEY,
    userId          INT NOT NULL,
    showtimeId      INT NOT NULL,
    voucherId       INT,
    totalAmount     BIGINT NOT NULL DEFAULT 0,
    discountAmount  BIGINT DEFAULT 0,
    finalAmount     BIGINT NOT NULL DEFAULT 0,
    bookingCode     NVARCHAR(20) NOT NULL UNIQUE,
    status          NVARCHAR(20) DEFAULT 'PENDING',
    createdAt       DATETIME DEFAULT GETDATE(),
    updatedAt       DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Bookings_User FOREIGN KEY (userId) REFERENCES Users(userId),
    CONSTRAINT FK_Bookings_Showtime FOREIGN KEY (showtimeId) REFERENCES Showtimes(showtimeId),
    CONSTRAINT FK_Bookings_Voucher FOREIGN KEY (voucherId) REFERENCES Vouchers(voucherId)
);
GO

-- 12. BookingDetails
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BookingDetails')
CREATE TABLE BookingDetails (
    detailId    INT IDENTITY(1,1) PRIMARY KEY,
    bookingId   INT NOT NULL,
    seatId      INT NOT NULL,
    price       BIGINT NOT NULL,
    seatLabel   NVARCHAR(10),
    CONSTRAINT FK_BD_Booking FOREIGN KEY (bookingId) REFERENCES Bookings(bookingId) ON DELETE CASCADE,
    CONSTRAINT FK_BD_Seat FOREIGN KEY (seatId) REFERENCES Seats(seatId),
    CONSTRAINT UQ_Booking_Seat UNIQUE (bookingId, seatId)
);
GO

-- 13. Payments
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Payments')
CREATE TABLE Payments (
    paymentId       INT IDENTITY(1,1) PRIMARY KEY,
    bookingId       INT NOT NULL,
    paymentMethod   NVARCHAR(50) NOT NULL DEFAULT 'VNPAY',
    transactionId   NVARCHAR(100),
    amount          BIGINT NOT NULL,
    status          NVARCHAR(20) DEFAULT 'PENDING',
    vnpayResponseCode NVARCHAR(10),
    paidAt          DATETIME,
    createdAt       DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Payments_Booking FOREIGN KEY (bookingId) REFERENCES Bookings(bookingId)
);
GO

-- 14. Reviews
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Reviews')
CREATE TABLE Reviews (
    reviewId    INT IDENTITY(1,1) PRIMARY KEY,
    userId      INT NOT NULL,
    movieId     INT NOT NULL,
    rating      INT NOT NULL CHECK (rating >= 1 AND rating <= 10),
    comment     NTEXT,
    status      NVARCHAR(20) DEFAULT 'ACTIVE',
    createdAt   DATETIME DEFAULT GETDATE(),
    updatedAt   DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Reviews_User FOREIGN KEY (userId) REFERENCES Users(userId),
    CONSTRAINT FK_Reviews_Movie FOREIGN KEY (movieId) REFERENCES Movies(movieId) ON DELETE CASCADE,
    CONSTRAINT UQ_User_Movie_Review UNIQUE (userId, movieId)
);
GO

-- 15. Notifications
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Notifications')
CREATE TABLE Notifications (
    notificationId INT IDENTITY(1,1) PRIMARY KEY,
    userId         INT NOT NULL,
    title          NVARCHAR(255) NOT NULL,
    message        NTEXT NOT NULL,
    type           NVARCHAR(50) DEFAULT 'INFO',
    isRead         BIT DEFAULT 0,
    createdAt      DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Notifications_User FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);
GO

-- 16. BlogPosts
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BlogPosts')
CREATE TABLE BlogPosts (
    postId       INT IDENTITY(1,1) PRIMARY KEY,
    userId       INT NOT NULL,
    title        NVARCHAR(255) NOT NULL,
    content      NTEXT NOT NULL,
    thumbnailUrl NVARCHAR(500),
    category     NVARCHAR(50) DEFAULT 'NEWS',
    status       NVARCHAR(20) DEFAULT 'PUBLISHED',
    createdAt    DATETIME DEFAULT GETDATE(),
    updatedAt    DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_BlogPosts_User FOREIGN KEY (userId) REFERENCES Users(userId)
);
GO

-- ============================================
-- DỮ LIỆU MẪU (SAMPLE DATA)
-- ============================================

-- Roles
SET IDENTITY_INSERT Roles ON;
INSERT INTO Roles (roleId, roleName, description, createdAt) VALUES
(1, N'ADMIN', N'Quản trị viên hệ thống', GETDATE()),
(2, N'USER', N'Người dùng thường', GETDATE()),
(3, N'STAFF', N'Nhân viên rạp', GETDATE());
SET IDENTITY_INSERT Roles OFF;
GO

-- Users (password = BCrypt hash of "123456")
SET IDENTITY_INSERT Users ON;
INSERT INTO Users (userId, fullName, email, password, phone, avatar, status, roleId, createdAt, updatedAt) VALUES
(1, N'Admin CineStar', N'admin@cinestartv.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0901234567', 'default-avatar.png', 'ACTIVE', 1, GETDATE(), GETDATE()),
(2, N'Nguyễn Văn A', N'user1@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0912345678', 'default-avatar.png', 'ACTIVE', 2, GETDATE(), GETDATE()),
(3, N'Trần Thị B', N'user2@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0923456789', 'default-avatar.png', 'ACTIVE', 2, GETDATE(), GETDATE()),
(4, N'Nhân viên 1', N'staff1@cinestartv.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0934567890', 'default-avatar.png', 'ACTIVE', 3, GETDATE(), GETDATE());
SET IDENTITY_INSERT Users OFF;
GO

-- Genres
SET IDENTITY_INSERT Genres ON;
INSERT INTO Genres (genreId, genreName, genreNameEn) VALUES
(1, N'Hành động', 'Action'),
(2, N'Kinh dị', 'Horror'),
(3, N'Hài hước', 'Comedy'),
(4, N'Tình cảm', 'Romance'),
(5, N'Khoa học viễn tưởng', 'Sci-Fi'),
(6, N'Hoạt hình', 'Animation'),
(7, N'Phiêu lưu', 'Adventure'),
(8, N'Tâm lý', 'Drama'),
(9, N'Tội phạm', 'Crime'),
(10, N'Giả tưởng', 'Fantasy');
SET IDENTITY_INSERT Genres OFF;
GO

-- Movies
SET IDENTITY_INSERT Movies ON;
INSERT INTO Movies (movieId, title, titleEn, description, duration, releaseDate, endDate, director, actors, rating, ratingCount, ageRating, language, status, createdAt, updatedAt) VALUES
(1, N'Lật Mặt 8: Vòng Tay Nắng', 'Face Off 8', N'Phần mới nhất trong series Lật Mặt của Lý Hải, mang đến câu chuyện gia đình đầy cảm xúc.', 132, '2025-04-25', '2025-06-30', N'Lý Hải', N'Lý Hải, Trấn Thành, Kiều Minh Tuấn', 8.5, 1250, 'P', N'Phụ đề', 'NOW_SHOWING', GETDATE(), GETDATE()),
(2, N'Avengers: Doomsday', 'Avengers: Doomsday', N'Các siêu anh hùng Marvel tập hợp để đối đầu với Doctor Doom.', 155, '2026-05-01', '2026-08-01', 'Joe Russo', 'Robert Downey Jr., Chris Evans', 9.2, 3400, 'C13', N'Phụ đề', 'NOW_SHOWING', GETDATE(), GETDATE()),
(3, N'Doraemon: Nobita và Bản Giao Hưởng Địa Cầu', 'Doraemon: Earth Symphony', N'Doraemon và nhóm bạn tham gia cuộc phiêu lưu âm nhạc.', 115, '2026-05-24', '2026-07-30', 'Kazuaki Imai', 'Wasabi Mizuta, Megumi Ohara', 8.0, 890, 'P', N'Lồng tiếng', 'NOW_SHOWING', GETDATE(), GETDATE()),
(4, N'Quỷ Cái', 'The Demon', N'Câu chuyện kinh dị từ truyền thuyết dân gian Việt Nam.', 98, '2026-06-14', '2026-08-14', N'Trần Hữu Tấn', N'Jun Vũ, Quang Tuấn', 7.3, 560, 'C18', N'Phụ đề', 'NOW_SHOWING', GETDATE(), GETDATE()),
(5, N'Inside Out 3', 'Inside Out 3', N'Cuộc phiêu lưu mới của Riley và những cảm xúc.', 105, '2026-06-20', '2026-09-01', 'Kelsey Mann', 'Amy Poehler, Maya Hawke', 8.8, 2100, 'P', N'Lồng tiếng', 'NOW_SHOWING', GETDATE(), GETDATE()),
(6, N'Thunderbolts*', 'Thunderbolts*', N'Nhóm phản anh hùng của Marvel.', 127, '2026-07-15', '2026-09-15', 'Jake Schreier', 'Florence Pugh, Sebastian Stan', 7.8, 0, 'C13', N'Phụ đề', 'COMING_SOON', GETDATE(), GETDATE()),
(7, N'Mission Impossible: Nghiệp Báo Cuối Cùng P2', 'MI: Final Reckoning P2', N'Tom Cruise với nhiệm vụ bất khả thi cuối cùng.', 163, '2026-07-23', '2026-10-01', 'Christopher McQuarrie', 'Tom Cruise, Hayley Atwell', 9.0, 0, 'C13', N'Phụ đề', 'COMING_SOON', GETDATE(), GETDATE()),
(8, N'Moana 2', 'Moana 2', N'Moana tiếp tục hành trình trên biển cả.', 100, '2026-08-01', '2026-10-15', 'David Derrick Jr.', N'Dwayne Johnson', 8.2, 0, 'P', N'Lồng tiếng', 'COMING_SOON', GETDATE(), GETDATE());
SET IDENTITY_INSERT Movies OFF;
GO

-- MovieGenres
INSERT INTO MovieGenres (movieId, genreId) VALUES
(1, 3), (1, 8),
(2, 1), (2, 5), (2, 7),
(3, 6), (3, 7),
(4, 2), (4, 8),
(5, 6), (5, 3), (5, 8),
(6, 1), (6, 5),
(7, 1), (7, 7),
(8, 6), (8, 7), (8, 10);
GO

-- Cinemas
SET IDENTITY_INSERT Cinemas ON;
INSERT INTO Cinemas (cinemaId, cinemaName, address, city, phone, status, createdAt) VALUES
(1, N'CineStar Quận 1', N'135 Hai Bà Trưng, Phường Bến Nghé, Quận 1', N'Hồ Chí Minh', '028-3822-1234', 'ACTIVE', GETDATE()),
(2, N'CineStar Quận 7', N'SC VivoCity, 1058 Nguyễn Văn Linh, Quận 7', N'Hồ Chí Minh', '028-3771-5678', 'ACTIVE', GETDATE()),
(3, N'CineStar Hà Nội', N'Vincom Royal City, 72A Nguyễn Trãi, Thanh Xuân', N'Hà Nội', '024-3974-1111', 'ACTIVE', GETDATE()),
(4, N'CineStar Đà Nẵng', N'Vincom Plaza, 910A Ngô Quyền, Sơn Trà', N'Đà Nẵng', '023-6382-2222', 'ACTIVE', GETDATE());
SET IDENTITY_INSERT Cinemas OFF;
GO

-- Screens
SET IDENTITY_INSERT Screens ON;
INSERT INTO Screens (screenId, cinemaId, screenName, screenType, capacity, status) VALUES
(1, 1, N'Phòng 1', '2D', 120, 'ACTIVE'),
(2, 1, N'Phòng 2', '3D', 100, 'ACTIVE'),
(3, 1, N'Phòng 3', 'IMAX', 200, 'ACTIVE'),
(4, 2, N'Phòng 1', '2D', 110, 'ACTIVE'),
(5, 2, N'Phòng 2', '4DX', 80, 'ACTIVE'),
(6, 3, N'Phòng 1', '2D', 130, 'ACTIVE'),
(7, 3, N'Phòng 2', '3D', 100, 'ACTIVE'),
(8, 4, N'Phòng 1', '2D', 100, 'ACTIVE');
SET IDENTITY_INSERT Screens OFF;
GO

-- Seats cho Screen 1 (8 hàng x 15 ghế = 120)
DECLARE @row CHAR(1);
DECLARE @num INT;
DECLARE @type NVARCHAR(20);
DECLARE @rows TABLE (r CHAR(1), sType NVARCHAR(20));
INSERT INTO @rows VALUES ('A','STANDARD'),('B','STANDARD'),('C','STANDARD'),('D','STANDARD'),('E','STANDARD'),('F','VIP'),('G','VIP'),('H','SWEETBOX');

DECLARE row_cursor CURSOR FOR SELECT r, sType FROM @rows;
OPEN row_cursor;
FETCH NEXT FROM row_cursor INTO @row, @type;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @num = 1;
    WHILE @num <= 15
    BEGIN
        INSERT INTO Seats (screenId, seatRow, seatNumber, seatType, status)
        VALUES (1, @row, @num, @type, 'ACTIVE');
        SET @num = @num + 1;
    END
    FETCH NEXT FROM row_cursor INTO @row, @type;
END
CLOSE row_cursor;
DEALLOCATE row_cursor;
GO

-- Vouchers
SET IDENTITY_INSERT Vouchers ON;
INSERT INTO Vouchers (voucherId, code, discountPercent, discountAmount, maxDiscount, minOrder, quantity, usedCount, startDate, endDate, status, createdAt) VALUES
(1, 'WELCOME10', 10, 0, 30000, 50000, 500, 23, '2026-01-01', '2026-12-31', 'ACTIVE', GETDATE()),
(2, 'SUMMER2026', 0, 20000, 20000, 100000, 200, 56, '2026-06-01', '2026-08-31', 'ACTIVE', GETDATE()),
(3, 'VIP50K', 0, 50000, 50000, 200000, 100, 12, '2026-06-15', '2026-07-15', 'ACTIVE', GETDATE());
SET IDENTITY_INSERT Vouchers OFF;
GO

-- Showtimes
SET IDENTITY_INSERT Showtimes ON;
INSERT INTO Showtimes (showtimeId, movieId, screenId, showDate, startTime, endTime, basePrice, status, createdAt) VALUES
(1, 1, 1, '2026-06-22', '09:00', '11:12', 75000, 'ACTIVE', GETDATE()),
(2, 1, 1, '2026-06-22', '14:00', '16:12', 85000, 'ACTIVE', GETDATE()),
(3, 1, 1, '2026-06-22', '19:30', '21:42', 95000, 'ACTIVE', GETDATE()),
(4, 2, 3, '2026-06-22', '10:00', '12:35', 150000, 'ACTIVE', GETDATE()),
(5, 2, 3, '2026-06-22', '15:00', '17:35', 150000, 'ACTIVE', GETDATE()),
(6, 2, 3, '2026-06-22', '20:00', '22:35', 180000, 'ACTIVE', GETDATE()),
(7, 1, 1, '2026-06-23', '09:00', '11:12', 75000, 'ACTIVE', GETDATE()),
(8, 2, 3, '2026-06-23', '10:00', '12:35', 150000, 'ACTIVE', GETDATE());
SET IDENTITY_INSERT Showtimes OFF;
GO

-- Reviews
SET IDENTITY_INSERT Reviews ON;
INSERT INTO Reviews (reviewId, userId, movieId, rating, comment, status, createdAt, updatedAt) VALUES
(1, 2, 1, 9, N'Phim hay quá! Cả gia đình xem rất thích.', 'ACTIVE', GETDATE(), GETDATE()),
(2, 3, 1, 8, N'Nội dung cảm động, diễn xuất tốt.', 'ACTIVE', GETDATE(), GETDATE()),
(3, 2, 2, 10, N'Marvel đỉnh nhất! IMAX xem mãn nhãn.', 'ACTIVE', GETDATE(), GETDATE()),
(4, 3, 5, 9, N'Hoạt hình Pixar luôn xuất sắc!', 'ACTIVE', GETDATE(), GETDATE());
SET IDENTITY_INSERT Reviews OFF;
GO

-- Notifications
SET IDENTITY_INSERT Notifications ON;
INSERT INTO Notifications (notificationId, userId, title, message, type, isRead, createdAt) VALUES
(1, 2, N'Chào mừng đến CineStarTV!', N'Cảm ơn bạn đã đăng ký tài khoản. Nhập mã WELCOME10 để giảm 10% cho đơn đầu tiên.', 'SYSTEM', 0, GETDATE()),
(2, 3, N'Khuyến mãi mùa hè!', N'Nhập mã SUMMER2026 để giảm 20,000đ. Áp dụng đến 31/08.', 'SYSTEM', 0, GETDATE());
SET IDENTITY_INSERT Notifications OFF;
GO

-- BlogPosts
SET IDENTITY_INSERT BlogPosts ON;
INSERT INTO BlogPosts (postId, userId, title, content, category, status, createdAt, updatedAt) VALUES
(1, 1, N'Top 5 phim bom tấn hè 2026', N'Mùa hè 2026 hứa hẹn bùng nổ với loạt phim bom tấn từ Marvel, Pixar và nhiều hãng lớn...', 'NEWS', 'PUBLISHED', GETDATE(), GETDATE()),
(2, 1, N'Ưu đãi thành viên tháng 6 - Giảm đến 50%', N'Chương trình ưu đãi đặc biệt dành riêng cho thành viên CineStar trong tháng 6...', 'PROMOTION', 'PUBLISHED', GETDATE(), GETDATE()),
(3, 1, N'CineStar khai trương chi nhánh Đà Nẵng', N'CineStar chính thức có mặt tại Đà Nẵng với hệ thống phòng chiếu hiện đại nhất miền Trung...', 'EVENT', 'PUBLISHED', GETDATE(), GETDATE());
SET IDENTITY_INSERT BlogPosts OFF;
GO

PRINT N'✅ Database CineStarTV đã được tạo thành công với 16 bảng và dữ liệu mẫu!';
PRINT N'   - 3 Roles (ADMIN, USER, STAFF)';
PRINT N'   - 4 Users (admin, 2 users, 1 staff) — password: 123456';
PRINT N'   - 8 Movies (5 đang chiếu, 3 sắp chiếu)';
PRINT N'   - 10 Genres, 19 MovieGenres mappings';
PRINT N'   - 4 Cinemas, 8 Screens, 120 Seats (Screen 1)';
PRINT N'   - 8 Showtimes, 3 Vouchers';
PRINT N'   - 4 Reviews, 2 Notifications, 3 BlogPosts';
GO
