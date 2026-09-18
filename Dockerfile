# Use a small, official base image
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy dependency manifest first (Docker layer caching best practice)
COPY package.json ./

# Install dependencies (none needed here, but shows the standard flow)
RUN npm install --omit=dev

# Copy application source
COPY server.js ./
COPY public ./public

# Run as non-root user for security (best practice)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER app

# Document the port the container listens on
EXPOSE 3000

# Container health check - Docker will mark the container unhealthy if this fails
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Start the server
CMD ["node", "server.js"]
