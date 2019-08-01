ARG ALPINE_VERSION="latest"
#==================================================== BUILD STAGE ====================================================#
FROM alpine:${ALPINE_VERSION} AS build

ENV BUILD_UTILITIES="unzip wget"
ENV TERRAFORM_PLUGINS_PATH="/root/.terraform.d/plugins"

# Install the build utilities.
RUN apk add --no-cache ${BUILD_UTILITIES}

# Install the specified version of Terraform.
ARG TERRAFORM_VERSION="0.12.6"
ARG TERRAFORM_SHA256SUM="6544eb55b3e916affeea0a46fe785329c36de1ba1bdb51ca5239d3567101876f"
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
ARG TERRAFORM_PROVIDER_CLOUDDK_VERSION="0.2.1"
ARG TERRAFORM_PROVIDER_CLOUDDK_SHA256SUM="cfd8ee165b7d5e2d3bbd7d918c52fc1dd91903994b0037a40e56ce2cf4171ba6"
RUN \
    wget -nv -O "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" "https://github.com/danitso/terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}/releases/download/${TERRAFORM_PROVIDER_CLOUDDK_VERSION}/terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}-custom_linux_amd64.zip" && \
    echo "${TERRAFORM_PROVIDER_CLOUDDK_SHA256SUM}  terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" > "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}_SHA256SUMS" && \
    sha256sum "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" && \
    sha256sum -c "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}_SHA256SUMS" && \
    unzip  "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip" -d "${TERRAFORM_PLUGINS_PATH}" && \
    rm -f "terraform-provider-${TERRAFORM_PROVIDER_CLOUDDK_NAME}_v${TERRAFORM_PROVIDER_CLOUDDK_VERSION}.zip"
ENV TERRAFORM_PROVIDER_IRONIO_NAME="ironio"
ARG TERRAFORM_PROVIDER_IRONIO_VERSION="0.2.1"
ARG TERRAFORM_PROVIDER_IRONIO_SHA256SUM="2fea2b03d57cd8143255dfb95237ef6d5f9d94ce793affba54e45ff010623c0f"
RUN \
    wget -nv -O "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" "https://github.com/danitso/terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}/releases/download/${TERRAFORM_PROVIDER_IRONIO_VERSION}/terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}-custom_linux_amd64.zip" && \
    echo "${TERRAFORM_PROVIDER_IRONIO_SHA256SUM}  terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" > "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}_SHA256SUMS" && \
    sha256sum "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" && \
    sha256sum -c "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}_SHA256SUMS" && \
    unzip  "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip" -d "${TERRAFORM_PLUGINS_PATH}" && \
    rm -f "terraform-provider-${TERRAFORM_PROVIDER_IRONIO_NAME}_v${TERRAFORM_PROVIDER_IRONIO_VERSION}.zip"
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

# Copy the binaries from the build stage.
COPY --from=build "${TERRAFORM_BINARY_PATH}" "${TERRAFORM_BINARY_PATH}"
COPY --from=build "${TERRAFORM_PLUGINS_PATH}" "${TERRAFORM_PLUGINS_PATH}"

# Ensure that the binaries can be executed.
RUN chmod +x "${TERRAFORM_BINARY_PATH}" "${TERRAFORM_PLUGINS_PATH}"/*

# Create the workspace directory and remain inside it.
RUN mkdir -p /workspace
WORKDIR /workspace

# Set the entrypoint to Terraform as we will not be requiring shell access.
ENTRYPOINT [ "/usr/bin/terraform" ]
