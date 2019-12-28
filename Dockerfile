FROM rustlang/rust:nightly

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
  build-essential \
  nasm \
  gcc-multilib \
  mtools \
  curl

WORKDIR /haribote
COPY . /haribote
VOLUME /haribote

RUN rustup component add rust-src
RUN cargo install cargo-xbuild
RUN cargo xbuild --target i686-haribote.json
