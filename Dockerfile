FROM perl:5.36.1-slim-bullseye AS carton-deps

RUN apt-get update && apt-get install build-essential -y

RUN cpanm install --notest Carton \
  && rm -rf $HOME/.cpanm

WORKDIR /app

COPY cpanfile .
RUN carton install \
  && rm -rf $HOME/.cpanm local/cache cpanfile.snapshot

FROM perl:5.36.1-slim-bullseye

WORKDIR /app

COPY --from=carton-deps /app/local /app/local

ADD lib /app/lib
RUN chmod -R a+rX /app/lib

ADD bin /app/bin
RUN chmod -R a+rX /app/bin

ENV PERL5LIB /app/local/lib/perl5:/app/lib

ENTRYPOINT ["/app/bin/yaml-include"]
