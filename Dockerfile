FROM centos:latest

MAINTAINER DeployView Limited

LABEL Name="deployview/dev_box_1"

RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y install https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.3/powershell-preview-6.2.0_preview.3-1.rhel.7.x86_64.rpm && \
    yum clean all

CMD [ "/usr/bin/powershell" ]
