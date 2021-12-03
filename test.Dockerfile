#FROM gcr.io/distroless/static AS final
FROM scratch AS final

# copy compiled app
COPY /bin/linux/auto-play /app

# run binary
ENTRYPOINT ["/app"]