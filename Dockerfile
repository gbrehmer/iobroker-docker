FROM node:20.18.0-bookworm-slim

#ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt-get update -y && apt-get upgrade -y \
	&& apt-get install -y sudo apt-utils build-essential iputils-ping libavahi-compat-libdnssd-dev libudev-dev libpam0g-dev procps \
	acl libcap2-bin \
	vim bash python3 \
	git \ 
 	tzdata curl udev bluez
	
ADD bin/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

RUN groupmod -g 1001 node && usermod -u 1001 -g 1001 node
RUN usermod -d /opt/iobroker -l iobroker node
RUN groupmod -n iobroker node

# iobroker needs npm >= 9
RUN npm install -g npm@9

# Install iobroker
RUN curl -sL https://iobroker.net/install.sh | bash - && echo $(hostname) > .install_host

# Deasaalate permission from root to user "iobroker", outherwise iobroker will be started by root -> this leadsto error during adaptor installation
USER iobroker

VOLUME /opt/iobroker/
WORKDIR /opt/iobroker

EXPOSE 8081
EXPOSE 8082
ENTRYPOINT ["run.sh"]
CMD ["start"]
