FROM node:14.17.5 AS builder

WORKDIR /home/node
COPY --chown=node:node . .

ARG BUILD_EXPIRE
ARG BUILD_DOMAIN
ARG REACT_APP_SENTRY_KEY=${REACT_APP_SENTRY_KEY:-""}
ARG REACT_APP_SENTRY_ORGANIZATION=${REACT_APP_SENTRY_ORGANIZATION:-""}
ARG REACT_APP_SENTRY_PROJECT=${REACT_APP_SENTRY_PROJECT:-""}

USER node

ENV REACT_APP_SENTRY_KEY=${REACT_APP_SENTRY_KEY}
ENV REACT_APP_SENTRY_ORGANIZATION=${REACT_APP_SENTRY_ORGANIZATION}
ENV REACT_APP_SENTRY_PROJECT=${REACT_APP_SENTRY_PROJECT}

RUN yarn install
RUN chmod -R 777 ./scripts/build.sh
RUN ./scripts/build.sh

FROM nginx:mainline-alpine

COPY --from=builder /home/node/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000