# 실습

이 장의 애플리케이션 코드(`main.tf`, `variables.tf`, `outputs.tf`, `modules/`)는 11장의 완성본과 동일합니다. 이번 실습의 대상은 오직 `providers.tf`의 `backend` 블록입니다.

## 1단계. 상태 저장용 S3 버킷 만들기

`../s3_backend` 디렉터리를 참고하세요. **DynamoDB 테이블은 만들지 않습니다** — 최신 Terraform(1.11+)의 S3 백엔드는 `use_lockfile = true` 옵션만으로 DynamoDB 없이 락을 관리할 수 있습니다.

```bash
cd ../s3_backend
terraform init
terraform apply -auto-approve
# 출력된 tfstate_bucket_name 값을 적어두세요
```

## 2단계. S3 백엔드로 완성하기

`providers.tf`의 `terraform` 블록 안에 `backend "s3" { ... }`를 추가하세요.

- `bucket`: 1단계에서 만든 실제 버킷 이름
- `key`: `tfstate/terraform.tfstate`
- `region`: `ap-northeast-2`
- `encrypt`: `true`
- `use_lockfile`: `true` ← DynamoDB 테이블 없이 락을 관리하는 최신 방식입니다

완성본은 `../complete-s3`를 참고하세요.

```bash
terraform init   # "Successfully configured the backend \"s3\"!" 메시지 확인
terraform apply -auto-approve
ls   # terraform.tfstate 파일이 로컬에 없는지 확인 (S3에 저장되었기 때문)
```

## (선택) 3단계. HCP Terraform 백엔드로 완성하기

시간이 되면 S3 대신 `cloud` 블록으로도 시도해보세요. 완성본은 `../complete-tfc`를 참고하세요. [app.terraform.io](https://app.terraform.io)에서 조직·워크스페이스를 먼저 만들고 `terraform login`으로 CLI를 연동해야 합니다.

## 정리 — 순서 중요!

```bash
# 1) 먼저 이 디렉터리(앱 인프라)를 지웁니다
terraform destroy -auto-approve

# 2) 그 다음 상태 저장용 S3 버킷을 지웁니다
cd ../s3_backend
terraform destroy -auto-approve
```

순서를 반대로 하면 상태를 담고 있던 버킷이 먼저 사라져서 앱 인프라를 정상적으로 지울 수 없게 됩니다.
