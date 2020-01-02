ARG ALPINE_VERSION="latest"
#==================================================== BUILD STAGE ====================================================#
FROM alpine:${ALPINE_VERSION} AS build

ENV BUILD_UTILITIES="unzip wget"
ENV TERRAFORM_PLUGINS_PATH="/root/.terraform.d/plugins"

# Install the build utilities.
RUN apk add --no-cache ${BUILD_UTILITIES}

# Install the specified version of Terraform.
ARG TERRAFORM_VERSION="0.11.14"
ARG TERRAFORM_SHA256SUM="9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd"
RUN \
    wget -nv -O "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > "terraform_${TERRAFORM_VERSION}_SHA256SUMS" && \
    sha256sum "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    sha256sum -c "terraform_${TERRAFORM_VERSION}_SHA256SUMS" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/bin && \
    rm -f "terraform_${TERRAFORM_VERSION}*"

# Install the custom Terraform providers created by Danitso.
RUN mkdir -p \
    "${TERRAFORM_PLUGINS_PATH}"
ENV TERRAFORM_PROVIDER_CLOUDDK_NAME="clouddk"
ARG TERRAFORM_PROVIDER_CLOUDDK_VERSION="0.3.1"
ARG TERRAFORM_PROVIDER_CLOUDDK_SHA256SUM="52784db5a702d5ccbc09b86c7568bf542705e850b4d1ee214e126d03d4c18405"
RUN \
    wget -nv -O "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" "https://github.com/danitso/terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}/releases/download/${TERRAFORM_PROVIDER_CLOUDDK_VERSION}/terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}-custom_linux_amd64.zip" && \
    echo "${TERRAFORM_PROVIDER_CLOUDDK_SHA256SUM}  terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" > "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}_SHA256SUMS" && \
    sha256sum "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" && \
    sha256sum -c "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}_SHA256SUMS" && \
    unzip  "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" -d "${TERRAFORM_PLUGINS_PATH}" && \
    rm -f "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip"
ENV TERRAFORM_PROVIDER_IRONIO_NAME="ironio"
ARG TERRAFORM_PROVIDER_IRONIO_VERSION="0.2.2"
ARG TERRAFORM_PROVIDER_IRONIO_SHA256SUM="698322324a2ecb73ac5719f7f1d2f36a27414bb0d475fbce8b82930e12978d88"
RUN \
    wget -nv -O "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" "https://github.com/danitso/terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}/releases/download/${TERRAFORM_PROVIDER_IRONIO_VERSION}/terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}-custom_linux_amd64.zip" && \
    echo "${TERRAFORM_PROVIDER_IRONIO_SHA256SUM}  terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" > "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}_SHA256SUMS" && \
    sha256sum "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" && \
    sha256sum -c "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}_SHA256SUMS" && \
    unzip  "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" -d "${TERRAFORM_PLUGINS_PATH}" && \
    rm -f "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip"
ENV TERRAFORM_PROVIDER_PROXMOX_NAME="proxmox"
ARG TERRAFORM_PROVIDER_PROXMOX_VERSION="0.2.0"
ARG TERRAFORM_PROVIDER_PROXMOX_SHA256SUM="b6892f958bd0304dde395504681fedb3febcfdf521e19fee67ec95de9878d79a"
RUN \
    wget -nv -O "terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}_v${TERRAFORM_PROVIDER_PROXMOX_VERSION}.zip" "https://github.com/danitso/terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}/releases/download/${TERRAFORM_PROVIDER_PROXMOX_VERSION}/terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}_v${TERRAFORM_PROVIDER_PROXMOX_VERSION}-custom_linux_amd64.zip" && \
    echo "${TERRAFORM_PROVIDER_PROXMOX_SHA256SUM}  terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}_v${TERRAFORM_PROVIDER_PROXMOX_VERSION}.zip" > "terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}_v${TERRAFORM_PROVIDER_PROXMOX_VERSION}_SHA256SUMS" && \
    sha256sum "terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}_v${TERRAFORM_PROVIDER_PROXMOX_VERSION}.zip" && \
    sha256sum -c "terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}_v${TERRAFORM_PROVIDER_PROXMOX_VERSION}_SHA256SUMS" && \
    unzip  "terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}_v${TERRAFORM_PROVIDER_PROXMOX_VERSION}.zip" -d "${TERRAFORM_PLUGINS_PATH}" && \
    rm -f "terraform-provider-${TERRAFORM_PROVIDER_PROXMOX_NAME}_v${TERRAFORM_PROVIDER_PROXMOX_VERSION}.zip"
ENV TERRAFORM_PROVIDER_SFTP_NAME="sftp"
ARG TERRAFORM_PROVIDER_SFTP_VERSION="0.1.1"
ARG TERRAFORM_PROVIDER_SFTP_SHA256SUM="a0c7c2054396afc31a6ea6bea25dd7f4611fdc6dd2ba40a071eda20359428d1b"
RUN \
    wget -nv -O "terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}_v${TERRAFORM_PROVIDER_SFTP_VERSION}.zip" "https://github.com/danitso/terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}/releases/download/${TERRAFORM_PROVIDER_SFTP_VERSION}/terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}_v${TERRAFORM_PROVIDER_SFTP_VERSION}-custom_linux_amd64.zip" && \
    echo "${TERRAFORM_PROVIDER_SFTP_SHA256SUM}  terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}_v${TERRAFORM_PROVIDER_SFTP_VERSION}.zip" > "terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}_v${TERRAFORM_PROVIDER_SFTP_VERSION}_SHA256SUMS" && \
    sha256sum "terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}_v${TERRAFORM_PROVIDER_SFTP_VERSION}.zip" && \
    sha256sum -c "terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}_v${TERRAFORM_PROVIDER_SFTP_VERSION}_SHA256SUMS" && \
    unzip  "terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}_v${TERRAFORM_PROVIDER_SFTP_VERSION}.zip" -d "${TERRAFORM_PLUGINS_PATH}" && \
    rm -f "terraform-provider-${TERRAFORM_PROVIDER_SFTP_NAME}_v${TERRAFORM_PROVIDER_SFTP_VERSION}.zip"
#==================================================== FINAL STAGE ====================================================#
FROM alpine:${ALPINE_VERSION}
#==================================================== INFORMATION ====================================================#
LABEL Description="A Docker Image for Terraform which includes all the custom providers created by Danitso"
LABEL Maintainer="Danitso <info@danitso.com>"
LABEL Vendor="Danitso"
#==================================================== INFORMATION ====================================================#
ENV LANG="C.UTF-8"
ENV TERRAFORM_BINARY_PATH="/usr/bin/terraform"
ENV TERRAFORM_PLUGINS_PATH="/root/.terraform.d/plugins"
ENV TERRAFORM_UTILITIES="git"

# Copy the binaries from the build stage.
COPY --from=build "${TERRAFORM_BINARY_PATH}" "${TERRAFORM_BINARY_PATH}"
COPY --from=build "${TERRAFORM_PLUGINS_PATH}" "${TERRAFORM_PLUGINS_PATH}"

# Ensure that the binaries can be executed.
RUN chmod +x "${TERRAFORM_BINARY_PATH}" "${TERRAFORM_PLUGINS_PATH}"/*

# Install utilities supported by Terraform.
RUN apk add --no-cache ${TERRAFORM_UTILITIES}

# Create the workspace directory and remain inside it.
RUN mkdir -p /workspace
WORKDIR /workspace

# Set the entrypoint to Terraform as we will not be requiring shell access.
ENTRYPOINT [ "/usr/bin/terraform" ]
