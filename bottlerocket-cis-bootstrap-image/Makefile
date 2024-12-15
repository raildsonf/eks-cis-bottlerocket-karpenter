#!/bin/bash -xs

IMAGE_REPO ?= ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
IMAGE_NAME ?= ${BOOTSTRAP_ECR_REPO}

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

image: build-image

build-image: 
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin $(IMAGE_REPO)/$(IMAGE_NAME)
	@echo "Building the docker image: $(IMAGE_NAME):$(IMAGE_TAG) using ${BOOTSTRAP_ECR_REPO}/Dockerfile..."
	@docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t  $(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) --push . 

	

############################################################
# clean section
############################################################
clean:
	@rm -rf output

.PHONY: all build image clean
