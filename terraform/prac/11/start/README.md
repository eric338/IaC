# 실습

> **프리티어 안전 설계**: NAT 게이트웨이·로드밸런서 없이, 퍼블릭 서브넷 + EC2 직접 공인 IP 구조입니다. 10장까지 만든 `modules/instance` 로컬 모듈은 그대로 재사용합니다.

이번 실습은 10장에서 만든 "인스턴스 하나 세트(VPC + 보안 그룹 + EC2들)"를, **서로 다른 설정을 가진 여러 프로젝트로 동시에 찍어내는 것**이 목표입니다. 예를 들어 `proj-alpha`는 인스턴스 2대짜리 개발 환경, `proj-beta`는 인스턴스 1대짜리 테스트 환경, 이런 식으로요.

`variables.tf`

- `project_name`, `project_environment`, `instance_type`, `number_of_instances_per_subnet`, `number_of_subnets` 같은 개별 변수를 지우고
- 그 자리를 대신할 `project` 맵 변수 하나를 추가합니다. 키가 프로젝트 이름, 값이 그 프로젝트의 설정(object)입니다.

---

`main.tf`

- `vpc`, `instance_security_group`, `ec2` **세 모듈 모두**에 `for_each = var.project`를 추가합니다.
- 각 모듈 안에서 `each.key`(프로젝트 이름), `each.value.<필드>`(그 프로젝트의 설정값)로 기존의 고정값들을 대체합니다.
- 서로 다른 `for_each` 모듈끼리 참조할 때는 `module.vpc[each.key]`처럼 **같은 키로 인덱싱**해서 연결해야 합니다. `module.vpc`(키 없이)라고 쓰면 오류가 납니다 — `for_each`로 만들어진 모듈은 그 자체가 "키 -> 모듈 인스턴스"의 맵이기 때문입니다.

---

`outputs.tf`

- `module.ec2`도 이제 "프로젝트 이름 -> 모듈 인스턴스"의 맵입니다. `for` 표현식으로 이 맵을 순회하면서, 각 프로젝트의 특정 출력값만 뽑아 새로운 맵으로 재구성합니다.

---

## 확인 방법

```bash
terraform apply -auto-approve
terraform state list   # module.ec2["proj-alpha"].aws_instance.instance[0] 처럼 프로젝트 이름이 키로 붙어 나오는지 확인
terraform output instance_public_ips
```

출력이 `{ "proj-alpha" = [...], "proj-beta" = [...] }` 형태의 맵으로 나오면 성공입니다.

## 프리티어 주의

`project` 맵에 항목을 더 추가하고 싶은 유혹이 들 수 있는데, **총 인스턴스 수(모든 프로젝트 합산)를 4~6대 이하로 유지**하세요. 프로젝트마다 VPC까지 별도로 생성되므로 리소스 총량이 8~9장보다 훨씬 빠르게 늘어납니다.

## 정리

```bash
terraform destroy -auto-approve
```
