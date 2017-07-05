# Builds a Docker image for Octave 4.2.1 and Jupyter Notebook for Octave
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

ARG OCTAVE_VERSION=4.2.1

# Install system packages and build Octave
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
         build-essential \
         gfortran \
         gnupg-agent \
         dput \
         fakeroot \
         devscripts \
         javahelper \
         debhelper=10.\* \
         dh-autoreconf=12\* \
         dh-exec \
         \
         automake \
         bison \
         default-jdk \
         desktop-file-utils \
         dh-exec \
         epstool \
         flex \
         gawk \
         gfortran \
         ghostscript \
         gnuplot-nox \
         icoutils \
         javahelper \
         less \
         libarpack2-dev \
         libblas-dev \
         libcurl4-gnutls-dev \
         libfftw3-dev \
         libfltk1.3-dev \
         libfontconfig1-dev \
         libftgl-dev \
         libgl2ps-dev \
         libglpk-dev \
         libgraphicsmagick++1-dev \
         libhdf5-dev \
         liblapack-dev \
         libncurses5-dev \
         libosmesa6-dev \
         libpcre3-dev \
         libqhull-dev \
         libqrupdate-dev \
         libqscintilla2-dev \
         libqt4-dev \
         libqt4-opengl-dev \
         libreadline-dev \
         librsvg2-bin \
         libsndfile1-dev \
         libsuitesparse-dev \
         libxft-dev \
         portaudio19-dev \
         pstoedit \
         texinfo \
         texlive-generic-recommended \
         texlive-fonts-recommended \
         texlive-latex-base \
         transfig \
         unzip \
         xauth \
         xvfb \
         zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD image/bin $DOCKER_HOME/bin

USER $DOCKER_USER
RUN cd $DOCKER_HOME && \
    curl -O -L https://launchpad.net/ubuntu/+archive/primary/+files/octave_${OCTAVE_VERSION}.orig.tar.gz && \
    git clone --depth 3 --no-single-branch https://github.com/xmjiao/octave-debian.git && \
    cd octave-debian && \
    git checkout debian/4.2.1-2 && \
    DEB_FFLAGS_SET="-O2" DEB_CFLAGS_SET="-O2" DEB_CXXFLAGS_SET="-O2" \
    DEB_BUILD_OPTIONS="nocheck" debuild -i -us -uc -b -j2

USER root
WORKDIR $DOCKER_HOME
