FROM node:8-alpine as builder
RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN npm install
RUN $(npm bin)/ng build
FROM nginx
COPY --from=builder /usr/src/app/dist/* /usr/share/nginx/html/
EXPOSE 80