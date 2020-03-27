FROM perl:5.30

RUN cpanm install --notest Carton \
  && rm -rf $HOME/.cpanm

WORKDIR /app

COPY cpanfile .
RUN carton install \
  && rm -rf $HOME/.cpanm

COPY lib .
COPY bin .

CMD /app/bin/yaml-include
