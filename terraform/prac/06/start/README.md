# 실습

## 입력 변수

`variables.tf` 파일 확인

---

`providers.tf`

- aws 프로바이더
  - 리전 변수 참조

---

`main.tf`

- aws_instance
  - AMI 이미지 변수 참조
  - 인스턴스 타입 변수 참조

---

`terraform.tfvars`

리전 변수 값 = 서울 리전 설정

## 출력 값

`outputs.tf`

- 인스턴스 퍼블릭 IP 출력
- 인스턴스 프라이빗 IP 출력
- 인스턴스 Elastic IP 출력

## 로컬 값

`main.tf`

- common_tags
  - Project = 프로젝트 이름 변수 참조
  - Environment = 프로젝트 환경 변수 참조
- suffix_name
  - <프로젝트 이름>-<프로젝트 환경>

- aws_instance
- aws_eip
  - 리소스에 Name 태그를 suffix_name 로컬 값 지정

`provider.tf`

- aws 프로바이더
  - common_tags 로컬 값 기본 태그로 지정
