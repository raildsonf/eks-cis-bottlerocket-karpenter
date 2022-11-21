# eks-cis-bottlerocket

text for the bash command

```bash
export AWS_REGION=us-east-1 
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
#export CLUSTER_NAME=eks-cis-bottlerocket
export CLUSTER_NAME=multi-region-blog-eks1
export ECR_BOOTSTRAP_REPO=bottlerocket-cis-bootstrap-image
export ECR_VALIDATING_REPO=bottlerocket-cis-validating-image

aws ssm start-session --target i-088d8e232a04f262d


eksctl create nodegroup -f cluster.yaml

git clone https://github.com/jalawala/eks-cis-bottlerocket.git
cd eks-cis-bottlerocket

IMAGE_REPO="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

export ECR_REPO=${ECR_BOOTSTRAP_REPO}

IMAGE_NAME=${ECR_BOOTSTRAP_REPO}
export ECR_BOOTSTRAP_REPO_URI=$(aws ecr describe-repositories --repository-name ${IMAGE_NAME}  | jq -r '.repositories[0].repositoryUri')

if [ -z "$ECR_BOOTSTRAP_REPO_URI" ]
then
      echo "${IMAGE_REPO}/${IMAGE_NAME} does not exist. So creating it..."
      ECR_BOOTSTRAP_REPO_URI=$(aws ecr create-repository \
        --repository-name $IMAGE_NAME\
        --region $AWS_REGION \
        --query 'repository.repositoryUri' \
        --output text)
      echo "ECR_BOOTSTRAP_REPO_URI=$ECR_BOOTSTRAP_REPO_URI"
else
      echo "${IMAGE_REPO}/${IMAGE_NAME} already exist..."
fi

cd bottlerocket-cis-bootstrap-image
make  

export ECR_REPO=${ECR_VALIDATING_REPO}

IMAGE_NAME=${ECR_VALIDATING_REPO}

export ECR_VALIDATING_REPO_URI=$(aws ecr describe-repositories --repository-name ${IMAGE_NAME}  | jq -r '.repositories[0].repositoryUri')

if [ -z "$ECR_VALIDATING_REPO_URI" ]
then
      echo "${IMAGE_REPO}/${IMAGE_NAME} does not exist. So creating it..."
      ECR_VALIDATING_REPO_URI=$(aws ecr create-repository \
        --repository-name $IMAGE_NAME\
        --region $AWS_REGION \
        --query 'repository.repositoryUri' \
        --output text)
      echo "ECR_VALIDATING_REPO_URI=$ECR_VALIDATING_REPO_URI"
else
      echo "${IMAGE_REPO}/${IMAGE_NAME} already exist..."
fi

cd ../bottlerocket-cis-validating-image/
make
000474600478.dkr.ecr.us-east-1.amazonaws.com/bottlerocket-cis-validating-image does not exist. So creating it...
ECR_VALIDATING_REPO_URI=000474600478.dkr.ecr.us-east-1.amazonaws.com/bottlerocket-cis-validating-image




```
text for the bash command

```bash

br-mng-v1-1

ip-192-168-46-170.ec2.internal
aws ssm start-session --target i-0efa5093c33610899



aws ssm start-session --target i-053b69fa7e3861413



multi-region-blog-eks1




cat > cluster.yaml <<EOF
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: multi-region-blog-eks1
  region: us-east-1
  version: '1.23'

managedNodeGroups:
  - name: bottlerocket-mng2
    instanceType: m5.large
    desiredCapacity: 1
    amiFamily: Bottlerocket
    iam:
       attachPolicyARNs:
          - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
          - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
          - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
          - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
    ssh:
        allow: false
        #publicKeyName: awsajp_keypair
    bottlerocket:
      settings:
        motd: "Hello from eksctl! - custom user data for Bottlerocket"
        bootstrap-containers:
          cis-bootstrap:
            source: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/bottlerocket-cis-bootstrap-image:latest
            mode: once
        kernel:
          lockdown: "integrity"
          modules:
            udf:
              allowed: false
            sctp:
              allowed: false
          sysctl:
               # 3.1.1
               "net.ipv4.conf.all.send_redirects": "0"
               "net.ipv4.conf.default.send_redirects": "0"
               
               # 3.2.2
               "net.ipv4.conf.all.accept_redirects": "0"
               "net.ipv4.conf.default.accept_redirects": "0"
               "net.ipv6.conf.all.accept_redirects": "0"
               "net.ipv6.conf.default.accept_redirects": "0"
               
               # 3.2.3
               "net.ipv4.conf.all.secure_redirects": "0"
               "net.ipv4.conf.default.secure_redirects": "0"
               
               # 3.2.4
               "net.ipv4.conf.all.log_martians": "1"
               "net.ipv4.conf.default.log_martians": "1"
EOF


eksctl create cluster -f cluster.yaml

bottlerocket-mng2

```

text for the bash command

```bash

```

text for the bash command

```bash

```
text for the bash command

```bash

```
text for the bash command

```bash

```

text for the bash command

```bash

```

text for the bash command

```bash

```
text for the bash command

```bash

```
text for the bash command

```bash

```


text for the bash command

```bash

```

text for the bash command

```bash

```
text for the bash command

```bash

```
text for the bash command

```bash

```

text for the bash command

```bash

```

text for the bash command

```bash

```
text for the bash command

```bash

```
text for the bash command

```bash

```
