FROM node:20-alpine

# Cloud Run will inject PORT. Ensure server binds to 0.0.0.0 and respects PORT.
ENV NODE_ENV=production
ENV HOST=0.0.0.0
# Set default PORT to 8080 if not provided by Cloud Run
ENV PORT=8080

# Create app directory
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Install only production dependencies using lockfile for reproducible builds
COPY package*.json ./
RUN npm install --omit=dev --legacy-peer-deps

# Copy source
COPY --chown=node:node . .

# Run as non-root at runtime
USER node

# Cloud Run ignores EXPOSE, but 8080 is the conventional default there
EXPOSE 8080

# Start the y-websocket server (uses PORT and HOST envs)
CMD ["npm", "start"]
