FROM centos:7
# MAINTAINER Kitware, Inc. <kitware@kitware.com>

EXPOSE 9000

RUN mkdir /girder
RUN mkdir /girder/logs

RUN yum update -y && yum install -y \
    epel-release \
    gcc \
    libpython2.7-dev \
    git \
    libldap2-dev \
    wget \
    python-devel \
    openldap-devel \
    openssl-devel \
    libjpeg-turbo-devel \
    zlib-devel \ 
    libsasl2-dev && \
    yum clean all


RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py

# npm installation
RUN yum install -y gcc-c++ make curl && \
    curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
    yum install -y nodejs

# clone the repo
# RUN mkdir /girder
# WORKDIR /girder
# RUN echo "haha"
# RUN ls -l
# RUN ls mnt
RUN cd /girder && \
    git clone --branch 2.x-maintenance https://github.com/girder/girder.git && \
    cd girder

# installation
# WORKDIR /girder/girder
RUN pip install --upgrade --upgrade-strategy eager --editable .[plugins] && \
    girder-install web --all-plugins

ENTRYPOINT ["girder", "serve"]
