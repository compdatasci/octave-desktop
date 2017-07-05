# Builds a Docker image for Octave 4.2.1 and Jupyter Notebook for Octave
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

ARG OCTAVE_VERSION=4.2.1
ARG CRED=secret

# Install system packages and build Octave
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gfortran \
        cmake \
        bsdtar \
        rsync \
        texinfo \
        info \
        \
        libpcre3 \
        libqhull7 \
        libqrupdate1 \
        libqscintilla2-12v5 \
        libqtcore4 \
        libqtgui4 \
        libqt4-network \
        libqt4-opengl \
        libreadline-dev \
        libxft2 \
        libncurses5-dev \
        libhdf5-dev \
        libblas-dev \
        liblapack-dev \
        libarpack2 \
        libfftw3-dev \
        libsuitesparse-dev \
        libfltk1.3 \
        libfltk-gl1.3 \
        libglpk36 \
        libglu1 \
        libosmesa6 \
        libglu1-mesa \
        libgl1-mesa-dev \
        libgl2ps0 \
        libgraphicsmagick++-q16-12 \
        libgraphicsmagick-q16-3 \
        libzip4 \
        libsndfile1 \
        portaudio19-dev \
        \
        gnuplot-x11 \
        libopenblas-base \
        \
        python3-dev \
        pandoc \
        ttf-dejavu && \
    apt-get clean && \
    \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install -U setuptools && \
    \
    git clone --depth 1 https://github.com/hpdata/gdutil /usr/local/gdutil && \
    pip2 install -r /usr/local/gdutil/requirements.txt && \
    pip3 install -r /usr/local/gdutil/requirements.txt && \
    ln -s -f /usr/local/gdutil/bin/* /usr/local/bin/ && \
    \
    echo $(sh -c "echo '$CRED'") > mycred.txt && \
    gd-get -c . -p 0ByTwsK5_Tl_PZEszd0ZnWkdrRjA '*.deb' && \
    dpkg -i octave_4.2.1-2_amd64.deb  liboctave4_4.2.1-2_amd64.deb \
        octave-common_4.2.1-2_all.deb liboctave-dev_4.2.1-2_amd64.deb \
        octave-info_4.2.1-2_all.deb && \
    \
    pip install sympy && \
    octave --eval 'pkg install -forge struct parallel symbolic' && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Jupyter Notebook for Python and Octave
RUN pip3 install -U \
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
