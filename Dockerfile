# Build stage
FROM node:22-slim AS builder

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy all source code first to include submodule package.json files
COPY . .

# Install dependencies
RUN pnpm install --frozen-lockfile

# Build the application
RUN pnpm run build

# Production stage
FROM node:22-slim

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy only necessary files from builder stage
COPY --from=builder /app/dist/slack-gateway ./dist/slack-gateway
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/pnpm-lock.yaml ./pnpm-lock.yaml

# Install production dependencies only
RUN pnpm install --prod --frozen-lockfile

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "dist/slack-gateway/index.js"] 