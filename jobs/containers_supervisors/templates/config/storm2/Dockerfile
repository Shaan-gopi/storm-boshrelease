FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y software-properties-common
# BEGIN INSTALLING ORACLE-JAVA8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
# END OF INSTALLING ORACLE-JAVA8

# BEGIN INSTALLING STORM PACKAGES 
ENV STORM_USER=storm \
    STORM_CONF_DIR=/conf \
    STORM_DATA_DIR=/data \
    STORM_LOG_DIR=/logs \
    KEY_MNGR_DIR=/home/apcuser/apps/
RUN set -ex; \
    adduser "$STORM_USER"; \
    mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR" "KEY_MNGR_DIR"; \
    chown -R "$STORM_USER:$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"``
ARG DISTRO_NAME=apache-storm-1.1.2
#ADD apache-storm-1.1.1.tar.gz /
ENV STORM_HOME /apache-storm-1.1.2
ARG GPG_KEY=ACEFE18DD2322E1E84587A148DE03962E80B8FFD
RUN set -ex; \
    wget -q "http://www.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz"; \
    wget -q "http://www.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY"; \
    gpg --batch --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz"; \
    tar -xzf "$DISTRO_NAME.tar.gz"; \
    chown -R "$STORM_USER:$STORM_USER" "$DISTRO_NAME"; \
    rm -rf "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc";
# END OF INSTALLING STORM

# BEGIN INSTALLING CUSTOM PACKAGES
RUN apt-get update
RUN apt-get install -y g++
RUN apt-get install -y python
RUN apt-get install -y openssl
RUN apt-get install libboost-regex1.58.0
RUN apt-get install -y libgoogle-glog0v5
RUN apt-get install -y libtbb2
RUN apt-get install -y librados2
RUN apt-get install -y librados-dev
RUN apt-get install -y libxtst6
RUN apt-get install -y make
RUN apt-get install curl
RUN ln -s /usr/lib/x86_64-linux-gnu/librados.a /usr/lib/librados.a
RUN ln -s /usr/lib/x86_64-linux-gnu/librados.so.2 /usr/lib/librados.so.2
RUN ln -s /usr/lib/x86_64-linux-gnu/librados.so.2.0.0 /usr/lib/librados.so.2.0.0
RUN ln -s /usr/lib/x86_64-linux-gnu/librados.so /usr/lib/librados.so
# END OF CUSTOM PACKAGES 

ENV LD_LIBRARY_PATH /usr/bin:/usr/local/bin:/usr/lib
ENV STORM_APC_LIB /apache-storm-1.1.2/apclibs
ENV PATH $PATH:/$DISTRO_NAME/bin

ADD config $KEY_MNGR_DIR/config
ADD ceph /etc/ceph

RUN mkdir /apache-storm-1.1.2/apclibs
RUN mkdir /apache-storm-1.1.2/scripts
RUN chown -R "$STORM_USER:$STORM_USER" "$DISTRO_NAME"
RUN curl -L https://github.com/ncopa/su-exec/archive/dddd1567b7c76365e1e0aac561287975020a8fad.tar.gz | tar xvz && \
cd su-exec-* && make && mv su-exec /usr/local/bin && cd .. && rm -rf su-exec-*

#COPY java.security /usr/lib/jvm/java-8-oracle/jre/lib/security/
COPY apache-storm-1.1.1/apclibs/*.jar /apache-storm-1.1.2/apclibs/
COPY apache-storm-1.1.1/lib/*.jar /apache-storm-1.1.2/lib/
COPY storm.yaml /apache-storm-1.1.2/conf/
COPY zookeeper.cfg /apache-storm-1.1.2/conf/
COPY product-build.info /apache-storm-1.1.2/conf/
COPY alceph-1.0.0_*.deb /conf/
COPY cacerts /usr/lib/jvm/java-8-oracle/jre/lib/security/
COPY apache-storm-1.1.1/scripts/*.sh /apache-storm-1.1.2/scripts/
COPY docker-entrypoint.sh /

RUN dpkg -i /conf/alceph-1.0.0_*.deb
RUN rm /apache-storm-1.1.2/lib/logback-classic-1.1.7.jar

WORKDIR $DISTRO_NAME
ENTRYPOINT ["/docker-entrypoint.sh"]
