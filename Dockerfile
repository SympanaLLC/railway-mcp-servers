FROM ghcr.io/sparfenyuk/mcp-proxy:latest

USER root

# Install Node.js (for official MCP servers) and uv (for Python-based MCP servers)
RUN python3 -m ensurepip && \
    pip install --no-cache-dir uv && \
    apk add --no-cache nodejs npm

# Pre-install official MCP servers
# fetch is Python-only; memory and sequential-thinking are on npm
RUN uv tool install mcp-server-fetch && \
    npm install -g \
    @modelcontextprotocol/server-memory \
    @modelcontextprotocol/server-sequential-thinking

# Create data directory for memory server persistence
RUN mkdir -p /data/memory && chmod 777 /data/memory

COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY servers.json /default-servers.json

ENTRYPOINT ["/entrypoint.sh"]
