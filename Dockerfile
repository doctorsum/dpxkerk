FROM kalilinux/kali-rolling

RUN apt-get update && \
    apt-get install -y systemd systemd-sysv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV container=docker

RUN systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount \
    && systemctl mask sys-kernel-config.mount \
    && systemctl mask sys-kernel-debug.mount \
    && systemctl mask sys-kernel-tracing.mount

STOPSIGNAL SIGRTMIN+3
WORKDIR /
RUN mkdir novn
WORKDIR /novn
RUN git clone https://github.com/novnc/noVNC.git /novn
RUN apt full-upgrade -y
RUN apt install kali-linux-default
RUN mkdir /root/.vnc \
    && echo "123hshHs284" | vncpasswd -f > /root/.vnc/passwd
RUN vncserver :0
RUN ./utils/novnc_proxy --vnc localhost:5900 --listen 0.0.0.0:7860
CMD ["/lib/systemd/systemd"]
