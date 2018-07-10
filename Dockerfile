FROM node:8.11.1 as builder

ADD package.json /tmp/package.json
RUN cd /tmp && npm -q install && npm -q cache verify
RUN npm install -g @angular/cli
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/
COPY . /opt/app
WORKDIR /opt/app
RUN npm run build

FROM nginx:1.13.9-alpine

COPY --from=builder /opt/app/dist/docker-angular /usr/share/nginx/html
CMD npm run start

CMD ["nginx", "-g", "daemon off;"]