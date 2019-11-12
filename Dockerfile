FROM centos:7

MAINTAINER DeployView Limited

LABEL Name="deployview/dev_box_1"

RUN yum -y install epel-release 
RUN yum -y update

COPY cert.pem /etc/pki/ca-trust/source/anchors

RUN update-ca-trust force-enable

RUN update-ca-trust extract

RUN yum -y install \
        make \
        gcc \
        git \
        openssl-devel \
        libxml2-devel \
        curl \
        wget \
        nano \
        unzip \
        ansible \
        zsh \
        nodejs \
        mlocate \
        awscli \
        ruby \
        golang \
        npm \
        python3 \
        python3-pip \
        python3-devel


#RUN yum groupinstall 'Development Tools' -y

RUN yum -y install which && gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && curl -sSL https://get.rvm.io | bash -s stable --ruby

RUN gem install bundler

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && yum install -y powershell

RUN pwsh -Command Install-Module -Name Az -force

RUN az extension add --name azure-devops

RUN wget https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip --no-check-certificate && yum install -y unzip && unzip terraform_0.12.13_linux_amd64.zip && mv terraform /usr/local/bin/ && rm terraform_0.12.13_linux_amd64.zip

RUN pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U

RUN pip3 install click

RUN pip3 install jinja2

RUN pip3 install keyring

RUN curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-linux-amd64 && chmod +x terraformer-linux-amd64 && mv terraformer-linux-amd64 /usr/local/bin/terraformer

RUN wget https://releases.hashicorp.com/packer/1.4.5/packer_1.4.5_linux_amd64.zip && unzip packer_1.4.5_linux_amd64.zip && mv packer /usr/local/bin/ && rm packer_1.4.5_linux_amd64.zip

RUN curl -L https://aka.ms/InstallAzureCli | bash

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install --system

ENV LC_ALL en_US.utf-8
ENV LANG en_US.utf-8

RUN useradd coder && \
	echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER coder
# We create first instead of just using WORKDIR as when WORKDIR creates, the 
# user is root.
RUN mkdir -p /home/coder/projects

ENV GOPATH /home/coder/projects/go
ENV GO111MODULE=on
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR /home/coder/projects

RUN sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN wget https://github.com/cdr/code-server/releases/download/2.1688-vsc1.39.2/code-server2.1688-vsc1.39.2-linux-x86_64.tar.gz && tar -xzf code-server2.1688-vsc1.39.2-linux-x86_64.tar.gz && sudo mv code-server2.1688-vsc1.39.2-linux-x86_64/code-server /usr/local/bin/ && rm code-server2.1688-vsc1.39.2-linux-x86_64.tar.gz

RUN yum clean all

# This ensures we have a volume mounted even if the user forgot to do bind
# mount. So that they do not lose their data if they delete the container.
VOLUME [ "/home/coder/projects" ]

EXPOSE 8080

CMD [ "zsh" ]
