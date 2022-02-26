FROM alpine:3.13

ARG VERSION=0.0.0

LABEL maintainer="Team Hadenlabs <hello@hadenlabs.com>" \
      org.label-schema.vcs-url="https://github.com/hadenlabs/action-docker-template" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENV PATH $PATH:/root/.local/bin

ENV GITHUB_WORKSPACE=/github/workspace

ENV BASE_DEPS \
    coreutils

ENV PERSIST_DEPS \
    bash \
    git \
    grep  \
    jq

ENV BUILD_DEPS \
    alpine-sdk \
    curl \
    fakeroot \
    build-base \
    freetype-dev \
    gcc \
    openssl

WORKDIR ${GITHUB_WORKSPACE}

COPY provision/script/entrypoint.sh /entrypoint.sh

RUN apk --no-cache add $BASE_DEPS \
    $BASE_DEPS \
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && sed -i "s/root:\/root:\/bin\/ash/root:\/root:\/bin\/bash/g" /etc/passwd \
    && apk del .build-deps \
    && chmod 755 /entrypoint.sh \
    && rm -rf /root/.cache \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]
