FROM phusion/baseimage:0.9.17

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]


# ...put your own build instructions here...
RUN apt-get -y update && \
  apt-get install -y curl \
  wget \
  automake \
  autotools-dev \
  g++ \
  libcurl4-gnutls-dev \
  libfuse-dev \
  libssl-dev \
  libxml2-dev \
  make \
  pkg-config \
  bzip2 \
  build-essential \
  git \
  zlib1g-dev \
  python-dev \
  python-pip \
  python-numpy \
  python-pyparsing \
  cython \
  python-jinja2 \
  parallel \
  python-parallel \
  python-pandas \
  python-scipy \
  python-bottle \
  python-numexpr \
  python-openpyxl \
  bedtools \
  python-yaml

RUN pip install -U pip setuptools cython

# install Gemini
RUN git clone https://github.com/arq5x/gemini.git &&\
  cd gemini &&\
  python setup.py install 

# install gemini data WARNING!: this creates a FAT container
RUN python gemini/install-data.py /usr/local/share/

RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git &&\
	cd s3fs-fuse &&\
	./autogen.sh &&\
	./configure &&\
	make &&\
	make install


# set gemini path
ENV PATH $PATH:/usr/local/gemini/bin

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
