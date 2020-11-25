FROM node:12-buster-slim

#ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt-get update -y && apt-get upgrade -y \
	&& apt-get install -y sudo apt-utils build-essential libavahi-compat-libdnssd-dev libudev-dev libpam0g-dev procps \
	acl libcap2-bin \
	vim bash python \
	git \ 
 	tzdata curl
	
ADD bin/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# iobroker needs npm > 6.4.1
RUN npm install -g npm@6

# Install iobroker
RUN curl -sL https://iobroker.net/install.sh | bash - && echo $(hostname) > .install_host

# Deasaalate permission from root to user "iobroker", outherwise iobroker will be started by root -> this leadsto error during adaptor installation
USER iobroker

VOLUME /opt/iobroker/

EXPOSE 8081
EXPOSE 8082
ENTRYPOINT ["run.sh"]
CMD ["start"]
