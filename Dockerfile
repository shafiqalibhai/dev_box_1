FROM centos:latest

MAINTAINER DeployView Limited

LABEL Name="deployview/dev_box_1"

RUN yum -y update

RUN yum -y install https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.3/powershell-preview-6.2.0_preview.3-1.rhel.7.x86_64.rpm

RUN yum -y install https://github.com/PowerShell/PowerShell/releases/download/v6.1.1/powershell-6.1.1-1.rhel.7.x86_64.rpm

RUN pwsh -Command Install-Module -Name Az -force

RUN yum -y install ansible 

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

RUN sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

RUN yum -y install azure-cli

RUN yum -y install awscli

RUN yum -y install git

RUN yum -y install wget

RUN wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip

RUN yum -y install unzip

RUN unzip terraform_0.11.11_linux_amd64.zip

RUN mv terraform /usr/bin/terraform

RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
    && yum -y update \
    && yum -y install python36u python36u-libs python36u-devel python36u-pip 

RUN rm -rf terraform*

RUN pip3.6 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3.6 install -U

RUN pip3.6 install click

RUN mkdir -p /go && chmod -R 777 /go && \
    yum -y install golang
    
RUN yum -y install ruby

ENV GOPATH /go

ENV LC_ALL en_US.utf-8
ENV LANG en_US.utf-8

RUN yum clean all

CMD [ "bash" ]
