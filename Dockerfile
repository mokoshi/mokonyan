# Build stage
FROM node:22-slim AS builder

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:22-slim

WORKDIR /app

# Copy only necessary files from builder stage
COPY --from=builder /app/dist/slack-gateway ./dist/slack-gateway
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/package-lock.json ./package-lock.json

RUN npm install
RUN npx playwright install --with-deps --only-shell chromium

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "dist/slack-gateway/index.mjs"] 