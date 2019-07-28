ARG UBUNTU_VERSION="18.04"
FROM ubuntu:${UBUNTU_VERSION}
#==================================================== INFORMATION ====================================================#
LABEL Description="A Docker Image for Terraform which includes all the custom providers created by Danitso"
LABEL Maintainer="Danitso <info@danitso.com>"
LABEL Vendor="Danitso"
LABEL Version="0.1.0"
#==================================================== INFORMATION ====================================================#
ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG="C.UTF-8"
ENV TERRAFORM_PLUGINS_PATH="/root/.terraform.d/plugins"

# Start by upgrading the base image as we cannot rely on the official image being completely up to date.
RUN \
    apt-get -q update && \
    apt-get -q install

# Install some helper utilities.
RUN \
    apt-get -q update && \
    apt-get -q install -y \
        wget \
        unzip

# Install a supported version of Terraform.
ARG TERRAFORM_VERSION="0.11.14"
ARG TERRAFORM_SHA256SUM="9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd"
RUN \
    wget -nv -O "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    echo "${TERRAFORM_SHA256SUM} *terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > "terraform_${TERRAFORM_VERSION}_SHA256SUMS" && \
    sha256sum -c "terraform_${TERRAFORM_VERSION}_SHA256SUMS" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/bin && \
    rm -f "terraform_${TERRAFORM_VERSION}*" && \
    chmod +x /usr/bin/terraform

# Install the custom Terraform providers created by Danitso.
RUN mkdir -p \
    "${TERRAFORM_PLUGINS_PATH}"
ENV TERRAFORM_PROVIDER_CLOUDDK_NAME="clouddk"
ARG TERRAFORM_PROVIDER_CLOUDDK_VERSION="0.1.0"
ARG TERRAFORM_PROVIDER_CLOUDDK_SHA256SUM="56acff3ca5d735e53a3d6bd3577bb4e4e39cd8897a267ea6a869842b0c7de044"
RUN \
    wget -nv -O "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" "https://github.com/danitso/terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}/releases/download/${TERRAFORM_PROVIDER_CLOUDDK_VERSION}/terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}-custom_linux_amd64.zip" && \
    echo "${TERRAFORM_PROVIDER_CLOUDDK_SHA256SUM} *terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" > "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}_SHA256SUMS" && \
    sha256sum -c "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}_SHA256SUMS" && \
    unzip  "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" -d "${TERRAFORM_PLUGINS_PATH}" && \
    rm -f "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip"
ENV TERRAFORM_PROVIDER_IRONIO_NAME="ironio"
ARG TERRAFORM_PROVIDER_IRONIO_VERSION="0.2.0"
ARG TERRAFORM_PROVIDER_IRONIO_SHA256SUM="cce3aa00e0f22bb555269825b8bc02a225a7daad43f1697006c95775347079d2"
RUN \
    wget -nv -O "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" "https://github.com/danitso/terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}/releases/download/${TERRAFORM_PROVIDER_IRONIO_VERSION}/terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}-custom_linux_amd64.zip" && \
    echo "${TERRAFORM_PROVIDER_IRONIO_SHA256SUM} *terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" > "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}_SHA256SUMS" && \
    sha256sum -c "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}_SHA256SUMS" && \
    unzip  "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" -d "${TERRAFORM_PLUGINS_PATH}" && \
    rm -f "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip"
RUN \
    chmod +x "${TERRAFORM_PLUGINS_PATH}"/*

# Create the workspace directory and remain inside it.
RUN mkdir -p /workspace
WORKDIR /workspace

# Set the entrypoint to Terraform as we will not be requiring shell access.
ENTRYPOINT [ "/usr/bin/terraform" ]
