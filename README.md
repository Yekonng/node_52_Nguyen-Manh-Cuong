# 🍽️ Bài tập SQL - Food Ordering System

## 🚀 Hướng dẫn thực hiện

1. **Mở Docker**  
   → đảm bảo container MySQL đang chạy (ví dụ: `mysql:latest`).

2. **Mở TablePlus** (hoặc MySQL Workbench).  

3. **Tạo mới một database** trong TablePlus.  
   → Đặt tên là `food_ordering`.

4. **Import cấu trúc và dữ liệu**  
   - Nhấp chuột phải vào mục **Tables → Import → From SQL dump…**  
   - Chọn file `food_ordering.sql` để import.

5. **Mở tab SQL Query**,  
   → Copy và dán nội dung trong file `app_food.sql` vào để chạy.

6. **Thực hiện các yêu cầu bài tập:**
   - Tìm 5 người dùng đã like nhà hàng nhiều nhất.  
   - Tìm 2 nhà hàng có lượt like nhiều nhất.  
   - Tìm người đã đặt hàng nhiều nhất.  
   - Tìm người dùng không hoạt động (không đặt hàng, không like, không đánh giá).

7. **Kiểm tra kết quả trả về trong TablePlus** để xác nhận dữ liệu và truy vấn hoạt động đúng.

---

## 🧠 Ghi chú

- Nếu gặp lỗi trùng bảng hoặc database, hãy chạy:
  ```sql
  DROP DATABASE IF EXISTS food_ordering;
# node_52_Nguyen-Manh-Cuong
