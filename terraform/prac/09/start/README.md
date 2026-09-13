# 실습

> **프리티어 안전 설계**: 8장과 마찬가지로 NAT 게이트웨이·로드밸런서 없이, 퍼블릭 서브넷 + EC2 직접 공인 IP 구조입니다.

`variables.tf`

- `number_of_instances_per_subnet` 변수 추가 (기본값 1)
- `number_of_subnets` 변수 추가 (기본값 2)

---

`main.tf`

- `vpc` 모듈
  - `public_subnets`: `slice()` 함수로 `var.public_subnets` 중 `number_of_subnets` 개수만큼만 사용

- `aws_instance` 리소스
  - 기존 `instance_a`/`instance_b` 두 블록을 `count` 메타 인수를 쓰는 블록 하나로 통합
  - `count`: `number_of_subnets * number_of_instances_per_subnet`
  - `subnet_id`: `count.index % number_of_subnets`로 나머지 연산을 해서 서브넷에 고르게 분산 배치
  - 태그 이름에 `count.index` 포함

---

`outputs.tf`

- `instance_public_ips`: 모든 인스턴스의 공인 IP를 목록으로 출력
- `instance_private_ips`: 모든 인스턴스의 사설 IP를 목록으로 출력
- `instance_ids`: 모든 인스턴스의 ID를 목록으로 출력

---

## 확인 방법

```bash
terraform apply -auto-approve
terraform state list   # aws_instance.instance[0], [1] 처럼 인덱스가 붙어 나오는지 확인

for ip in $(terraform output -json instance_public_ips | tr -d '[]," '); do
  curl "http://$ip"
done
```

## 프리티어 주의

`number_of_instances_per_subnet`나 `number_of_subnets`를 키우면 인스턴스가 그만큼 늘어납니다. **실습에서는 총 인스턴스 수를 4대 이하로 유지**하세요.

## 정리

```bash
terraform destroy -auto-approve
```
