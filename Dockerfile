FROM s6on/debian

ENV DEBIAN_FRONTEND noninteractive

# update install
RUN apt-get update -y && apt-get upgrade -y && \
\
# install dependancies
    apt-get -y install apt-transport-https ca-certificates gnupg-agent curl

# add plex gpg key
RUN mkdir /root/.gnupg/ && chmod 600 /root/.gnupg && \
   gpg --no-default-keyring --keyring /usr/share/keyrings/resilio-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BE66CC4C3F171DE2 && \
\
# add plex repo
   echo "deb [signed-by=/usr/share/keyrings/resilio-archive-keyring.gpg] http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | tee /etc/apt/sources.list.d/resilio-sync.list && \
\
# install pms
    apt-get update && \
    echo "y" | apt-get install -y resilio-sync

# Setup directories
RUN mkdir -p \
      /config \
      /resilio \
      /data

# Cleanup
RUN apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

# add local files
COPY root/ /

EXPOSE 8888 55555
VOLUME /config /sync

ENV CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config"

ENTRYPOINT ["/init"]
HEALTHCHECK --interval=5s --timeout=2s --retries=20 CMD /healthcheck.sh || exit 1

