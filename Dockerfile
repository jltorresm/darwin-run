FROM ubuntu:22.04 as builder

ENV CARGO_TERM_COLOR=always
ENV APP_NAME=darwin-run
ENV OUT_DIR_PATH=dist

SHELL ["bash", "-c"]

# Install ubuntu deps
RUN apt-get update && apt-get install -y curl libssl-dev

# Install ubuntu deps required for bevy
RUN apt-get update && apt-get install -y g++ pkg-config libx11-dev libasound2-dev libudev-dev lld

WORKDIR /app

# Install rust toolchain
RUN curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf > rustup.sh
RUN chmod a+x rustup.sh && ./rustup.sh -y && rm rustup.sh
RUN ~/.cargo/bin/rustup target add wasm32-unknown-unknown
RUN ~/.cargo/bin/cargo install wasm-bindgen-cli

# Copy all the code
ADD assets assets
ADD dist/index.html dist/index.html
ADD src src
ADD Cargo.toml Cargo.toml
ADD Cargo.lock Cargo.lock

# Test and build
RUN ~/.cargo/bin/cargo test
RUN ~/.cargo/bin/cargo build --release --target wasm32-unknown-unknown

# WASM bindings
RUN ~/.cargo/bin/wasm-bindgen --out-name "$APP_NAME" --out-dir "$OUT_DIR_PATH" \
      --target web "target/wasm32-unknown-unknown/release/$APP_NAME.wasm"

# Copy assets to dist
RUN cp -r ./assets "$OUT_DIR_PATH/" && ls -la "$OUT_DIR_PATH"

FROM nginx:stable-alpine-slim

COPY --from=builder "/app/dist" /usr/share/nginx/html

RUN ls -la /usr/share/nginx/html
