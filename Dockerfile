FROM ghcr.io/sparfenyuk/mcp-proxy:latest

USER root

# Install Node.js, npm, curl, and bash
RUN python3 -m ensurepip && \
    pip install --no-cache-dir uv && \
    apk add --no-cache nodejs npm curl bash git

# Install Railway CLI via npm and Railway MCP server
RUN npm install -g @railway/cli @railwayapp/mcp-server

# Create data directory for persistence
RUN mkdir -p /data/memory && chmod 777 /data/memory

COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY servers.json /default-servers.json

ENTRYPOINT ["/entrypoint.sh"]
