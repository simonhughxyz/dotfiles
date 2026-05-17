# Base image
FROM ghcr.io/void-linux/void-glibc:latest

ARG HOST_UID
ARG HOST_GID
ARG HOST_USER

# Update package database and install essentials
RUN xbps-install -Sy --yes \
    sudo \
    dbus \
    xdg-utils \
    wayland \
    wayland-protocols \
    libxkbcommon \
    mesa-dri \
    vulkan-loader \
    foot \
    Waybar \
    pipewire \
    adwaita-icon-theme \
    ca-certificates \
    bash \
    shadow \
    && xbps-remove -O

RUN groupadd -g ${HOST_GID} ${HOST_USER}
RUN useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash ${HOST_USER}
RUN echo "${HOST_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${HOST_USER}
WORKDIR /home/${HOST_USER}

