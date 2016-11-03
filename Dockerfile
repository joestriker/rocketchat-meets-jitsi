FROM debian:latest

MAINTAINER joe_striker@gmx.de

# gpg: key 4FD08014: public key "Rocket.Chat Buildmaster <buildmaster@rocket.chat>" imported
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0E163286C20D07B9787EBE9FD7F9D0414FD08104

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
    && for key in \
			9554F04D7259F04124DE6B476D5A82AC7E37093B \
			94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
			0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
			FD3A5288F042B6850C66B31F09FE44734EB7990E \
			71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
			DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
			B9AE9905FFD7803F25714661B63B535A4C206CA9 \
			C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
		; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
		done

ENV NODE_VERSION 4.6.1
ENV NODE_ENV production

RUN set -x \
	&& apt-get update && apt-get install -y curl ca-certificates imagemagick --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm cache clear \
	&& groupadd -r rocketchat \
	&& useradd -r -g rocketchat rocketchat
 
RUN apt-get update && \
	apt-get install -y wget dnsutils vim telnet && \
	echo 'deb http://download.jitsi.org/nightly/deb unstable/' >> /etc/apt/sources.list && \
	wget -qO - https://download.jitsi.org/nightly/deb/unstable/archive.key | apt-key add - && \
	apt-get update && \
	apt-get -y install jitsi-meet && \
	apt-get clean

EXPOSE 80 443 5347
EXPOSE 10000/udp 10001/udp 10002/udp 10003/udp 10004/udp 10005/udp 10006/udp 10007/udp 10008/udp 10009/udp 10010/udp

ADD start-jitsi.sh /usr/bin/start-jitsi.sh
RUN chmod +x /usr/bin/start-jitsi.sh
CMD ["/usr/bin/start-jitsi.sh"]
