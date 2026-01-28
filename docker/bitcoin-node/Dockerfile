FROM ubuntu:22.04

ARG TARBALL_URL
ARG TARBALL_SHA256

ENV BITCOIN_HOME=/opt/bitcoin
ENV PATH="${BITCOIN_HOME}/bin:${PATH}"

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl tar gosu \
  && rm -rf /var/lib/apt/lists/*

RUN if [ -z "${TARBALL_URL}" ]; then echo "TARBALL_URL is required" >&2; exit 1; fi

RUN set -eux; \
  mkdir -p /tmp/bitcoin && cd /tmp/bitcoin; \
  curl -fsSL -o bitcoin.tar.gz "${TARBALL_URL}"; \
  if [ -n "${TARBALL_SHA256}" ]; then echo "${TARBALL_SHA256}  bitcoin.tar.gz" | sha256sum -c -; fi; \
  mkdir -p "${BITCOIN_HOME}"; \
  tar -xzf bitcoin.tar.gz -C "${BITCOIN_HOME}" --strip-components=1; \
  rm -rf /tmp/bitcoin

RUN groupadd -r bitcoin && useradd -r -g bitcoin -d /data bitcoin \
  && mkdir -p /data /config \
  && chown -R bitcoin:bitcoin /data /config

COPY docker/bitcoin-node/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/data"]

EXPOSE 8332 8333 18443 18444

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["bitcoind"]
