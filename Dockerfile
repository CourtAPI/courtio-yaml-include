FROM perl:5.30 AS carton-deps

RUN cpanm install --notest Carton \
  && rm -rf $HOME/.cpanm

WORKDIR /app

COPY cpanfile .
RUN carton install \
  && rm -rf $HOME/.cpanm local/cache cpanfile.snapshot

FROM perl:5.30

WORKDIR /app

COPY --from=carton-deps /app/local /app/local

ADD lib /app/lib
RUN chmod -R a+rX /app/lib

ADD bin /app/bin
RUN chmod -R a+rX /app/bin

ENV PERL5LIB /app/local/lib/perl5:/app/lib

ENTRYPOINT ["/app/bin/yaml-include"]
