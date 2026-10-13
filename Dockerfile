FROM gcc
RUN apt update
RUN apt upgrade -y
RUN apt-get install jq -y
WORKDIR /
COPY . .
RUN make check && make all
ENTRYPOINT ["/build/wordcount"]
