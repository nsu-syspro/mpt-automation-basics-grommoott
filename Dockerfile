FROM gcc
RUN apt update
RUN apt-get install jq -y
WORKDIR /

COPY .test .test
COPY test test
COPY src src
COPY Makefile Makefile
COPY config.json config.json

RUN make check
ENTRYPOINT ["/build/wordcount"]
