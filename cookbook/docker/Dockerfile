FROM centos:latest
MAINTAINER  uafgina

ENV HOME /root
RUN mkdir /build
ADD . /build

RUN /build/prepare.sh
RUN /usr/sbin/enable_insecure_key
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

RUN echo 'root:root' |chpasswd

EXPOSE 22
CMD /usr/sbin/sshd -D
