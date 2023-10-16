# Project Terraformer Docker

### Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)

### About <a name = "about"></a>
O Terraformer é uma ferramenta de código aberto que permite a extração de recursos de infraestrutura existentes de provedores de nuvem para configurações Terraform. 

### Getting Started <a name = "getting_started"></a>
As instruções fornecerão uma cópia do projeto em funcionamento em sua máquina local para fins de desenvolvimento e teste.

### Prerequisites
Linux ou WSL/2  
Docker  
Git  
AWS
Internet

### Installing
```
git clone https://github.com/erivandosena/terraformer-docker.git
docker build -t terraformer-aws:latest .
```

### Usage <a name = "usage"></a>
``` bash
docker run -it --rm --name terraformer -v .:/home/terraform -w /home/terraform erivando/terraformer-aws:latest bash

terraformer import aws --resources=iam,s3 --regions=us-east-1

tree generated
```

##### Result
```
generated
`-- aws
    |-- iam
    |   |-- provider.tf
    |   `-- terraform.tfstate
    `-- s3
        |-- us-east-1
            |-- provider.tf
            `-- terraform.tfstate
```