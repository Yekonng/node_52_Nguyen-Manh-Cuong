-- BÀI TẬP BUỔI 4 MYSQL - NGUYỄN MẠNH CƯỜNG

-- Tạo Database
CREATE DATABASE IF NOT EXISTS `food_ordering`
-- Sử dụng Database
USE `food_ordering`
-- RESET DATABASE
DROP DATABASE IF EXISTS `food_ordering`
-- Tạo các Bảng
		-- XOÁ CÁC BẢNG
			-- Tắt FK
			SET FOREIGN_KEY_CHECKS = 0
			-- Xoá Table (theo thứ tự từng Table một)
			DROP TABLE IF EXISTS `order`
			DROP TABLE IF EXISTS `rate_res`
			DROP TABLE IF EXISTS `like_res`
			DROP TABLE IF EXISTS `restaurant`
			DROP TABLE IF EXISTS `user`
			DROP TABLE IF EXISTS `food_type`
			DROP TABLE IF EXISTS `sub_food`
			DROP TABLE IF EXISTS `food`
			-- Bật lại FK
			SET FOREIGN_KEY_CHECKS = 1
	-- 
CREATE TABLE `user` (
	`user_id` INT PRIMARY KEY AUTO_INCREMENT,
	`full_name` VARCHAR(100),
	`email` VARCHAR(100),
	`password` VARCHAR(100)
)
	--
CREATE TABLE `restaurant` (
    `res_id` INT PRIMARY KEY AUTO_INCREMENT,
    `res_name` VARCHAR(100),
    `image` VARCHAR(255),
    `desc` VARCHAR(255)
)
	--
CREATE TABLE `food_type` (
    `type_id` INT PRIMARY KEY AUTO_INCREMENT,
    `type_name` VARCHAR(100)
)
	--
CREATE TABLE `food` (
    `food_id` INT PRIMARY KEY AUTO_INCREMENT,
    `food_name` VARCHAR(100),
    `image` VARCHAR(255),
    `price` FLOAT,
    `desc` VARCHAR(255),
    `type_id` INT,
    FOREIGN KEY (`type_id`) REFERENCES `food_type` (`type_id`)
)
	--
CREATE TABLE `sub_food` (
    `sub_id` INT PRIMARY KEY AUTO_INCREMENT,
    `sub_name` VARCHAR(100),
    `sub_price` FLOAT,
    `food_id` INT,
    FOREIGN KEY (`food_id`) REFERENCES `food` (`food_id`)
)
	--
CREATE TABLE `order` (
    `order_id` INT PRIMARY KEY AUTO_INCREMENT,
    `user_id` INT,
    `food_id` INT,
    `amount` INT,
    `code` VARCHAR(50),
    `arr_sub_id` VARCHAR(100),
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    FOREIGN KEY (`food_id`) REFERENCES `food` (`food_id`)
)
	--
CREATE TABLE `like_res` (
    `user_id` INT,
    `res_id` INT,
    `date_like` DATETIME,
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    FOREIGN KEY (`res_id`) REFERENCES `restaurant` (`res_id`)
)
	--
CREATE TABLE `rate_res` (
    `user_id` INT,
    `res_id` INT,
    `amount` INT,
    `date_rate` DATETIME,
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    FOREIGN KEY (`res_id`) REFERENCES `restaurant` (`res_id`)
)
-- Thêm dữ liệu cho các Bảng -> File data_table.sql
	
-- XỬ LÝ CÁC YÊU CẦU
	-- Tìm 5 người đã like nhà hàng nhiều nhất
		-- INNER JOIN chỉ lấy những người dùng có bản ghi trong like_res (tức là đã từng like ít nhất một nhà hàng).
		-- Dùng COUNT() để đếm số lượt like.
		-- ORDER BY DESC để lấy top người like nhiều nhất.
SELECT 
    `user`.`user_id`,
    `user`.`full_name`,
    COUNT(`like_res`.`res_id`) AS `total_like`
FROM `user`
INNER JOIN `like_res`
    ON `user`.`user_id` = `like_res`.`user_id`
GROUP BY 
    `user`.`user_id`, 
    `user`.`full_name`
ORDER BY 
    `total_like` DESC
LIMIT 5
	-- Tìm 2 nhà hàng có lượt like nhiều nhất
		-- INNER JOIN vì chỉ cần xét các nhà hàng đã được like ít nhất 1 lần.
		-- Đếm số người đã like mỗi nhà hàng.
		-- Sắp xếp theo lượt like giảm dần, lấy top 2.
SELECT 
    `restaurant`.`res_id`,
    `restaurant`.`res_name`,
    COUNT(`like_res`.`user_id`) AS `total_like`
FROM `restaurant`
INNER JOIN `like_res`
    ON `restaurant`.`res_id` = `like_res`.`res_id`
GROUP BY 
    `restaurant`.`res_id`, 
    `restaurant`.`res_name`
ORDER BY 
    `total_like` DESC
LIMIT 2
	-- Tìm người đã đặt hàng nhiều nhất
		-- INNER JOIN chỉ lấy người dùng có đơn hàng (order).
		-- Đếm tổng số đơn hàng (COUNT(order_id)).
		-- Sắp xếp giảm dần, lấy người có nhiều đơn nhất (LIMIT 1).
SELECT 
    `user`.`user_id`,
    `user`.`full_name`,
    COUNT(`order`.`order_id`) AS `total_orders`
FROM `user`
INNER JOIN `order`
    ON `user`.`user_id` = `order`.`user_id`
GROUP BY 
    `user`.`user_id`, 
    `user`.`full_name`
ORDER BY 
    `total_orders` DESC
LIMIT 1
	-- Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng)
		-- LEFT JOIN để vẫn hiển thị tất cả người dùng dù không có hoạt động nào.
		-- Nếu người dùng chưa từng đặt hàng, like, hay đánh giá, thì các giá trị order_id, res_id sẽ NULL.
		-- WHERE ... IS NULL lọc ra đúng nhóm người không hoạt động.
SELECT 
    `user`.`user_id`,
    `user`.`full_name`
FROM `user`
LEFT JOIN `order`
    ON `user`.`user_id` = `order`.`user_id`
LEFT JOIN `like_res`
    ON `user`.`user_id` = `like_res`.`user_id`
LEFT JOIN `rate_res`
    ON `user`.`user_id` = `rate_res`.`user_id`
WHERE 
    `order`.`order_id` IS NULL
    AND `like_res`.`res_id` IS NULL
    AND `rate_res`.`res_id` IS NULL