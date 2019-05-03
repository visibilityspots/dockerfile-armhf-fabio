ARG ARCH
FROM golang:alpine as gobuild

ARG GOARCH
ARG GOARM

RUN apk update; \
    apk add git; \
    go get github.com/fabiolb/fabio

WORKDIR /go/src/github.com/fabiolb/fabio

RUN GOARCH=${GOARCH} GOARM=${GOARM} go build ./

FROM multiarch/alpine:${ARCH}-edge

LABEL maintainer="Jan Collijs"

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

COPY --from=gobuild /go/src/github.com/fabiolb/fabio/fabio /usr/local/bin/fabio

ADD https://raw.githubusercontent.com/fabiolb/fabio/master/fabio.properties /etc/fabio/fabio.properties
EXPOSE 9998 9999
ENTRYPOINT ["/usr/local/bin/fabio"]
CMD ["-cfg", "/etc/fabio/fabio.properties"]
