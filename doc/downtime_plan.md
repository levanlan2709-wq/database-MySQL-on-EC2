# 1. Mục tiêu

Nhóm xây dựng kế hoạch downtime nhằm kiểm soát thời gian gián đoạn trong quá trình di chuyển cơ sở dữ liệu MySQL từ Amazon EC2 sang Amazon Aurora MySQL. Kế hoạch tập trung vào việc hạn chế thời gian ngừng ghi dữ liệu, bảo đảm tính toàn vẹn dữ liệu và chuẩn bị phương án xử lý sự cố khi quá trình di chuyển không thành công.

# 2. Phạm vi downtime

Downtime bắt đầu từ thời điểm hệ thống tạm dừng tiếp nhận các thao tác ghi trên MySQL nguồn và kết thúc khi dữ liệu đã được khôi phục, kiểm tra trên Aurora, đồng thời thao tác ghi vào cơ sở dữ liệu đích được xác nhận thành công.

# 3. Kế hoạch thời gian dự kiến

| Công việc | Thời gian dự kiến |
|---|:-:|
|Tạm dừng ghi dữ liệu MySQL nguồn | 1 phút |
|Sao lưu dữ liệu bằng mysqldump | 3 phút |
|Chuyển file sao lưu | 2 phút |
|Khôi phục dữ liệu vào Aurora | 5 phút |
|Kiểm tra tính toàn vẹn dữ liệu | 3 phút |
|Chuyển kết nối và mở ghi trở lại | 1 phút |
|Tổng thời gian dự kiến | 15 phút |

Thời gian trên là ước tính ban đầu, được sử dụng làm cơ sở lập kế hoạch và sẽ được điều chỉnh sau khi tiến hành kiểm thử trên AWS Learner Lab.

# 4. Phương pháp đo lường

Downtime được xác định theo công thức:

Downtime = Thời điểm kết thúc − Thời điểm bắt đầu.

Nhóm sẽ ghi nhận thời gian khi bắt đầu ngừng ghi dữ liệu trên MySQL nguồn và khi xác nhận Aurora có thể tiếp nhận thao tác ghi thành công. Ngoài ra, thời gian thực hiện từng công đoạn sẽ được ghi lại để đánh giá quá trình di chuyển.

# 5. Kết quả dự kiến

Nhóm đặt mục tiêu hoàn tất quá trình chuyển đổi trong khoảng 15 phút downtime. Sau khi thực nghiệm, nhóm sẽ tổng hợp thời gian thực tế, so sánh với thời gian dự kiến, xác định nguyên nhân chênh lệch và đánh giá hiệu quả kế hoạch.