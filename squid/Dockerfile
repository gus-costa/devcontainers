# Squid Proxy for Devcontainer Network Isolation
# See: specs/squid-proxy.md
#
# This container provides traffic filtering for AI agent isolation.
# All devcontainer traffic routes through Squid, which allows only
# whitelisted domains.

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    squid \
    && rm -rf /var/lib/apt/lists/*

# Create log directory with proper permissions
RUN mkdir -p /var/log/squid && \
    chown -R proxy:proxy /var/log/squid

EXPOSE 3128

# Run Squid in foreground mode
CMD ["squid", "-N", "-f", "/etc/squid/squid.conf"]
