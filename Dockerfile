# oracledb 6 defaults to Thin mode, which talks to Oracle over pure JavaScript.
# No Instant Client is installed here, so the slim base is enough. Thick mode
# would need the client libraries and a matching glibc base image.
FROM node:22-slim AS deps

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

FROM node:22-slim AS runtime

ENV NODE_ENV=production

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# .env is git-ignored and must not be baked into the image; configuration comes
# from the environment at run time.
RUN rm -f .env .env.backup

# Run unprivileged. The node image already ships this user.
USER node

EXPOSE 3000

# The app validates configuration at startup and exits non-zero on a missing or
# unsafe secret, so a misconfigured container fails immediately and visibly
# rather than serving traffic it cannot secure.
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:'+(process.env.PORT||3000)+'/health',r=>process.exit(r.statusCode===200?0:1)).on('error',()=>process.exit(1))"

CMD ["node", "server.js"]
