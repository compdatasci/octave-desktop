# Builds a Docker image for Octave 4.2.1 and Jupyter Notebook for Octave
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

ENV OCTAVE_VERSION=4.2.1

# Install system packages and build Octave
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gawk \
        git \
        gfortran \
        gnuplot-x11 \
        texi2html \
        icoutils \
        libxft-dev \
        gperf \
        libbison-dev \
        libqhull-dev \
        libglpk-dev \
        libcurl4-gnutls-dev \
        libfltk-cairo1.3 \
        libfltk-forms1.3 \
        libfltk-images1.3 \
        libfltk1.3-dev \
        librsvg2-dev \
        libqrupdate-dev \
        libgl2ps-dev \
        libarpack2-dev \
        libreadline-dev \
        libncurses-dev \
        hdf5-helpers \
        libhdf5-cpp-11 \
        libhdf5-dev \
        llvm-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        texinfo \
        libfftw3-dev \
        libgraphicsmagick++1-dev \
        libgraphicsmagick1-dev \
        libjasper-dev \
        libfreeimage-dev \
        transfig \
        epstool \
        librsvg2-bin \
        libosmesa6-dev \
        libsndfile-dev \
        libsndfile1-dev \
        libportaudiocpp0 \
        portaudio19-dev \
        lzip \
        libqt5core5a \
        libqt5gui5 \
        libqt5network5 \
        libqt5opengl5 \
        libqt5opengl5-dev \
        libqt5scintilla2-dev \
        qttools5-dev-tools \
        qt5-default \
        libopenblas-base \
        libatlas3-base \
        libatlas-dev \
        liblapack-dev \
        ghostscript \
        pstoedit \
        libaec-dev \
        libblas-dev \
        libbtf1.2.1 \
        libcsparse3.1.4 \
        libexif-dev \
        libflac-dev \
        libftgl-dev \
        libftgl2 \
        libjack-dev \
        libklu1.3.3 \
        libldl2.2.1 \
        libogg-dev \
        libspqr2.0.2 \
        libsuitesparse-dev \
        libvorbis-dev \
        libwmf-dev \
        uuid-dev \
        pandoc \
        ttf-dejavu \
        python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -s ftp://ftp.gnu.org/gnu/octave/octave-${OCTAVE_VERSION}.tar.gz | tar zx && \
    cd octave-* && \
    ./configure --prefix=/usr/local && \
    make CFLAGS=-O CXXFLAGS=-O LDFLAGS= -j 2 && \
    make install && \
    \
    pip install sympy && \
    octave --eval 'pkg install -forge struct parallel symbolic' && \
    rm -rf /tmp/* /var/tmp/*

# Install Jupyter Notebook for Python and Octave
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install -U \
         setuptools \
         ipython \
         jupyter \
         ipywidgets && \
    jupyter nbextension install --py --system \
         widgetsnbextension && \
    jupyter nbextension enable --py --system \
         widgetsnbextension && \
    pip3 install -U \
        jupyter_latex_envs==1.3.8.4 && \
    jupyter nbextension install --py --system \
        latex_envs && \
    jupyter nbextension enable --py --system \
        latex_envs && \
    jupyter nbextension install --system \
        https://bitbucket.org/ipre/calico/downloads/calico-spell-check-1.0.zip && \
    jupyter nbextension install --system \
        https://bitbucket.org/ipre/calico/downloads/calico-document-tools-1.0.zip && \
    jupyter nbextension install --system \
        https://bitbucket.org/ipre/calico/downloads/calico-cell-tools-1.0.zip && \
    jupyter nbextension enable --system \
        calico-spell-check && \
    pip3 install -U octave_kernel && \
    python3 -m octave_kernel.install && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    \
    touch $DOCKER_HOME/.log/jupyter.log && \
    \
    echo '@octave --force-gui' >> $DOCKER_HOME/.config/lxsession/LXDE/autostart && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

WORKDIR $DOCKER_HOME
