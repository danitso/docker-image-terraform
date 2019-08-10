# Docker Image for Terraform
A Docker Image for Terraform which includes all the custom providers created by Danitso.

## How To Use

```bash
docker run -v <hostpath>:/workspace -it --rm danitso/terraform init
```

_Remember to replace `<hostpath>` with an actual path on the host system._

## How To Build

```bash
docker build -t danitso/terraform .
```

_Please note that the image is available on Docker Hub. This means that you only need to build it, if you want to test uncommitted changes._

## Build Arguments

### ALPINE_VERSION

Specifies which version of Alpine to use as the base image.

### TERRAFORM_VERSION

Specifies which version of Terraform to include in the image.

### TERRAFORM_SHA256SUM

Specifies the SHA256 checksum for the specified version of Terraform (Linux binary).

### TERRAFORM_PROVIDER_CLOUDDK_VERSION

Specifies which version of the Cloud.dk provider to install.

### TERRAFORM_PROVIDER_CLOUDDK_SHA256SUM

Specifies the SHA256 checksum for the specified version of the Cloud.dk provider (Linux binary).

### TERRAFORM_PROVIDER_IRONIO_VERSION

Specifies which version of the Iron.io provider to install.

### TERRAFORM_PROVIDER_IRONIO_SHA256SUM

Specifies the SHA256 checksum for the specified version of the Iron.io provider (Linux binary).

### TERRAFORM_PROVIDER_SFTP_VERSION

Specifies which version of the SFTP provider to install.

### TERRAFORM_PROVIDER_SFTP_SHA256SUM

Specifies the SHA256 checksum for the specified version of the SFTP provider (Linux binary).

## Directories

### /workspace

This is the working directory for Terraform. The files must be mounted within this directory.
