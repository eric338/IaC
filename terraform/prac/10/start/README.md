# 실습

> **프리티어 안전 설계**: NAT 게이트웨이·로드밸런서 없이, 퍼블릭 서브넷 + EC2 직접 공인 IP 구조를 그대로 로컬 모듈로 옮깁니다.

이번 실습의 목표는 9장에서 루트 모듈에 직접 작성했던 "AMI 조회 + user_data + count 반복 인스턴스 생성" 로직을, `modules/instance`라는 **로컬 자식 모듈**로 분리하는 것입니다.

`modules/instance/main.tf`

- `aws_ami` 데이터 소스: 루트 모듈에서 그대로 이동
- `cloudinit_config` 데이터 소스: 루트 모듈에서 그대로 이동
- `aws_instance` 리소스: 루트 모듈에서 그대로 이동
  - `subnet_id`, `vpc_security_group_ids`: 이제 `module.vpc`, `module.instance_security_group`을 직접 참조할 수 없습니다(모듈 밖의 리소스이므로). 대신 `var.instance_subnet_ids`, `var.instance_sg_ids`로 **부모 모듈이 넘겨주는 값**을 받아서 씁니다.

---

`modules/instance/variables.tf`

- 루트 모듈의 변수 정의를 복사하되, **기본값(`default`)은 제거**합니다. 로컬 모듈은 항상 호출하는 쪽(루트 모듈)에서 값을 주입받아야 하기 때문입니다.
- `instance_subnet_ids`, `instance_sg_ids` 변수를 새로 추가합니다.

---

`modules/instance/outputs.tf`

- 루트 모듈에 있던 출력 정의(`instance_public_ips`, `instance_private_ips`, `instance_ids`)를 이 파일로 옮깁니다.

---

`main.tf` (루트 모듈)

- 기존 데이터 소스/EC2 리소스 블록을 전부 지우고, 대신 `module "ec2" { source = "./modules/instance" ... }`로 호출합니다.
- `module "ec2"`에 넘기는 인수 이름은 `modules/instance/variables.tf`에 정의한 변수 이름과 정확히 일치해야 합니다.

---

`outputs.tf` (루트 모듈)

- `module.ec2.instance_public_ips`처럼 `module.<이름>.<출력값>` 형태로 자식 모듈의 출력을 다시 참조합니다.

---

## 확인 방법

```bash
terraform init   # "Initializing modules..." 에 modules/instance가 로컬 경로로 잡히는지 확인
terraform apply -auto-approve
terraform state list   # module.ec2.aws_instance.instance[0] 처럼 모듈 경로가 붙어 나오는지 확인
```

## 정리

```bash
terraform destroy -auto-approve
```
