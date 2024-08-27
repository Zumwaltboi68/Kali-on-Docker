# Use the official Kali Linux Docker image
FROM kalilinux/kali-rolling

# Install necessary packages
RUN apt-get update && apt-get install -y \
    python3-pip \
    neofetch \
    git \
    npm \
    qemu-system \
    wget \
    openjdk-11-jdk \
    inotify-tools \
    rustup \
    make \
    gcc \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    && apt-get clean

# Install the latest Node.js and npm
RUN npm install -g n \
    && n stable \
    && apt-get purge -y nodejs npm

# Set up rust
RUN rustup-init -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Configure VNC and noVNC
RUN mkdir -p ~/.vnc \
    && echo "xfce4-session" > ~/.vnc/xstartup \
    && chmod +x ~/.vnc/xstartup \
    && echo "password" | vncpasswd -f > ~/.vnc/passwd \
    && chmod 600 ~/.vnc/passwd

# Expose the necessary port for Render
EXPOSE 10000

# Start the VNC server and noVNC, configured for Render
CMD tightvncserver :1 && \
    /usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 0.0.0.0:10000