FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y -qq update && apt-get -y -qq install build-essential gfortran libglu-dev wget bzip2 gcc
# add symlink because *something* is detecing the wrong location for libGLU
RUN ln -s /usr/lib/x86_64-linux-gnu /usr/lib64

RUN mkdir /tmp/build
WORKDIR /tmp/build
RUN wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN chmod +x ./Miniconda-latest-Linux-x86_64.sh
RUN bash ./Miniconda-latest-Linux-x86_64.sh -b -p /opt/conda
ENV PATH /opt/conda/bin:$PATH
RUN conda install -y conda-build jinja2 mpi4py mkl

ENV CHANNEL minrk
ENV VERSION 1.6.0
ADD install_or_build /usr/local/bin/install_or_build

ADD eigen3 eigen3
RUN install_or_build eigen3
ADD petsc petsc
RUN install_or_build petsc
ADD petsc4py petsc4py
RUN install_or_build petsc4py
ADD slepc slepc
RUN install_or_build slepc
ADD instant instant
RUN install_or_build instant ==$VERSION
ADD ufl ufl
RUN install_or_build ufl ==$VERSION
ADD fiat fiat
RUN install_or_build fiat ==$VERSION
ADD swig swig
RUN install_or_build swig
ADD ffc ffc
RUN install_or_build ffc ==$VERSION
ADD dolfin dolfin
RUN install_or_build dolfin ==$VERSION
ADD mshr mshr
RUN install_or_build mshr ==$VERSION
ADD fenics fenics
RUN install_or_build fenics ==$VERSION
