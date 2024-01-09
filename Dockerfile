FROM node:18-alpine3.19 AS build

WORKDIR /app

COPY package* ./

RUN npm ci

COPY app app/
COPY components components/
COPY pages pages/
COPY public public/
COPY styles styles/

RUN npm run build

FROM node:18-alpine3.19 AS next

LABEL org.opencontainers.image.source https://github.com/alexispe/cesi-cicd

WORKDIR /app

COPY --from=build /app/package.json /app/
COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/.next /app/.next

EXPOSE 3000

CMD npm run start

