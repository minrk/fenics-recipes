FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y install wget bzip2 build-essential gcc

RUN mkdir /tmp/build
WORKDIR /tmp/build
RUN wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN chmod +x ./Miniconda-latest-Linux-x86_64.sh
RUN bash ./Miniconda-latest-Linux-x86_64.sh -b -p /opt/conda
ENV PATH /opt/conda/bin:$PATH
RUN conda install -y conda-build jinja2
# for caching
RUN conda install -y swig mpi4py mkl
RUN conda update conda-build

ADD eigen3 eigen3
RUN conda build eigen3
ADD petsc petsc
RUN conda build petsc
ADD petsc4py petsc4py
RUN conda build petsc4py
ADD slepc slepc
RUN conda build slepc
ADD instant instant
RUN conda build instant
ADD ufl ufl
RUN conda build ufl
ADD fiat fiat
RUN conda build fiat
ADD swig swig
RUN conda build swig
ADD ffc ffc
RUN conda build ffc
RUN apt-get -y install gfortran libglu1-mesa-dev
# add symlink because *something* is detecing the wrong location for libGLU
RUN ln -s /usr/lib/x86_64-linux-gnu /usr/lib64
ADD dolfin dolfin
RUN conda build dolfin
ADD fenics fenics
RUN conda build fenics
