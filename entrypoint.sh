#!/bin/sh
set -e

# Ensure uv-installed tools are on PATH
export PATH="/root/.local/bin:${PATH}"

PORT="${PORT:-8080}"
CONFIG_FILE="${MCP_CONFIG_FILE:-/default-servers.json}"
MCP_CORS="${MCP_CORS_ORIGIN:-*}"

# Fix volume permissions
if [ -d /data ]; then
  chmod -R 777 /data/memory 2>/dev/null || true
fi

echo "Starting MCP Proxy Gateway"
echo "  Port: ${PORT}"
echo "  Config: ${CONFIG_FILE}"
echo ""

# Build args
ARGS="--host 0.0.0.0 --port ${PORT} --named-server-config ${CONFIG_FILE} --pass-environment --allow-origin ${MCP_CORS}"

echo "Endpoints:"
echo "  Status:  http://0.0.0.0:${PORT}/status"

# Parse server names from config and print endpoints
if command -v python3 > /dev/null 2>&1; then
  GATEWAY_PORT="${PORT}" python3 -c "
import json, os
port = os.environ['GATEWAY_PORT']
with open('${CONFIG_FILE}') as f:
    cfg = json.load(f)
for name in cfg.get('mcpServers', {}):
    print(f'  {name}:  http://0.0.0.0:{port}/servers/{name}/sse')
"
fi

echo ""
echo "Starting proxy..."

exec catatonit -- mcp-proxy ${ARGS}
