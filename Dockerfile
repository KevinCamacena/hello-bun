FROM oven/bun:1-alpine AS base

WORKDIR /app

FROM base AS install

RUN  mkdir -p /temp/dev

# Install dependencies into temp directory
# this will cache them and speed up future builds
COPY package*.json bun.lockb /temp/dev/

RUN cd /temp/dev && bun install --frozen-lockfile

# Install with --production (exclude devDependencies)
RUN mkdir -p /temp/prod

COPY package.json bun.lockb /temp/prod/

RUN cd /temp/prod && bun install --frozen-lockfile --production

# Copy node_modules from temp directory
# then copy all (non-ignored) project files into the image
FROM base AS prerelease
COPY --from=install /temp/dev/node_modules node_modules
COPY . .

# [optional] tests & build
ENV NODE_ENV=production

# RUN bun test

# RUN bun run build

# copy production dependencies and source code into final image
FROM base AS release
COPY --from=install /temp/prod/node_modules node_modules
COPY --from=prerelease /app/index.ts .
COPY --from=prerelease /app/package.json .

EXPOSE 3000

CMD ["bun", "run", "start"]
