# 1. Quy tắc đặc tag
| Tag Key | Quy tắc Tag Value | Ý nghĩa |
|---|---|---|
| Name | `migration-<resource>-<purpose>` | Xác định tên tài nguyên |
| Owner | `Quynh` hoặc `Lan` | Thành viên chịu trách nhiệm |

# 2. Quy tắc đặt tên cho các tài nguyên
## `migration-<resource>-<purpose>`
|Tài nguyên	| Name | Owner |
|---|---|---|
|VPC | migration-vpc | Quynh
|Public Subnet | migration-public-subnet | Quynh
|Private Subnet 1 | migration-private-db-1 | Quynh
|Private Subnet 2 | migration-private-db-2 | Quynh
|Internet Gateway | migration-igw | Quynh
|Public Route Table | migration-public-rt | Quynh
|Private Route Table | migration-private-rt | Quynh
|S3 Bucket | migration-s3-bucket | Lan
|EC2 Security Group | migration-ec2-sg | Lan
|Aurora Security Group | migration-aurora-sg | Lan