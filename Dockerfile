FROM ubuntu:22.04

LABEL \
  org.opencontainers.image.vendor="Canonical Ubuntu Docker Image" \
  org.opencontainers.image.title="Terraformer for AWS in Docker Image" \
  org.opencontainers.image.version="1.0.0" \
  org.opencontainers.image.url="https://hub.docker.com/r/erivando/terraformer-aws" \
  org.opencontainers.image.source="https://github.com/erivandosena/terraformer-docker.git" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.author="erivandosena@gmail.com" \
  org.opencontainers.image.maintainer="Erivando Sena"

RUN apt update && \
 apt install -y unzip \
 wget \
 curl \
 git \
 nano \
 tree \
 jq

################################
# Install Terraformer
################################

# all,google,aws,kubernetes
ENV PROVIDER=aws
ENV PROVIDER_VERSION=5.21.0
ENV OS=linux

RUN curl --insecure -LO "https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64"
RUN chmod +x terraformer-${PROVIDER}-linux-amd64
RUN mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer

################################
# Install AWS provider
################################
RUN mkdir -p ~/.terraform.d/plugins/${OS}_amd64 && \
 curl -L https://releases.hashicorp.com/terraform-provider-aws/${PROVIDER_VERSION}/terraform-provider-aws_${PROVIDER_VERSION}_${OS}_amd64.zip -o terraform-provider-aws.zip && \
 unzip terraform-provider-aws.zip && \
 rm terraform-provider-aws.zip && \
 mv terraform-provider-aws_v${PROVIDER_VERSION}* ~/.terraform.d/plugins/${OS}_amd64/

################################
# Install Terraform
################################

RUN wget --no-check-certificate https://releases.hashicorp.com/terraform/1.6.1/terraform_1.6.1_linux_amd64.zip && \
 unzip terraform_1.6.1_linux_amd64.zip && \
 rm terraform_1.6.1_linux_amd64.zip && \
 mv terraform /usr/local/bin/

################################
# Install python
################################

RUN apt-get install -y python3-pip && \
 ln -s /usr/bin/python3 /usr/bin/python && \
 pip3 install --upgrade pip

################################
# Install AWS CLI
################################
RUN pip install awscli --upgrade --user
ENV PATH=~/.local/bin:$PATH
RUN mkdir ~/.aws && touch ~/.aws/credentials && \
 echo '[default]' > ~/.aws/credentials && \
 echo 'aws_access_key_id = <YOUR Access key ID>' >> ~/.aws/credentials && \
 echo 'aws_secret_access_key = <YOUR Secret access key>' >> ~/.aws/credentials

################################
# Add User default
################################

ARG USER=terraform

RUN useradd -m -p '' ${USER}

WORKDIR /home/${USER}