# Copyright (C) 2021 Leandro Lisboa Penz <lpenz@lpenz.org>
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of this source code package.

# Adapted from https://github.com/rust-lang/docker-rust/blob/master/Dockerfile-slim.template

FROM debian:bullseye-slim

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        libc6-dev \
        wget \
        ; \
    sed -i '/pam_rootok.so$/aauth sufficient pam_permit.so' /etc/pam.d/su; \
    wget https://sh.rustup.rs -O rustup-init; \
    bash rustup-init -y --no-modify-path --profile minimal --default-toolchain nightly-2022-06-04; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    apt-get remove -y --auto-remove \
        wget \
        ; \
    rm -rf /var/lib/apt/lists/*; \
    rustup component add llvm-tools-preview; \
    cargo install cargo-llvm-cov

COPY entrypoint /
CMD ["/entrypoint"]
