
CREATE DATABASE minii_project_ss08;
USE minii_project_ss08;
 
 -- Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;
 
 -- Bảng khách 
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng 
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng 
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

--  DỮ LIỆU MẪU 

INSERT INTO guests (guest_name, phone) VALUES
('Vu Trung Hieu', '0901111111'),
('Ha Quang Huy', '0902222222'),
('Hoang Thien Son', '0903333333'),
('Ngo Van Quy', '0904444444'),
('Nguyen Minh Duy', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'),
(1, 3, '2024-03-05', '2024-03-10'),
(2, 2, '2024-02-01', '2024-02-03'),
(2, 5, '2024-04-15', '2024-04-18'),
(3, 4, '2023-12-20', '2023-12-25'),
(3, 6, '2024-05-01', '2024-05-06'),
(4, 1, '2024-06-10', '2024-06-11');

 --  PHẦN I – TRUY VẤN CƠ BẢN

-- 1. Tên khách & số điện thoại 
SELECT guest_name, phone
FROM guests;

-- 2. Các loại phòng khác nhau 
SELECT DISTINCT room_type
FROM rooms;

-- 3. Loại phòng & giá thuê tăng dần 
SELECT room_type, price_per_day
FROM rooms
ORDER BY price_per_day ASC;

-- 4. Phòng có giá thuê 
SELECT *
FROM rooms
WHERE price_per_day > 1000000;

-- 5. Các lần đặt phòng trong năm 2024 
SELECT *
FROM bookings
WHERE YEAR(check_in) = 2024;

-- 6. Số lượng phòng của từng loại 
SELECT room_type, COUNT(*) AS so_luong_phong
FROM rooms
GROUP BY room_type;

  -- PHẦN II – TRUY VẤN NÂNG CAO

-- 7. Danh sách đặt phòng 
SELECT 
    g.guest_name,
    r.room_type,
    b.check_in
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
JOIN rooms r ON b.room_id = r.room_id;

-- 8. Đặt phòng 
SELECT 
    g.guest_name,
    COUNT(b.booking_id) AS so_lan_dat
FROM guests g
LEFT JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_name;

-- 9. Doanh thu của mỗi phòng 
-- 10. Tổng doanh thu của từng loại phòng 


-- 11. Khách đặt phòng từ 2 lần trở lên 
SELECT 
    g.guest_name,
    COUNT(b.booking_id) AS so_lan_dat
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_name
HAVING COUNT(b.booking_id) >= 2;

-- 12. Loại phòng được đặt nhiều nhất 
SELECT 
    r.room_type,
    COUNT(b.booking_id) AS so_luot_dat
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
GROUP BY r.room_type
ORDER BY so_luot_dat DESC
LIMIT 1;

 --  PHẦN III – TRUY VẤN LỒNG

-- 13. Phòng có giá cao hơn giá trung bình 
SELECT *
FROM rooms
WHERE price_per_day > (
    SELECT AVG(price_per_day)
    FROM rooms
);

-- 14. Khách chưa từng đặt phòng 
SELECT *
FROM guests
WHERE guest_id NOT IN (
    SELECT DISTINCT guest_id
    FROM bookings
);

-- 15. Phòng được đặt nhiều lần nhất 
SELECT *
FROM rooms
WHERE room_id = (
    SELECT room_id
    FROM bookings
    GROUP BY room_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
