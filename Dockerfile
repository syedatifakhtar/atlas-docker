FROM scratch
FROM ubuntu:20.04
LABEL maintainer="blah"
ARG VERSION=3.0.0-SNAPSHOT
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata
COPY apache-atlas-3.0.0-SNAPSHOT-server.tar.gz /tmp

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install apt-utils \
    && apt-get -y install \
        wget \
        git \
        python \
        openjdk-8-jdk-headless \
        patch \
	unzip

RUN export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    && tar -xzvf /tmp/apache-atlas-${VERSION}-server.tar.gz -C /opt \
    && mkdir -p /opt/apache-atlas-${VERSION}/logs \
    && apt-get -y --purge remove \
        git \
    && apt-get -y autoremove \
    && apt-get -y clean

VOLUME ["/opt/apache-atlas-${VERSION}/conf", "/opt/apache-atlas-${VERSION}/logs"]

COPY atlas_start.py /opt/apache-atlas-${VERSION}/bin/
COPY atlas_config.py /opt/apache-atlas-${VERSION}/bin/

COPY conf/hbase/hbase-site.xml.template /opt/apache-atlas-${VERSION}/conf/hbase/hbase-site.xml
COPY conf/atlas-env.sh /opt/apache-atlas-${VERSION}/conf/atlas-env.sh

COPY conf/gremlin /opt/gremlin/

RUN cd /opt/apache-atlas-${VERSION} \
    && ./bin/atlas_start.py -setup || true

RUN cd /opt/apache-atlas-${VERSION} \
    && ./bin/atlas_start.py & \
    touch /opt/apache-atlas-${VERSION}/logs/application.log \
    && tail -f /opt/apache-atlas-${VERSION}/logs/application.log | sed '/AtlasAuthenticationFilter.init(filterConfig=null)/ q' \
    && sleep 10 \
    && /opt/apache-atlas-${VERSION}/bin/atlas_stop.py
