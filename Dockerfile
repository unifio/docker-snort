FROM centos:7
MAINTAINER Unif.io, Inc. <support@unif.io>

LABEL DAQ_VERSION="2.0.6"
LABEL SNORT_VERSION="2.9.9.0"
LABEL PULLEDPORK_VERSION="0.7.2"

ENV DAQ_VERSION=2.0.6
ENV SNORT_VERSION=2.9.9.0
ENV PULLEDPORK_VERSION=0.7.2
RUN yum -y install epel-release curl tar perl-LWP-Protocol-https perl-Crypt-SSLeay perl-Sys-Syslog perl-Archive-Tar perl-Mozilla-CA && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    curl -L -s --output snort_md5s.txt https://www.snort.org/downloads/snort/md5s && \
    curl -L -s --output daq-${DAQ_VERSION}-1.centos7.x86_64.rpm https://www.snort.org/downloads/archive/snort/daq-${DAQ_VERSION}-1.centos7.x86_64.rpm && \
    curl -L -s --output snort-openappid-${SNORT_VERSION}-1.centos7.x86_64.rpm https://www.snort.org/downloads/archive/snort/snort-openappid-${SNORT_VERSION}-1.centos7.x86_64.rpm && \
    grep daq-${DAQ_VERSION}-1.centos7.x86_64.rpm snort_md5s.txt | md5sum -c && \
    grep snort-openappid-${SNORT_VERSION}-1.centos7.x86_64.rpm snort_md5s.txt | md5sum -c && \
    yum -y install daq-${DAQ_VERSION}-1.centos7.x86_64.rpm snort-openappid-${SNORT_VERSION}-1.centos7.x86_64.rpm && \
    curl -L -s --output pulledpork-${PULLEDPORK_VERSION}.tar.gz https://github.com/shirkdog/pulledpork/archive/v${PULLEDPORK_VERSION}.tar.gz && \
    tar xzvf pulledpork-${PULLEDPORK_VERSION}.tar.gz -C /usr/local/src && \
    chmod +x /usr/local/src/pulledpork-${PULLEDPORK_VERSION}/pulledpork.pl && \
    ln -s /usr/local/src/pulledpork-${PULLEDPORK_VERSION}/pulledpork.pl \
      /usr/local/bin/pulledpork && \
    ln -s /usr/lib64/snort-${SNORT_VERSION}_dynamicengine \
       /usr/local/lib/snort_dynamicengine && \
    ln -s /usr/lib64/snort-${SNORT_VERSION}_dynamicpreprocessor \
       /usr/local/lib/snort_dynamicpreprocessor && \
    yum clean all && \
    rm -rf /var/log/* || true && \
    rm -rf /tmp/build && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
