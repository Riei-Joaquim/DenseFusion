FROM nvidia/cudagl:9.0-devel-ubuntu16.04

ARG DEBIAN_FRONTEND=noninteractive

# Essentials: developer tools, build tools, OpenBLAS
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils git curl vim unzip openssh-client wget \
    build-essential cmake \
    libopenblas-dev \
    libglib2.0-0 \
    libsm6 \
    libffi-dev \
    libxext6 \
    libxrender-dev

# Python 3.5
RUN apt-get update && apt-get install -y --no-install-recommends python3.5 python3.5-dev python3-pip python3-tk && \
    #pip3 install --no-cache-dir --upgrade pip setuptools && \
    echo "alias python='python3'" >> /root/.bash_aliases && \
    echo "alias pip='pip3'" >> /root/.bash_aliases

ENV PYTHONWARNINGS=ignore:DEPRECATION
RUN pip3 install --upgrade 'pip<21' 'setuptools<51'
RUN pip3 install pyyaml

# Science libraries and other common packages
RUN pip3 --no-cache-dir install \
    numpy scipy pyyaml matplotlib Cython requests opencv-python "pillow<7"

RUN pip3 install cffi
RUN pip3 install cffi_utils
# Tensorflow
RUN pip3 install https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp35-cp35m-linux_x86_64.whl && \
    pip3 install torchvision==0.2.2.post3

# Expose port for TensorBoard
EXPOSE 6006

# cd to home on login
RUN echo "cd /root/dense_fusion" >> /root/.bashrc
