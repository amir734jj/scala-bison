ARG SOURCE_SCALA_VERSION="2.12.15"
ARG DESTINATION_SCALA_VERSION="2.13.7"
ARG BISON_VERSION="1.875"
# $SCALA_BISON should be consistent with $SOURCE_SCALA_VERSION
ARG SCALA_BISON="2.12"

FROM azul/zulu-openjdk-alpine:11 AS base

ARG SOURCE_SCALA_VERSION
ARG DESTINATION_SCALA_VERSION
ARG BISON_VERSION
ARG SCALA_BISON

WORKDIR /usr/lib

# Install basics
RUN apk add --no-cache bash make gcompat build-base m4 git \
  && apk add --no-cache --virtual=build-dependencies wget ca-certificates

# Build and install Bison
RUN wget -q "https://ftp.gnu.org/gnu/bison/bison-${BISON_VERSION}.tar.gz" -O - | gunzip | tar x \
  && cd "bison-${BISON_VERSION}" \
  && ./configure \
  && make \
  && make install

ENV BASE_PATH="$PATH"

# Download Scala source
RUN wget -q --no-cookies "https://downloads.lightbend.com/scala/${SOURCE_SCALA_VERSION}/scala-${SOURCE_SCALA_VERSION}.tgz" -O - | gunzip | tar x

ENV PATH="/usr/lib/scala-$SOURCE_SCALA_VERSION/bin:$BASE_PATH"

# Build Scala-Bison
COPY . scala-bison
RUN cd scala-bison \
  && wget -q "https://github.com/boyland/scala-bison/releases/download/v1.1/scala-bison-${SCALA_BISON}.jar" -O "scala-bison.jar" \
  && make boot

# Download Scala source
RUN wget -q --no-cookies "https://downloads.lightbend.com/scala/${DESTINATION_SCALA_VERSION}/scala-${DESTINATION_SCALA_VERSION}.tgz" -O - | gunzip | tar x

ENV PATH="/usr/lib/scala-$DESTINATION_SCALA_VERSION/bin:$BASE_PATH"

# Bootstrap Scala-Bison
RUN cd scala-bison \
  && make compile \
  && make
