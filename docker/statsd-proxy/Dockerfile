FROM node:12-alpine

RUN apk add --update git bash curl jq

RUN mkdir -p /app
WORKDIR /app
RUN git clone https://github.com/etsy/statsd.git
WORKDIR /app/statsd

RUN npm install -g forever
ADD package.json ./package.json
ADD package-lock.json ./package-lock.json
RUN npm install
COPY * ./

EXPOSE 8125/udp 8126

CMD ["forever", "statsd-proxy.json"]
