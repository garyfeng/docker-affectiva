FROM ubuntu:14.04
MAINTAINER think@hotmail.de

ENV \
  AFFDEX_DATA_DIR /affdex-sdk/data \
  AFFECTIVA_SDK_VERSION 3.1.1-2802
COPY detect.sh /

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    gzip \
    libboost1.55-all-dev \
    libopencv-dev \
    tar \
    wget \
 && wget https://download.affectiva.com/linux/affdex-cpp-sdk-${AFFECTIVA_SDK_VERSION}-linux-64bit.tar.gz \
 && mkdir /affdex-sdk \
 && tar -xzvf /affdex-cpp-sdk-*-linux-64bit.tar.gz -C /affdex-sdk \
 && rm /affdex-cpp-sdk-*-linux-64bit.tar.gz \
 && git clone https://github.com/Affectiva/cpp-sdk-samples.git /sdk-samples \
 && mkdir build \
 && (cd build && cmake -DOpenCV_DIR=/usr/ -DBOOST_ROOT=/usr/ -DAFFDEX_DIR=/affdex-sdk /sdk-samples && make) \
 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/affdex-sdk/lib \
 && rm -rf /sdk-samples \
 && chmod +x /detect.sh \
 && ln /dev/null /dev/raw1394 \
 && apt-get remove --purge -y build-essential cmake git gzip tar wget \
 && rm -rf /var/lib/apt/lists/*

WORKDIR "/build/video-demo"

ENTRYPOINT ["/detect.sh"]
CMD []
