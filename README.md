# Docker Image for Terraform
A Docker Image for Terraform which includes all the custom providers created by Danitso.

## Build Arguments

### UBUNTU_VERSION

Specifies which version of Ubuntu to use as the base image.

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

## Directories

### /workspace

This is the working directory for Terraform. The files must be mounted within this directory.

## How To Build

You can build the image like this:

```bash
docker build -t danitso/terraform .
```

Please note that the image is available on Docker Hub. This means that you only need to build it, if you need to test uncommitted changes. Skip ahead to [How To Use](#how-to-use), if this is not the case.

## How To Use

You can use the image like this:

```bash
docker run -v <hostpath>:/workspace -it --rm danitso/terraform init
```

Remember to replace `<hostpath>` with an actual path on the host system.
