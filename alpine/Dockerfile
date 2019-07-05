FROM openresty/openresty:alpine-fat

MAINTAINER vkill <vkill.net@gmail.com>

# or master
ARG APISIX_VERSION=v0.5
ENV APISIX_VERSION=${APISIX_VERSION}

ENV APISIX_DOWNLOAD_URL https://github.com/iresty/apisix/archive/${APISIX_VERSION}.zip

# or SKIP
ARG APISIX_DOWNLOAD_SHA256=e6f14dcd58c5ba286ee48f8482a669893560bc2fbc90d6bf52881493ce720fb7
ENV APISIX_DOWNLOAD_SHA256=${APISIX_DOWNLOAD_SHA256}

ARG RESTY_PCRE_VERSION="8.42"

RUN set -ex \
  \
  && sed -i 's!dl-cdn.alpinelinux.org!mirrors.aliyun.com!' /etc/apk/repositories \
  \
  && apk add --no-cache --virtual .rundeps \
    curl \
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
  && curl -fSL https://ftp.pcre.org/pub/pcre/pcre-${RESTY_PCRE_VERSION}.tar.gz -o pcre-${RESTY_PCRE_VERSION}.tar.gz \
  && tar xzf pcre-${RESTY_PCRE_VERSION}.tar.gz -C /tmp \
  && rm -rf pcre-${RESTY_PCRE_VERSION}.tar.gz \
  && cd /tmp/pcre-${RESTY_PCRE_VERSION} \
  && ./configure --enable-jit --enable-utf --enable-unicode-properties \
  && make \
  && sudo make install \
  && cd / \
  && rm -rf /tmp/pcre-${RESTY_PCRE_VERSION} \
  \
  && wget -O apisix.zip "${APISIX_DOWNLOAD_URL}" \
  && [[ "${APISIX_DOWNLOAD_SHA256}" = "SKIP" ]] && echo "SKIP" || (echo "${APISIX_DOWNLOAD_SHA256} *apisix.zip" | sha256sum -c -) \
  \
  && mkdir -p /usr/src \
  && unzip apisix.zip -d /usr/src \
  && rm apisix.zip \
  \
  && cd "/usr/src/apisix-`echo ${APISIX_VERSION} | sed 's/^v//'`" \
  \
  && make dev \
  && make install \
  \
  && cd / \
  && rm -r "/usr/src/apisix-`echo ${APISIX_VERSION} | sed 's/^v//'`" \
  \
  && luarocks install lua-resty-template \
  && luarocks install lua-resty-etcd \
  \
  && apk del .builddeps

WORKDIR /usr/local/apisix

CMD ["/usr/bin/apisix", "start"]
