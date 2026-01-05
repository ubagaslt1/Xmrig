FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    build-base \
    cmake \
    libuv-dev \
    openssl-dev \
    hwloc-dev \
    git \
    nodejs \
    npm \
    nginx \
    supervisor

# Clone and build XMRig
RUN git clone https://github.com/xmrig/xmrig.git /tmp/xmrig && \
    mkdir /tmp/xmrig/build && \
    cd /tmp/xmrig/build && \
    cmake -DWITH_HWLOC=OFF .. && \
    make -j$(nproc) && \
    mv xmrig /usr/local/bin/ && \
    rm -rf /tmp/xmrig

# Create web interface
WORKDIR /app
COPY app/package*.json ./
RUN npm install

# Copy web files
COPY app/ ./

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create startup script
COPY start-xmrig.sh /usr/local/bin/start-xmrig.sh
RUN chmod +x /usr/local/bin/start-xmrig.sh

# Expose port
EXPOSE 3000

# Start services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
