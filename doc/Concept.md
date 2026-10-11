 # VPC, networking, IAM, S3, EC2 và Aurora
 **1. VPC (Virtual Private Cloud):** Là dịch vụ mạng riêng ảo trên AWS, cho phép người dùng xây dựng môi trường mạng được cô lập để triển khai các tài nguyên. VPC hỗ trợ cấu hình dải địa chỉ IP, phân chia Subnet, thiết lập định tuyến và kiểm soát kết nối giữa các tài nguyên như EC2 và Aurora.

**2. Networking (Mạng):** Là tập hợp các thành phần và cơ chế mạng giúp các tài nguyên AWS kết nối, giao tiếp và trao đổi dữ liệu. Networking bao gồm Subnet để phân chia mạng, Route Table để định tuyến, Internet Gateway để kết nối Internet và Security Group để kiểm soát lưu lượng truy cập.

**3. IAM (Identity and Access Management):** Là dịch vụ quản lý danh tính và quyền truy cập trên AWS, cho phép xác thực người dùng, phân quyền và kiểm soát các thao tác đối với tài nguyên. IAM sử dụng các thành phần như User, Group, Role và Policy để quản lý quyền truy cập, bảo đảm chỉ những đối tượng được cấp quyền mới có thể thực hiện các hành động tương ứng.

**4. Amazon S3 (Simple Storage Service):** Là dịch vụ lưu trữ đối tượng trên AWS, cho phép lưu trữ và quản lý dữ liệu thông qua các Bucket. S3 hỗ trợ lưu trữ tệp tin, bản sao lưu, hình ảnh và tài liệu, đồng thời cung cấp các tính năng bảo mật như mã hóa, quản lý quyền truy cập và quản lý phiên bản dữ liệu.

**5. Amazon EC2 (Elastic Compute Cloud):** Là dịch vụ cung cấp máy chủ ảo trên nền tảng AWS, cho phép người dùng lựa chọn và tùy chỉnh CPU, RAM, hệ điều hành, dung lượng lưu trữ và cấu hình mạng. EC2 được sử dụng để triển khai ứng dụng, vận hành máy chủ và cài đặt các hệ quản trị cơ sở dữ liệu như MySQL.

**6. Amazon Aurora:** Là dịch vụ cơ sở dữ liệu quan hệ được AWS quản lý, tương thích với MySQL và PostgreSQL. Aurora cung cấp khả năng mở rộng, sao lưu tự động, phục hồi dữ liệu và tính sẵn sàng cao nhờ kiến trúc lưu trữ phân tán trên nhiều Availability Zone, giúp giảm công việc quản trị cơ sở dữ liệu so với MySQL tự quản trên EC2.