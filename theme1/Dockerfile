# ---------- Stage 1: build ----------
FROM hexpm/elixir:1.20.4-erlang-29.1.1-ubuntu-jammy-20260810 AS builder

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends build-essential git ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

# Install deps first (better layer caching)
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mkdir config

COPY config/config.exs config/prod.exs config/runtime.exs ./config/
RUN mix deps.compile

# Compile app
COPY priv ./priv
COPY lib ./lib
RUN mix compile

# Build release
RUN mix release

# ---------- Stage 2: runtime ----------
FROM debian:bookworm-slim AS runtime

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends libstdc++6 openssl libncurses6 locales ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

ENV MIX_ENV=prod
ENV PHX_SERVER=true

COPY --from=builder --chown=nobody:root /app/_build/prod/rel/theme1 ./

USER nobody
EXPOSE 4000
ENTRYPOINT ["/app/bin/theme1"]
CMD ["start"]