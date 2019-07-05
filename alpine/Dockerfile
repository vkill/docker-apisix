FROM openresty/openresty:alpine-fat

MAINTAINER vkill <vkill.net@gmail.com>

# or master
ARG APISIX_VERSION=v0.5
ENV APISIX_VERSION=${APISIX_VERSION}

ENV APISIX_DOWNLOAD_URL https://github.com/iresty/apisix/archive/${APISIX_VERSION}.zip

# or SKIP
ARG APISIX_DOWNLOAD_SHA256=e6f14dcd58c5ba286ee48f8482a669893560bc2fbc90d6bf52881493ce720fb7
ENV APISIX_DOWNLOAD_SHA256=${APISIX_DOWNLOAD_SHA256}

RUN set -ex \
  \
  && sed -i 's!dl-cdn.alpinelinux.org!mirrors.aliyun.com!' /etc/apk/repositories \
  \
  && apk add --no-cache --virtual .rundeps \
    curl \
    pcre-dev \
    # graphviz-dev \
    # json-c-dev \
  \
  && apk add --no-cache --virtual .builddeps \
    unzip \
    build-base \
    make \
    sudo \
    git \
    automake \
    autoconf \
    libtool \
    pkgconfig \
    cmake \
  \
  && ln -sf /usr/local/openresty/luajit/bin/luajit /usr/bin/lua \
  \
  && wget -O apisix.zip "${APISIX_DOWNLOAD_URL}" \
  && [[ "${APISIX_DOWNLOAD_SHA256}" = "SKIP" ]] && echo "SKIP" || (echo "${APISIX_DOWNLOAD_SHA256} *apisix.zip" | sha256sum -c -) \
  \
  && mkdir -p /usr/src \
  && unzip apisix.zip -d /usr/src \
  && rm apisix.zip \
  \
  && cd "/usr/src/apisix-${APISIX_VERSION}" \
  \
  && make dev \
  && make install \
  \
  && cd / \
  && rm -r "/usr/src/apisix-${APISIX_VERSION}" \
  \
  && luarocks install lua-resty-template \
  && luarocks install lua-resty-etcd \
  \
  && apk del .builddeps

WORKDIR /usr/local/apisix

CMD ["/usr/bin/apisix", "start"]
