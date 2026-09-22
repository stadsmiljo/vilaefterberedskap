FROM oven/bun:latest AS build

WORKDIR /app
COPY package*.json ./
RUN bun install
COPY public public
COPY src src
COPY components.json eslint.config.js index.html playwright-fixture.ts playwright.config.ts \
    postcss.config.js tailwind.config.ts tsconfig.app.json tsconfig.json tsconfig.node.json vite.config.ts \
    vitest.config.ts ./
RUN bun run build
COPY .deploy/favicon.ico /app/dist/favicon.ico

# FROM nginx:stable-alpine
# WORKDIR /usr/share/nginx/html
# COPY --from=build /app/dist .

FROM busybox
RUN mkdir -p /opt/html
WORKDIR /opt/html
COPY --from=build /app/dist .
USER 1001

EXPOSE 8080
CMD ["busybox", "httpd", "-f", "-v", "-p", "8080"]