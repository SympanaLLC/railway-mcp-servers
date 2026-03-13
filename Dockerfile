FROM ghcr.io/sparfenyuk/mcp-proxy:latest

USER root

# Install Node.js, npm, curl, and bash
RUN python3 -m ensurepip && \
    pip install --no-cache-dir uv && \
    apk add --no-cache nodejs npm curl bash

# Install Railway CLI
RUN curl -fsSL https://railway.com/install.sh | bash

# Pre-install Railway MCP server
RUN npm install -g @railwayapp/mcp-server

# Create data directory for persistence
RUN mkdir -p /data/memory && chmod 777 /data/memory

COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY servers.json /default-servers.json

ENTRYPOINT ["/entrypoint.sh"]
