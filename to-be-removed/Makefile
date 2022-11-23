#!/bin/bash -xs

IMAGE_REPO ?= ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
IMAGE_NAME ?= ${ECR_REPO}
#IMAGE_NAME=$1


IMAGE_TAG ?= latest


PWD := $(shell pwd)
BASE_DIR := $(shell basename $(PWD))


LOCAL_OS := $(shell uname)
ifeq ($(LOCAL_OS),Linux)
    TARGET_OS ?= linux
    XARGS_FLAGS="-r"
else ifeq ($(LOCAL_OS),Darwin)
    TARGET_OS ?= darwin
    XARGS_FLAGS=
else
    $(error "This system's OS $(LOCAL_OS) isn't recognized/supported")
endif

all: image

############################################################
# image section
############################################################

image: build-image push-image

build-image: 
	@echo "Building the docker image: $(IMAGE_NAME):$(IMAGE_TAG) using ${ECR_REPO}/Dockerfile..."
	@docker build --no-cache  -t  $(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) -f ${ECR_REPO}/Dockerfile
	#@docker build --no-cache -f ./${ECR_REPO}/Dockerfile -t  $(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) 

push-image: build-image
	@echo "Pushing the docker image for $(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) ..."	
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin $(IMAGE_REPO)/$(IMAGE_NAME)
	@docker push $(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
	

############################################################
# clean section
############################################################
clean:
	@rm -rf output

.PHONY: all build image clean
