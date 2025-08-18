FROM bitwalker/alpine-elixir-phoenix:latest

EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod

RUN apk add --no-cache postgresql-client

WORKDIR /app

ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . .

CMD ["mix", "phx.server"]
