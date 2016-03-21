FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y -qq update && apt-get -y -qq install build-essential gfortran libglu-dev wget bzip2 gcc git pkg-config
RUN apt-get install -y locales -qq && locale-gen en_US.UTF-8 en_us && dpkg-reconfigure locales && dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8

ENV LANGUAGE C.UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONIOENCODING UTF-8

RUN mkdir /tmp/build
WORKDIR /tmp/build
RUN wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh \
 && chmod +x ./Miniconda-latest-Linux-x86_64.sh \
 && bash ./Miniconda-latest-Linux-x86_64.sh -b -p /opt/conda \
 && rm Miniconda-latest-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH
RUN conda install -y conda-build jinja2 mpi4py mkl cmake openblas

ENV CHANNEL minrk
ENV VERSION 1.7.0dev
RUN conda install -c $CHANNEL swig petsc petsc4py eigen3
# ADD vtk vtk
# RUN conda build -c $CHANNEL vtk

ADD instant instant
RUN conda build -c $CHANNEL instant
ADD ufl ufl
RUN conda build -c $CHANNEL ufl
ADD fiat fiat
RUN conda build -c $CHANNEL fiat
ADD ffc ffc
RUN conda build -c $CHANNEL ffc

ADD dolfin dolfin
RUN conda build -c $CHANNEL dolfin
ADD mshr mshr
RUN conda build -c $CHANNEL mshr
ADD fenics fenics
RUN conda build -c $CHANNEL fenics
