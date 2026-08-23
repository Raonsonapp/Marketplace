# TajikShop API — multi-stage build.
# Build context must be the repository root, e.g.:
#   docker build -f infrastructure/docker/api.Dockerfile -t tajikshop-api .

# ---------- build stage ----------
FROM golang:1.24-bookworm AS build

WORKDIR /src

# Cache module downloads separately from source changes.
COPY services/api/go.mod services/api/go.sum ./
RUN go mod download

COPY services/api/ ./

RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/tajikshop-api ./cmd/server

# ---------- runtime stage ----------
FROM gcr.io/distroless/static-debian12:nonroot AS runtime

WORKDIR /app
COPY --from=build /out/tajikshop-api /app/tajikshop-api

USER nonroot:nonroot
EXPOSE 8080

ENTRYPOINT ["/app/tajikshop-api"]
