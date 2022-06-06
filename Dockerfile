FROM node:lts AS dependencies

WORKDIR /test-app

COPY package.json package-lock.json ./

RUN npm ci



FROM node:lts AS builder

WORKDIR /test-app

COPY . .

COPY --from=dependencies /test-app/node_modules ./node_modules

RUN npm run build



FROM node:lts AS runner

WORKDIR /test-app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# If you are using a custom next.config.js file, uncomment this line.

# COPY --from=builder /test-app/next.config.js ./

COPY --from=builder /test-app/public ./public

COPY --from=builder /test-app/.next ./.next

COPY --from=builder /test-app/node_modules ./node_modules

COPY --from=builder /test-app/package.json ./package.json

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["npm", "run", "start"]