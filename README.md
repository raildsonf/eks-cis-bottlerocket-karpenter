# eks-cis-bottlerocket

text for the bash command

```bash
export AWS_REGION=us-east-1 
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
#export CLUSTER_NAME=cis-bottlerocket
export CLUSTER_NAME=multi-region-blog-eks1
export ECR_BOOTSTRAP_REPO=bottlerocket-cis-bootstrap-image
export ECR_VALIDATING_REPO=bottlerocket-cis-validating-image

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

```

