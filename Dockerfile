FROM lsiobase/kasmvnc:debianbookworm

# Install necessary dependencies, including libwebkit2gtk
RUN apt-get update && apt-get install -y \
    wget \
    gdebi-core \
    libwebkit2gtk-4.1-0 \
    python3-pyxdg \
    && rm -rf /var/lib/apt/lists/*

# Temporarily enable testing and unstable repositories to install a newer version of glibc
RUN echo "deb http://deb.debian.org/debian testing main" >> /etc/apt/sources.list.d/testing.list \
    && echo "deb http://deb.debian.org/debian unstable main" >> /etc/apt/sources.list.d/unstable.list \
    && echo 'Package: *\nPin: release a=testing\nPin-Priority: 90' > /etc/apt/preferences.d/testing \
    && echo 'Package: libc6\nPin: release a=unstable\nPin-Priority: 1001' >> /etc/apt/preferences.d/unstable

# Install newer version of glibc
RUN apt-get update && apt-get install -y libc6 \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/apt/sources.list.d/testing.list \
    && rm /etc/apt/sources.list.d/unstable.list \
    && rm /etc/apt/preferences.d/testing \
    && rm /etc/apt/preferences.d/unstable

# Download and install the LRCget .deb package
RUN wget https://github.com/tranxuanthang/lrcget/releases/download/1.0.0/lrcget_1.0.0_amd64.deb -O /tmp/lrcget.deb \
    && gdebi -n /tmp/lrcget.deb \
    && rm /tmp/lrcget.deb

# Create the autostart folder
COPY ./root /

# Expose the port for the VNC session
EXPOSE 3000
