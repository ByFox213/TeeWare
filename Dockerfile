FROM alpine:3.19 AS bam

RUN apk update && apk add --no-cache \
	git

RUN git clone \
	https://github.com/matricks/bam

RUN apk add --no-cache \
	gcc \
	musl-dev

WORKDIR /bam

RUN git checkout v0.4.0
RUN ./make_unix.sh

# ---

FROM alpine:3.19 AS build

COPY . /tw

RUN apk add --no-cache \
	curl-dev \
	gcc \ 
	g++ \
	python3

WORKDIR /tw

COPY --from=bam /bam /bam

RUN /bam/bam server_release

# ---

FROM alpine:3.19

RUN apk update && apk add --no-cache \
	libstdc++
	
COPY --from=build /tw /tw
COPY --from=build /tw/maps /tw/data/maps

WORKDIR /tw/data

ENTRYPOINT ["/tw/TeeWare"]
