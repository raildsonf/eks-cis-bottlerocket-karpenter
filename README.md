# Validating Amazon EKS optimized Bottlerocket AMI against the CIS Benchmark

You will also need to configure the following environment variables:

```bash
export AWS_REGION=us-east-1 
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
export CLUSTER_NAME=bottlerocket-cis-blog-eks
#export CLUSTER_NAME=multi-region-blog-eks1
export BOOTSTRAP_ECR_REPO=bottlerocket-cis-bootstrap-image
export VALIDATION_ECR_REPO=bottlerocket-cis-validating-image

```

## Building a bootstrap container image

create an Amazon ECR repository

```bash
cd bottlerocket-cis-bootstrap-image
chmod +x create-ecr-repo.sh
./create-ecr-repo.sh
```

build the bootstrap container image and push

```bash
make

```
Create Amazon EKS Cluster with EKS Managed Node group with Bottlerocket AMI

```bash
cat > cluster.yaml <<EOF
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: $CLUSTER_NAME
  region: $AWS_REGION
  version: '1.24'

managedNodeGroups:
  - name: bottlerocket-mng
    instanceType: m5.large
    desiredCapacity: 2
    amiFamily: Bottlerocket
    iam:
       attachPolicyARNs:
          - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
          - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
          - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
          - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
    ssh:
        allow: false
    bottlerocket:
      settings:
        motd: "Hello from eksctl! - custom user data for Bottlerocket"
        bootstrap-containers:
          # 3.4
          cis-bootstrap:
            source: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$BOOTSTRAP_ECR_REPO:latest
            mode: once
        kernel:
          # 1.5.2
          lockdown: "integrity"
          modules:
            # 1.1.1.1
            udf:
              allowed: false
            # 3.3.1
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

```
Create the cluster

```bash
eksctl create cluster -f cluster.yaml
```
Once cluster is created, ensure that kubectl works fine.

```bash
kubectl get nodes
```

Once the cluster has been provisioned, you can verify the bootstrap container ran successfully on the Bottlerocket host. 

```bash
aws ssm start-session --target $(aws ec2 describe-instances --filters "Name=tag:Name,Values=bottlerocket-cis-blog-eks-bottlerocket-mng-Node" | jq -r '.[][0]["Instances"][0]["InstanceId"]')
[ssm-user@control]$ enter-admin-container
[root@admin]# sudo sheltie
bash-5.1# journalctl -u bootstrap-containers@cis-bootstrap.service

```
deploy a sample application to make sure everything is running properly.

```bash
kubectl apply -f deploy-nginx.yaml
kubectl get pod
```

```bash
root@nginx-74d589986c-xqkqb:/# curl 127.0.0.1:80

```

Run below command to access the logs from the pod

```bash
kubectl logs -f  $POD_NAME
```

Validating the Bottlerocket AMI against the CIS Benchmark

```bash
cd bottlerocket-cis-validating-image
chmod +x create-ecr-repo.sh
./create-ecr-repo.sh
```

job object which references the validation image onto the cluster.

```bash

cd ..
cat > job-eks.yaml <<EOF
---
apiVersion: batch/v1
kind: Job
metadata:
  name: eks-cis-benchmark
spec:
  ttlSecondsAfterFinished: 600
  template:
    metadata:
      labels:
        app: eks-cis-benchmark   
    spec:
      hostNetwork: true
      nodeSelector:
         eks.amazonaws.com/nodegroup: bottlerocket-mng    
      containers:
        - name: eks-cis-benchmark
          image: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$VALIDATION_ECR_REPO
          imagePullPolicy: Always
          securityContext:
            privileged: true
      restartPolicy: Never
EOF

```

Apply the batch job using kubectl and check if the pod completed the execution.

```bash
kubectl apply -f job-eks.yaml
kubectl get Job,pod
```
we can view the pod logs to verify the CIS Bottlerocket Benchmark compliance status of the node.


```bash
POD_NAME=$(kubectl get pods -l=app=eks-cis-benchmark -o=jsonpath={.items..metadata.name})
kubectl logs $POD_NAME
```
The output should look like below.

```bash
This tool validates the Amazon EKS optimized AMI against CIS Bottlerocket Benchmark v1.0.0
[PASS] 3.1.1 Ensure packet redirect sending is disabled (Automated)
[PASS] 3.2.2 Ensure ICMP redirects are not accepted (Automated)
[PASS] 3.2.3 Ensure secure ICMP redirects are not accepted (Automated)
[PASS] 3.2.4 Ensure suspicious packets are logged (Automated)
[PASS] 3.4.1.1 Ensure IPv4 default deny firewall policy (Automated)
[PASS] 3.4.1.2 Ensure IPv4 loopback traffic is configured (Automated)
[PASS] 3.4.1.3 Ensure IPv4 outbound and established connections are configured (Manual)
[PASS] 3.4.2.1 Ensure IPv6 default deny firewall policy (Automated)
[PASS] 3.4.2.2 Ensure IPv6 loopback traffic is configured (Automated)
[PASS] 3.4.2.3 Ensure IPv6 outbound and established connections are configured (Manual)
10/10 checks passed
```

Cleanup

```bash
kubectl delete -f job-eks.yaml
kubectl delete -f deploy-nginx.yaml
eksctl delete cluster -f cluster.yaml --wait
aws ecr delete-repository  --repository-name ${BOOTSTRAP_ECR_REPO}  --force
aws ecr delete-repository  --repository-name ${VALIDATION_ECR_REPO}  --force

```


