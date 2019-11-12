FROM centos:7

MAINTAINER DeployView Limited

LABEL Name="deployview/dev_box_1"

ARG RUBY_PATH

RUN yum -y install epel-release 
RUN yum -y update

COPY cert.pem /etc/pki/ca-trust/source/anchors

RUN update-ca-trust force-enable

RUN update-ca-trust extract

RUN yum -y install \
#        make \
#        gcc \
        git
#        openssl-devel \
#        libxml2-devel

#RUN yum groupinstall 'Development Tools' -y

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install --system

#RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
#    && yum -y install python36u python36u-libs python36u-devel python36u-pip

RUN yum -y install https://github.com/PowerShell/PowerShell/releases/download/v6.2.3/powershell-6.2.3-1.rhel.7.x86_64.rpm

RUN pwsh -Command Install-Module -Name Az -force

RUN yum -y install ansible 

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

RUN sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

RUN yum -y install azure-cli

RUN az extension add --name azure-devops

RUN yum -y install awscli

RUN yum -y install wget

RUN wget https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip

RUN yum -y install unzip

RUN unzip terraform_0.12.13_linux_amd64.zip

RUN rm -rf terraform_0.12.13_linux_amd64.zip

RUN mv terraform* /usr/bin/terraform 

#RUN pip3.6 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3.6 install -U

#RUN pip3.6 install click

#RUN pip3.6 install azure-devops

#RUN pip3.6 install jinja2

#RUN /usr/lib64/az/bin/python -m pip install keyring~=17.1.1

RUN mkdir -p /go && chmod -R 777 /go && \
    yum -y install golang

RUN yum -y install mlocate

RUN yum -y install nodejs

RUN yum -y install zsh

ENV GOPATH /go

ENV LC_ALL en_US.utf-8
ENV LANG en_US.utf-8

RUN yum clean all

WORKDIR /

CMD [ "zsh" ]
