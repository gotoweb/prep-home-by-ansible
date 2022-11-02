## 리눅스 연습용 인프라

이 프로젝트의 목표는 다음과 같습니다.

1. EC2 인스턴스를 IaC로 생성
2. EC2 인스턴스에 각 수강생용 계정 및 홈 디렉토리(일종의 playground) 생성
3. 각 수강생용 계정은 별도로 제공되는 private key (pem 형식)을 이용하여 ssh 접속이 가능해야 함
4. 수강생이 지침에 따라 실습을 진행했는지 여부를 파악해야 함
5. 실습 진행 여부가 평가 데이터베이스에 잘 기록될 수 있도록 준비

## 디렉토리 구성

```
.
├── README.md
├── ec2.tf              EC2 인프라를 IaC로 만듭니다. 프로젝트 목표 (1)을 달성합니다.
├── multiuser.sh        EC2 생성 후 처음 실행할 사용자 데이터(user-data)입니다.
├── remote-files        S3 bucket에 올라가게 될 파일입니다.
│   ├── loop.sh         ec2-user가 sudo 권한으로 실행하려는 스크립트입니다. 프로젝트 목표 (2),(3)을 달성합니다.
│   └── users.csv       수강생 아이디가 기록되어 있습니다.
├── s3.tf               S3 인프라를 IaC로 만듭니다. (미완성)
└── test                실습 여부 확인용 파일입니다.
    ├── inventory.yaml  ansible-playbook이 사용할 인벤토리 파일입니다.
    └── playbook.yaml   확인을 위해 어떤 명령을 수행할 것인지를 작성한 파일입니다.
```

## 준비물
- terraform
- ansible


## 인프라 준비

1. 수강생 접속용 키 페어 생성
    - `ssh-keygen`을 이용하여 키 페어를 생성합니다. (키 페어는 어디에서 생성해도 상관이 없습니다)
    - public key는 각 수강생용 계정에 인증 키로 전달될 것입니다. `/home/user/.ssa/authorized_keys`
    - private key(pem 파일)은 별도로 보관하고 있어야 하며, 추후 엔지니어에 의해 배포되어야 합니다.
2. `remote-files/loop.sh` 수정
    - public key를 `authorized_keys`에 쓰는 과정이 있습니다. 앞서 생성한 public key로 변경하여야 합니다.
    - ⚠️ 이 부분은 자동화가 필요합니다.
3. `remote-files/users.csv` 수정
    - 수강생 아이디를 줄 단위로 입력합니다.
4. terraform으로 인프라를 생성합니다.
5. 수강생 권한으로 접속합니다.
    ```
    $ ssh -i "student.pem" USERNAME@ec2-xx-xx-xx-xx.ap-northeast-2.compute.amazonaws.com
    ```
    - ⚠️ hostname 대신 Elastic IP를 고려해볼 필요가 있습니다.

## 수강생 평가

1. 인벤토리(`test/inventory.yaml`) 수정
    - `ansible_ssh_private_key_file`: private key 파일의 위치를 정의합니다.
    - `ansible_host`: EC2 주소를 지정합니다.
2. 다음 명령을 이용해 테스트를 진행합니다.
    ```
    $ ansible-playbook -i test/inventory.yaml test/playbook.yaml
    ```

## 주의사항

- ⚠️ 아직 S3 인프라 자동화는 미완성이며, remote-files 내 파일을 업로드할 버킷은 수동으로 생성해야 합니다.
- ⚠️ 이에 따라 multiuser.sh 의 S3 객체 주소는 수동으로 변경해야 합니다.