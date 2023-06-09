FROM golang:alpine AS builder

RUN go version
RUN apk add git

COPY ./ /github.com/itoqsky/reader-adviser-bot
WORKDIR /github.com/itoqsky/reader-adviser-bot

RUN go mod download && go get -u ./...
RUN CGO_ENABLED=0 GOOS=linux go build -o ./.bin/app main.go

#lightweight docker container with binary
FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=0 /github.com/itoqsky/reader-adviser-bot/.bin/app .

EXPOSE 8000

CMD ./app -tg-bot-token $TOKEN