FROM debian:stretch

MAINTAINER mfrankl

# ------------
# Prepare Gmod
# ------------

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    lib32gcc1 \
    net-tools \
    lib32stdc++6 \
    lib32z1 \
    lib32z1-dev \
    curl 


RUN mkdir -p /home/daemon/steamcmd && \
    mkdir -p /gmod-base && \
    curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /home/daemon/steamcmd -zx && \
    chown -R daemon:daemon /home/daemon && \
    chown -R daemon:daemon /gmod-base

WORKDIR /home/daemon/steamcmd
USER daemon

ONBUILD ADD install.txt /home/daemon/steamcmd/install.txt
ONBUILD RUN ./steamcmd.sh +runscript install.txt

RUN chown -R daemon:daemon /gmod-base

RUN /home/daemon/steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod-base +app_update 4020 validate +quit


# ----------------------
# Setup Volume and Union
# ----------------------

#RUN mkdir /gmod-volume
#VOLUME /gmod-volume
#RUN mkdir /gmod-union
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install unionfs-fuse

# ---------------
# Setup Container
# ---------------

ADD start-server.sh /start-server.sh
EXPOSE 27015/udp
EXPOSE 27015/tcp
EXPOSE 27005/udp
EXPOSE 27005/tcp


ENV PORT="27015"
ENV MAXPLAYERS="16"
ENV G_HOSTNAME="Garry's Mod"
ENV GAMEMODE="sandbox"
ENV MAP="gm_construct"

CMD ["/bin/sh", "/start-server.sh"]