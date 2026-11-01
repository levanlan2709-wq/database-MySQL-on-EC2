# 1. Kiểm thử Aurora MySQL sau restore

Tiến hành kết nối từ EC2 MySQL nguồn đến Amazon Aurora MySQL thông qua Writer Endpoint của cluster `migration-aurora-cluster`.

Thực hiện các truy vấn kiểm tra cơ sở dữ liệu Sakila sau restore. Kết quả xác nhận Aurora có thể thực hiện truy vấn SQL thành công.

Các bảng kiểm tra bao gồm:

| Bảng | Số bản ghi |
|---|---:|
| actor | 200 |
| film | 1000 |
| customer | 599 |
| rental | 16044 |

# 2. Kiểm tra và đối chiếu dữ liệu Aurora với MySQL nguồn

Thực hiện kiểm tra bằng câu lệnh `COUNT(*)` trên 16 bảng của cơ sở dữ liệu Sakila.

| Nội dung | Kết quả |
|---|---|
| Số bảng được đối chiếu | 16 |
| Số bảng trùng số bản ghi | 16 |
| Số bảng khác biệt | 0 |
| Kết quả đối chiếu số lượng bản ghi | PASS |

# 3. Đo thời gian restore và downtime

Sử dụng script `restore_drill_w4.sh`, `restore_timing_w4.sh`, `mark_downtime_w4.sh` và `calculate_downtime_w4.sh` để thực hiện kiểm thử và đo thời gian.

Kết quả restore được ghi nhận trong lần thử đầu:

- Restore time: 4 giây.
- Restore status: SUCCESS.

Kết quả đo quy trình migration mô phỏng:

| Giai đoạn | Thời gian |
|---|---:|
| Chuẩn bị backup từ S3 | 55 giây |
| Restore phase | 139 giây |
| Validation | 19 giây |
| Cutover check | 15 giây |
| **Tổng thời gian** | **228 giây (3 phút 48 giây)** |

# 4. Kiểm thử Rollback Plan lần cuối

Thực hiện kiểm thử Rollback Plan theo phương pháp `PRE_CUTOVER_SIMULATION`.

Trong quá trình kiểm thử, MySQL nguồn trên EC2 tiếp tục hoạt động và có thể phục vụ các truy vấn dữ liệu khi quá trình migration bị hủy trước cutover.

| Nội dung | Kết quả |
|---|---|
| SOURCE_CONNECTION | PASS |
| SOURCE_TABLE_COUNT | 16 |
| SOURCE_DATA_CHECK | PASS |
| ROLLBACK_READINESS | PASS |
| APPLICATION_CUTOVER | NOT_PERFORMED |

# 5. Tổng hợp CloudWatch Monitoring và Alarm

Tiến hành kiểm tra các chỉ số giám sát Aurora thông qua Amazon CloudWatch.

Các metric được lựa chọn:

- `CPUUtilization`: Theo dõi tỷ lệ sử dụng CPU.
- `DatabaseConnections`: Theo dõi số kết nối đến Aurora.
- `FreeableMemory`: Theo dõi bộ nhớ khả dụng.

Kiểm tra ba CloudWatch Alarm đã cấu hình từ tuần 3:

| Alarm | Trạng thái quan sát |
|---|:-:|
| migration-aurora-cpu-high | Insufficient data |
| migration-aurora-memory-low | Insufficient data |
| migration-aurora-connections-high | Insufficient data |

# 6. Đánh giá cấu hình và chi phí Aurora

| Thành phần | Thông tin |
|---|---|
| DB Cluster | migration-aurora-cluster |
| Database Engine | Aurora MySQL |
| Region | us-east-1 |
| DB Instance | migration-aurora-cluster-instance-1 |
| Instance Class | db.t3.medium |
| vCPU | 2 |
| RAM | 4 GiB |
