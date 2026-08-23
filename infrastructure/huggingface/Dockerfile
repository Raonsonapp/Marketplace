# TajikShop API — Hugging Face Spaces (Docker SDK) deployment.
#
# This file (plus README.md in this directory) is meant to be pushed as the
# ROOT of a dedicated Hugging Face Space git repo — HF Spaces only build
# from files living at the Space repo's root, and this monorepo's backend
# lives under services/api, so the Space repo is a thin shell that clones
# the real source at build time. See docs/HUGGINGFACE_DEPLOYMENT.md for the
# full step-by-step (creating the Space, setting secrets, redeploying).
#
# Redeploying after a new commit to this repo: HF caches Docker layers
# across builds, so a plain restart can reuse the stale `git clone` layer.
# Use the Space's "Factory rebuild" (Settings -> Factory rebuild) to force
# a clean build that picks up the latest commit.

FROM golang:1.25-bookworm AS build

WORKDIR /src
# Shallow-clone the public monorepo at build time so this Space always
# tracks the real source of truth instead of a hand-copied mirror.
RUN git clone --depth 1 https://github.com/Raonsonapp/Marketplace.git .

WORKDIR /src/services/api
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/tajikshop-api ./cmd/server

FROM gcr.io/distroless/static-debian12:nonroot AS runtime

WORKDIR /app
COPY --from=build /out/tajikshop-api /app/tajikshop-api

USER nonroot:nonroot
# Hugging Face Spaces (Docker SDK) route traffic to port 7860 by default.
ENV PORT=7860
EXPOSE 7860

ENTRYPOINT ["/app/tajikshop-api"]
