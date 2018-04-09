FROM ubuntu:16.04
MAINTAINER Jordi Prats

ENV HOME /root

RUN yum install epel-release -y
RUN yum install git -y
RUN yum install curl -y

RUN mkdir -p /var/eyprepos /usr/bin

COPY report.sh /usr/bin/report.sh

RUN chmod +x /usr/bin/report.sh
