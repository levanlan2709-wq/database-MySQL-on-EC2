# 1. Kiểm thử quy trình EC2 MySQL → Backup → S3 → Aurora

Thực hiện kiểm thử quy trình migration trên môi trường AWS Academy Learner Lab.

Quy trình kiểm thử:

1. Kiểm tra dịch vụ MySQL nguồn đang hoạt động trên EC2.
2. Kiểm tra cơ sở dữ liệu Sakila.
3. Chạy script `backup_sakila.sh` để sao lưu dữ liệu.
4. Kiểm tra file backup và mã SHA-256.
5. Upload file backup lên Amazon S3.
6. Tải file từ S3 để kiểm tra tính toàn vẹn.
7. Phối hợp với Lân restore và đối chiếu dữ liệu trên Aurora.

# 2. Kiểm tra dữ liệu nguồn lần cuối trước migration

Kiểm tra cơ sở dữ liệu Sakila trên EC2 MySQL bằng lệnh `SHOW TABLES`, `COUNT(*)` và `CHECK TABLE`.

Kết quả xác nhận Sakila có 16 bảng dữ liệu cơ sở.

| Bảng | Số bản ghi |
|---|:-:|
| actor | 200 |
| address | 603 |
| category | 16 |
| city | 600 |
| country | 109 |
| customer | 599 |
| film | 1000 |
| film_actor | 5462 |
| film_category | 1000 |
| film_text | 1000 |
| inventory | 4581 |
| language | 6 |
| payment | 16044 |
| rental | 16044 |
| staff | 2 |
| store | 2 |

Lệnh `CHECK TABLE` trả về `OK` đối với các bảng actor, film, customer và rental.

# 3. Đo thời gian backup, upload S3 và kích thước file

Sử dụng script backup của tuần 3 kết hợp lệnh `time` để đo thời gian.

| Chỉ số | Kết quả |
|---|---|
| Trạng thái backup | SUCCESS |
| Thời gian backup | 0,299 giây |
| File backup | sakila_20261101T091459Z.sql |
| Kích thước file | 3.387.091 bytes |
| Upload S3 | Thành công |
| Thời gian upload | Chưa có số đo được xác nhận |
| SHA-256 | Trùng khớp |

File backup được lưu trong bucket `migration-mysql-aurora`, thư mục `backups/`.

Kiểm tra SHA-256 sau khi tải file từ S3 xác nhận nội dung bản backup không bị thay đổi trong quá trình upload và download.

# 4. Rà soát bảo mật EC2 MySQL và Amazon S3

Rà soát lại các thiết lập bảo mật đã cấu hình trong tuần 3.

Các nội dung cần xác nhận trong tuần 4 gồm:

- Security Group chỉ cho phép các cổng kết nối cần thiết.
- Quyền truy cập MySQL nguồn được giới hạn phù hợp.
- EC2 sử dụng IAM Role `LabRole`.
- Bucket S3 không cho phép truy cập công khai ngoài ý muốn.
- Kiểm tra Block Public Access và mã hóa dữ liệu trên S3.

# 5. Tổng hợp tài nguyên và chi phí EC2/S3

| Dịch vụ | Thông tin tài nguyên |
|:-:|:---|
| EC2 | Instance type: t3.micro, hệ điều hành: Amazon Linux 2023 |
| EBS | Volume type: gp3, dung lượng: 8 GiB |
| S3 | Bucket: migration-mysql-aurora, số lượng objects: 11, tổng dung lượng: 23.730.529 bytes |
