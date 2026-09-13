# 실습

`main.tf`

- aws_ami 데이터 소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
  - 최신 버전
  - 소유자: 099720109477 (Canonical/Ubuntu 공식 계정 — "amazon" 별칭으로는 우분투가 검색되지 않음)
  - 필터
    - 이름
    - ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*

- cloudinit_config 데이터 소스
  - https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config
  - gzip 비활성
  - base64 인코딩 비활성 (base64_encode = false — user_data가 다시 인코딩하므로)
  - userdata.sh 스크립트 파일
  - providers.tf에 cloudinit 프로바이더 추가

- aws_instance 리소스
  - user_data
    - 아래 중 하나 구성
      - Heredoc
      - file 함수
      - templatefile 함수
      - cloudinit_config 데이터 소스

- aws_security_group 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  - egress: 모두 허용
  - ingress: tcp, 80, 모든 CIDR 허용

---

`variables.tf`

AMI 이미지 변수 제거

---

`script/userdata.sh`

```bash
#!/bin/bash
apt update
apt install -y apache2
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id -o /var/www/html/index.html
```
(우분투 24.04 AMI는 IMDSv2를 강제하므로 토큰을 먼저 받아야 메타데이터 조회가 됩니다.)

---

(옵션: templatefile 함수 사용 시) `template/userdata.tftpl`

```bash
#!/bin/bash
apt update
apt install -y apache2
echo ${message} > /var/www/html/index.html
```