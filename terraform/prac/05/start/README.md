# 실습

`providers.tf`

- terraform 블록 이동
- aws 프로바이더 블록 이동

---

`main.tf` 파일

- aws_instance 리소스
  - instance_a
    - AMI 이미지: ami-096dce0fcb85a808f
    - 인스턴스 타입: t3.micro
  - instance_b
    - AMI 이미지: ami-096dce0fcb85a808f
    - 인스턴스 타입: t3.micro
    - 의존성
      - aws_s3_bucket 리소스

- aws_eip 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
  - aws_instance.instance_a 인스턴스에 할당

- random 리소스
  - https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
  - 글자 수: 10자
  - 소문자, 숫자 만

- aws_s3_bucket 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
  - 이름: mybucket-<RANDOM>

- aws_s3_bucket_acl 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
  - 버킷: aws_s3_bucket 리소스
  - ACL: public-read

- aws_s3_object 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
  - 버킷: aws_s3_bucket 리소스
  - 키: index.html
  - 소스: index.html

---

`index.html`

```html
<h1> hello world </h1>
```