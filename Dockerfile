FROM ubuntu:15.10
MAINTAINER Jeremy Asuncion "jeremyasuncion808@gmail.com"

ENV SWIFT_SNAPSHOT "swift-2.2-SNAPSHOT-2016-01-06-a"
ENV SWIFT_URL "https://swift.org/builds/ubuntu1510/${SWIFT_SNAPSHOT}/${SWIFT_SNAPSHOT}-ubuntu15.10.tar.gz"

    # Installs Build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    clang \
    curl \
    git \
    libedit-dev \
    libevent-dev \
    libicu-dev \
    libsqlite3-dev \
    libssl-dev \
    libstdc++6-4.7-dev \
    libxml2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && \
    # Downloads Swift snapshot and installs it
    curl -k $SWIFT_URL | tar -vxz -C /usr --strip-components=2 && \
    git config --global http.sslVerify "false" && \
    git clone git://github.com/PerfectlySoft/Perfect.git /usr/local/src/Perfect

# Build Perfect
WORKDIR /usr/local/src/Perfect
RUN make && make install && \
    cd ../PerfectServer && \
    make && make install

WORKDIR /