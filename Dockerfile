# syntax=docker/dockerfile:1

ARG al_tag
FROM amazonlinux:${al_tag:?}

ARG al_py
ENV AL_PY=${al_py:-python3.11}
RUN yum update && yum install -y \
      git-core \
      go \
      gzip \
      make \
      openssl \
      openssl-devel \
      ${AL_PY} \
      ${AL_PY}-devel \
      readline-devel \
      shadow-utils \
      sqlite-devel \
      sudo \
      tar \
      util-linux \
      vim \
      xz-devel \
      zlib-devel \
      zstd

RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_UNMANAGED_INSTALL="/usr/local/bin" sh

# create hadoop user as EMR
RUN id hadoop || { /usr/sbin/groupadd --gid 1001 hadoop && /usr/sbin/useradd --uid 1001 --gid 1001 --home-dir /home/hadoop hadoop; }
RUN echo 'hadoop ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/hadoop

USER hadoop
WORKDIR /home/hadoop
