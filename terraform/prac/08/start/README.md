# 실습

> **프리티어 안전 설계**: 원래 이 실습은 NAT 게이트웨이 + 프라이빗 서브넷 + Classic 로드밸런서(ELB) 구조였습니다. NAT 게이트웨이는 AWS 프리티어가 전혀 없어 켜두면 실제 비용이 발생하므로, 이 버전에서는 **NAT 게이트웨이 없이 퍼블릭 서브넷에 EC2를 직접 배치**하고, 로드밸런서 대신 **각 인스턴스의 공인 IP로 직접 접속**하는 구조로 바꿨습니다. 모듈을 가져다 쓰는 법, 데이터 소스 등 배우는 개념은 동일합니다.

`main.tf`

- `aws_availability_zones` 데이터 소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
  - 현재 사용 가능한 가용 영역 정보 가져오기 (`state = "available"`)

- `vpc` 모듈
  - https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  - `cidr`: `var.vpc_cidr`
  - `azs`: `aws_availability_zones` 데이터 소스 참조
  - `public_subnets`: `var.public_subnets`
  - `map_public_ip_on_launch`: `true` (인스턴스에 공인 IP 자동 할당)
  - `enable_nat_gateway`: **`false`** ← 프리티어 안전을 위해 반드시 꺼야 합니다
  - `enable_vpn_gateway`: `false`

- `instance_security_group` 모듈
  - https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
  - `http-80` 하위 모듈 지정
  - `vpc_id`: VPC 모듈에서 생성되는 VPC ID
  - `ingress_cidr_blocks`: `["0.0.0.0/0"]` (이제 로드밸런서가 없으므로 인스턴스가 직접 인터넷에서 80번 포트를 받아야 합니다)

- `aws_instance` 리소스 (`instance_a`, `instance_b` 둘 다)
  - `subnet_id`: VPC 모듈의 퍼블릭 서브넷 (`instance_a`는 0번, `instance_b`는 1번 인덱스)
  - `vpc_security_group_ids`: `instance_security_group` 모듈에서 생성되는 리소스 ID

---

`outputs.tf`

- `instance_public_ip_a` / `instance_public_ip_b`: 각 인스턴스의 공인 IP 출력
- `instance_private_ip_a` / `instance_private_ip_b`: 각 인스턴스의 사설 IP 출력
- (로드밸런서 DNS 출력은 이 버전에는 없습니다 — 로드밸런서 자체를 쓰지 않습니다)

---

## 확인 방법

```bash
terraform apply -auto-approve
curl http://$(terraform output -raw instance_public_ip_a)
curl http://$(terraform output -raw instance_public_ip_b)
```

두 인스턴스 모두 각자의 인스턴스 ID가 담긴 페이지로 응답하면 성공입니다.

## 정리

```bash
terraform destroy -auto-approve
```
