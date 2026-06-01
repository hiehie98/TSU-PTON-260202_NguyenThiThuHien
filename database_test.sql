-- tạo database và gọi database cần dùng
CREATE DATABASE tsu202;
USE tsu202;

-- Phần 1
-- 1. Tạo bảng passengers
CREATE TABLE passengers(
	passenger_id VARCHAR(5) PRIMARY KEY,
    passenger_full_name VARCHAR(100) NOT NULL,
    passenger_email VARCHAR(100) UNIQUE,
    passenger_phone VARCHAR(15) UNIQUE,
    passenger_cccd VARCHAR(20) UNIQUE
);

-- hiển thị bảng passengers
SELECT * FROM passengers;

-- Tạo bảng trains
CREATE TABLE trains(
	train_id VARCHAR(5) PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    train_type VARCHAR(10) NOT NULL,
    total_seats INT NOT NULL
);
-- hiển thị bảng trains
SELECT * FROM trains;

-- Tạo bảng tickets
CREATE TABLE tickets(
	ticket_id VARCHAR(5) PRIMARY KEY,
    passenger_id VARCHAR(5) NOT NULL,
    train_id VARCHAR(5) NOT NULL,
    departure_date DATE NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
		FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
        FOREIGN KEY (train_id) REFERENCES trains(train_id)
);
-- hiển thị bảng tickets
SELECT * FROM tickets;

-- Tạo bảng payment_transactions
CREATE TABLE payment_transactions(
	transaction_id VARCHAR(5) PRIMARY KEY,
    ticket_id VARCHAR(5) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_date DATE NOT NULL,
    amount DECIMAL(10,2),
		FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);
-- hiển thị bảng tickets
SELECT * FROM payment_transactions;

-- 2. Chèn dữ liệu vào bảng passengers
INSERT INTO passengers
VALUES
('P001', 'Nguyen Van An', 'an.nguyen@example.com', '0912345678','001234567890'),
('P002', 'Tran Thi Binh', 'binh.tran@example.com', '0923456789','002345678901'),
('P003', 'Le Minh Chau', 'chau.le@example.com', '0934567890','003456789012'),
('P004', 'Pham Quoc Dat', 'dat.pham@example.com', '0945678901','004567890123'),
('P005', 'Vo Thanh Em', 'em.vo@example.com', '0956789012','005678901234');
-- hiển thị bảng passengers
SELECT * FROM passengers;

-- Chèn dữ liệu vào bảng trains
INSERT INTO trains
VALUES
('T001', 'Tau Thong Nhat 1', 'SE', 500),
('T002', 'Tau Thong Nhat 2', 'TN', 450),
('T003', 'Tau Sai Gon - Hue', 'SE', 400),
('T004', 'Tau Ha Noi - Lao Cai', 'TN', 350),
('T005', 'Tau Da Nang Express', 'SE', 300);

-- hiển thị bảng trains
SELECT * FROM trains;

-- Chèn dữ liệu vào bảng tickets
INSERT INTO tickets
VALUES
('TK001', 'P001', 'T001','2025-06-10', 'A01', 850000),
('TK002', 'P002', 'T002','2025-06-11', 'B05', 650000),
('TK003', 'P003', 'T003','2025-06-12', 'C10', 720000),
('TK004', 'P004', 'T004','2025-06-13', 'D12', 500000),
('TK005', 'P005', 'T005','2025-06-14', 'E08', 900000);
-- hiển thị bảng tickets
SELECT * FROM tickets;

-- Chèn dữ liệu vào bảng payment_transactions
INSERT INTO payment_transactions
VALUES
('TR001', 'TK001', 'Credit Card', '2025-06-01', 850000),
('TR002', 'TK002', 'Cash', '2025-06-02', 650000),
('TR003', 'TK003', 'Bank Transfer', '2025-06-03', 720000),
('TR004', 'TK004', 'E-Wallet', '2025-06-04', 500000),
('TR005', 'TK005', 'Credit Card', '2025-06-05', 900000);
-- hiển thị bảng payment_transactions
SELECT * FROM payment_transactions;

-- 3.UPDATE giảm giá vé 15% cho các tàu có ngày khởi hành trước 2025-05-01
SET SQL_SAFE_UPDATES = 0;
-- --thêm bản ghi cho bảng tickets có ngày khởi hành trước 2025-05-01 để giảm giá vé
INSERT INTO tickets
VALUES('TK006', 'P002', 'T001', '2025-04-30', 500, 500000);

-- --giảm giá vé 15%
UPDATE tickets
SET ticket_price = ticket_price * 0.85
WHERE departure_date < '2025-05-01';

-- --kiểm tra lại bảng tickets
SELECT * FROM tickets;

-- 4.xóa các giao dịch có phương thức là "E-Wallet" và số tiền nhỏ hơn 200.000 VNĐ
SELECT * FROM payment_transactions;

DELETE FROM payment_transactions
WHERE payment_method = 'E-Wallet' AND amount < 200000;

-- Phần 2
-- 5.Lấy thông tin hành khách gồm: 
-- mã HK, họ tên, email, SĐT sắp xếp theo họ tên giảm dần
SELECT passenger_id, passenger_full_name, passenger_email, passenger_phone
FROM passengers
ORDER BY passenger_full_name DESC;

-- 6.Lấy danh sách đoàn tàu gồm: 
-- mã tàu, tên tàu, tổng số ghế, sắp xếp theo số ghế tăng dần
SELECT train_id, train_name, total_seats
FROM trains
ORDER BY total_seats;

-- 7.Lấy thông tin vé đã đặt gồm: 
-- Họ tên hành khách, Tên tàu, Ngày khởi hành, Số ghế.
SELECT p.passenger_full_name, tr.train_name, t.departure_date, t.seat_number
FROM tickets AS t
INNER JOIN passengers AS p ON t.passenger_id = p.passenger_id
INNER JOIN trains AS tr ON t.train_id = tr.train_id;

-- 8.Lấy danh sách hành khách và tổng tiền đã thanh toán: 
-- mã HK, họ tên, phương thức thanh toán, số tiền thanh toán,
-- sắp xếp theo số tiền tăng dần.
SELECT p.passenger_id, p.passenger_full_name, pt.payment_method, pt.amount
FROM tickets AS t
INNER JOIN passengers AS p ON t.passenger_id = p.passenger_id
INNER JOIN payment_transactions AS pt ON t.ticket_id = pt.ticket_id
ORDER BY pt.amount;

-- 9.Lấy thông tin hành khách từ vị trí thứ 3 đến thứ 5 trong bảng Passengers
-- sắp xếp theo tên (Z-A).

SELECT * FROM (SELECT * FROM passengers LIMIT 3 OFFSET 2) AS p
ORDER BY p.passenger_full_name;

-- 10.Liệt kê các hành khách đã đặt ít nhất 3 vé tàu.
INSERT INTO tickets
VALUES
('TK007', 'P001', 'T001','2025-06-15', 'D07', 850000),
('TK008', 'P001', 'T002','2025-06-16', 'E02', 800000),
('TK009', 'P001', 'T003','2025-06-17', 'G15', 850000);

SELECT * FROM tickets;

SELECT p.passenger_id, p.passenger_full_name, COUNT(t.ticket_id) AS sum_ticket
FROM passengers AS p
INNER JOIN tickets AS t ON p.passenger_id = t.passenger_id
GROUP BY p.passenger_id
HAVING COUNT(t.ticket_id) >= 3;

-- 11.Liệt kê các đoàn tàu đã có hơn 10 lượt khách đặt vé.
SELECT tr.train_id, tr.train_name, COUNT(t.ticket_id)
FROM trains AS tr
INNER JOIN tickets as t ON tr.train_id = tr.train_id
GROUP BY tr.train_id
HAVING COUNT(t.ticket_id) > 10;

-- 12.Lấy danh sách hành khách 
-- có tổng tiền giao dịch > 2.000.000 VNĐ, 
-- gồm: mã HK, họ tên, mã tàu, tổng tiền.
SELECT p.passenger_id, p.passenger_full_name, SUM(pt.amount) AS sum_amount
FROM passengers AS p
INNER JOIN tickets AS t ON t.passenger_id = p.passenger_id
INNER JOIN payment_transactions AS pt ON t.ticket_id = pt.ticket_id
GROUP BY t.passenger_id
HAVING SUM(pt.amount) > 2000000;

-- 13.Lấy danh sách hành khách có tên chứa chữ "Hoàng" 
-- hoặc địa chỉ email thuộc miền "@gmail.com". Sắp xếp theo tên tăng dần.
SELECT * FROM passengers
WHERE passenger_full_name LIKE '%Hoàng%' OR passenger_email LIKE '%@gmail.com';

-- 14.Lấy danh sách đoàn tàu (trang thứ 2, mỗi trang 5 bản ghi)
-- sắp xếp theo số ghế giảm dần.
SELECT * FROM trains
ORDER BY total_seats DESC
LIMIT 5 OFFSET 5;

-- Phần 3
-- 15.Tạo view vw_UpcomingTrips hiển thị thông tin tàu
-- và hành khách đã đặt vé với ngày khởi hành sau ngày 2025-06-01,
-- gồm: Họ tên, Tên tàu, Số ghế, Giá vé, Ngày khởi hành.
CREATE VIEW vw_UpcomingTrips
AS
SELECT p.passenger_full_name, tr.train_name, tr.total_seats, t.departure_date
FROM tickets AS t
INNER JOIN passengers AS p ON t.passenger_id = p.passenger_id
INNER JOIN trains AS tr ON t.train_id= tr.train_id;

SELECT * FROM vw_UpcomingTrips;

-- 16.Tạo view vw_HighValueTickets hiển thị khách hàng đặt vé 
-- có giá trị trên 500.000 VNĐ, gồm: Họ tên, Tên tàu, Số ghế, Giá vé.
CREATE VIEW vw_HighValueTickets
AS
SELECT p.passenger_full_name, tr.train_name, tr.total_seats, t.ticket_price
FROM tickets AS t
INNER JOIN passengers AS p ON t.passenger_id = p.passenger_id
INNER JOIN trains AS tr ON t.train_id = tr.train_id
WHERE t.ticket_price > 500000;

SELECT * FROM vw_HighValueTickets;

-- Phần 4
-- 17.Tạo trigger tg_check_ticket_date kiểm tra khi chèn vào bảng Tickets.
-- Nếu ngày khởi hành nhỏ hơn ngày hiện tại thì báo lỗi
-- "Ngày khởi hành không hợp lệ" và hủy thao tác.
DELIMITER $$
CREATE TRIGGER tg_check_ticket_date
AFTER INSERT ON tickets
FOR EACH ROW
BEGIN
	IF NEW.departure_date < curdate() THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ngày khởi hành không hợp lệ';
	END IF;
END $$
DELIMITER ;

INSERT INTO tickets
VALUES ('TK006', 'P001', 'T001', '2026-05-30', 'A02', 900000);

-- 18.Tạo trigger tg_update_seats tự động giảm total_seats của bảng Trains
-- đi 1 khi có một bản ghi mới được thêm vào bảng Tickets.
DELIMITER $$
CREATE TRIGGER tg_update_seats
AFTER INSERT ON tickets
FOR EACH ROW
BEGIN
	UPDATE trains
    SET total_seats = total_seats - 1
    WHERE train_id = NEW.train_id;
END $$
DELIMITER ;

INSERT INTO tickets
VALUES ('TK006', 'P001', 'T005', '2026-06-02', 'A11', 300000);

-- Phần 5
-- 19. Viết Procedure sp_add_passenger để thêm mới một hành khách.
DELIMITER $$
CREATE PROCEDURE sp_add_passenger(IN p_passenger_id VARCHAR(5),
								  IN p_passenger_full_name VARCHAR(100),
                                  IN p_passenger_email VARCHAR(100),
                                  IN p_passenger_phone VARCHAR(15),
                                  IN p_passenger_cccd VARCHAR(20))
BEGIN
	INSERT INTO passengers
    VALUES (p_passenger_id, p_passenger_full_name, p_passenger_email, p_passenger_phone, p_passenger_cccd);
END $$
DELIMITER ;
CALL sp_add_passenger('P006', 'Nguyen Van A', 'a.nguyen@gmail.com', '0123456789', '001231231230');

-- 20.Viết Procedure sp_cancel_ticket nhận vào p_ticket_id,
-- thực hiện xóa vé trong bảng Tickets và
-- các giao dịch liên quan trong bảng PaymentTransactions.
DELIMITER $$
CREATE PROCEDURE sp_cancel_ticket(IN p_ticket_id VARCHAR(5))
BEGIN
	DELETE FROM payment_transactions
    WHERE ticket_id = p_ticket_id;
    
	DELETE FROM tickets
    WHERE ticket_id = p_ticket_id;  
END $$
DELIMITER ;

CALL sp_cancel_ticket('TK004');

SELECT * FROM passengers;
SELECT * FROM trains;
SELECT * FROM tickets;
SELECT * FROM payment_transactions;

