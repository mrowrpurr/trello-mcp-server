# Use Node.js 20 (LTS) as base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files first for better Docker layer caching
COPY package*.json ./

# Install dependencies without running prepare script
RUN npm install --ignore-scripts

# Copy source code
COPY . .

# Build the TypeScript project
RUN npm run build

# Install mcp-proxy globally
RUN npm install -g mcp-proxy

# Expose port for mcp-proxy HTTP/SSE endpoints
EXPOSE 8080

# Start the MCP server via mcp-proxy
CMD ["npx", "mcp-proxy", "--port", "8080", "--shell", "node", "build/index.js"]