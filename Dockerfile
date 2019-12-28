FROM ubuntu:16.04

WORKDIR /haribote
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
  build-essential \
  gcc-multilib \
  qemu-system \
  mtools \
  curl

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
ENV HOME /root
ENV PATH $HOME/.cargo/bin:$PATH
RUN rustup default nightly && rustup override set nightly
