FROM alpine as builder
RUN apk add --no-cache build-base

WORKDIR /app
COPY zombie.c .
RUN gcc -o zombie zombie.c

FROM alpine

WORKDIR /app
COPY --from=builder /app/zombie /app/zombie

CMD ["sleep", "infinity"]