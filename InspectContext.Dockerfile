FROM busybox
WORKDIR /tmp
COPY . .
ENTRYPOINT ["find"]