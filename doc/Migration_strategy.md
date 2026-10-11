## 1. Mục tiêu migration

Chuyển cơ sở dữ liệu MySQL tự quản trên Amazon EC2 sang Amazon Aurora MySQL, bảo đảm toàn bộ schema và dữ liệu được chuyển đầy đủ và chính xác. Đảm bảo tính nhất quán dữ liệu, đo downtime thực tế, và xác nhận Aurora có thể đọc/ghi bình thường sau cutover.

## 2. Chiến lược migration

Nhóm lựa chọn chiến lược migration offline theo phương pháp logical dump/restore. Dữ liệu từ MySQL tự quản trên Amazon EC2 được xuất bằng mysqldump, lưu bản sao trên Amazon S3, sau đó import vào Amazon Aurora MySQL thông qua writer endpoint. Trong thời gian migration, thao tác ghi trên cơ sở dữ liệu nguồn được tạm dừng nhằm đảm bảo tính nhất quán. Sau khi restore, nhóm đối chiếu schema, số lượng bản ghi và kết quả truy vấn giữa cơ sở dữ liệu nguồn và đích. Khi kết quả kiểm tra đạt yêu cầu mới thực hiện cutover sang Aurora. MySQL nguồn trên EC2 được giữ lại tạm thời làm phương án rollback nếu có xảy ra lỗi trong quá trình migration.

## 3. Quy trình cụ thể

| Giai đoạn | Công việc |
| --- | --- |
| Chuẩn bị nguồn | Chuẩn bị MySQL trên EC2, database Sakila, số bảng và số bản ghi |
| Chuẩn bị đích | Tạo Aurora MySQL, DB Subnet Group, Security Group, kiểm tra EC2 kết nối Aurora qua port 3306 |
| Pre - migration check | Kiểm tra version MySQL, schema, charset/collation, dung lượng dữ liệu và kết nối mạng |
| Dừng ghi dữ liệu | Tạm ngừng các thao tác ghi lên MySQL nguồn để dữ liệu không thay đổi trong lúc dump |
| Backup | Dùng mysqldump tạo file .sql |
| Lưu backup | Upload file dump lên S3 |
| Restore | Import .sql từ EC2 vào Aurora bằng MySQL client |
| Validation | So sánh table count, row count, dữ liệu mẫu, PK/FK/index và query kết quả giữa EC2 và Aurora |
| Cutover | Chuyển kết nối ứng dụng hoặc client sang Aurora writer endpoint và mở lại thao tác ghi trên Aurora. |
| Theo dõi | Kiểm tra kết nối, lỗi, hiệu năng và Cloudwatch |
| Rollback nếu lỗi | Tiếp tục sử dụng MySQL EC2 nguồn và restore lại từ file backup nếu cần |
