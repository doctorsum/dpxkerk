FROM kalilinux/kali-rolling

RUN apt-get update && \
    apt-get install -y systemd systemd-sysv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV container docker

RUN systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount \
    && systemctl mask sys-kernel-config.mount \
    && systemctl mask sys-kernel-debug.mount \
    && systemctl mask sys-kernel-tracing.mount

STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
