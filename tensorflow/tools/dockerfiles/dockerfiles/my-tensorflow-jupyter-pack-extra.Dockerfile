# Copyright 2019 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================
#
# THIS IS A GENERATED DOCKERFILE.
#
# This file was assembled from multiple pieces, whose use is documented
# throughout. Please refer to the TensorFlow dockerfiles documentation
# for more information.

ARG UBUNTU_VERSION=18.04

FROM ubuntu:${UBUNTU_VERSION} AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        sudo \
        unzip \
        zip \
        zlib1g-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CI_BUILD_PYTHON python

# CACHE_STOP is used to rerun future commands, otherwise cloning tensorflow will be cached and will not pull the most recent version
ARG CACHE_STOP=1
# Check out TensorFlow source code if --build-arg CHECKOUT_TF_SRC=1
ARG CHECKOUT_TF_SRC=0
# In case of Python 2.7+ we need to add passwd entries for user and group id
RUN chmod a+w /etc/passwd /etc/group
RUN test "${CHECKOUT_TF_SRC}" -eq 1 && git clone https://github.com/tensorflow/tensorflow.git /tensorflow_src || true

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

RUN python3 -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which python3) /usr/local/bin/python

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    openjdk-8-jdk \
    python3-dev \
    virtualenv \
    swig 

RUN python3 -m pip --no-cache-dir install \

    #Pillow - biblioteca de imagens Python
    Pillow \
    
    # h5py fornece uma interface de alto e baixo nível para a biblioteca HDF5 do Python.
    h5py \
    
    #keras - biblioteca de rede neural profunda.
    keras \
    
    #Matplotlib - biblioteca abrangente para a criação de visualizações estáticas, animadas e interativas em Python
    matplotlib \
    
    #mock - biblioteca para teste em Python
    mock \
    
    #Numpy - Pacote com métodos numéricos e representações matriciais
    'numpy<1.19.0' \
    
    #Scipy - fornece uma manipulação conveniente e rápida de um array N-dimensional
    scipy \
    
    # Pandas - Pacote para exploração e análise de dados
    pandas \
    
    #módulo Python
    future \
    portpicker \
    enum34 \
    
    ##Adicionado Extra ao dockerfile
    #Pacote para construção de modelo baseado na técnica Gradient Boosting
    xgboost \
    
    #Request - biblioteca para realizar requisições HTTP
    requests \
    
    #scikit-learn é uma biblioteca de aprendizado de máquina
    scikit-learn \
    
    #Nltk - Natural Language Toolkit, bibliotecas para processamento simbólico e estatístico da linguagem natural
    nltk \
    
    #web crawling que faz extração de dados em websites
    Scrapy \
    
    #conecta com banco de dados Mongodb
    pymongo \
    
    #Conecte-se a um banco de dados usando strings de conexão de URL SQLAlchemy
    ipython-sql \
    
    #conecta com banco de dados Elasticsearch
    eland \
    
    #Torch - biblioteca de aprendizado de máquina, usada para aplicativos como visão computacional e processamento de linguagem natural
    torch \
    
    #Theano - biblioteca Python e um compilador que torna a computação 140x mais rápida
    Theano \
    
    #Fire - biblioteca que gerar automaticamente CLIs (interfaces de linha de comando)
    fire \
    
    #Arrow - biblioteca amigável que basicamente trabalha com datas e horas
    arrow \
    
    #FlashText - biblioteca Python que oferece pesquisa e substituição fáceis de palavras dos documentos
    flashText \
    
    #SQLAlchemy - biblioteca de mapeamento objeto-relacional SQL para Python
    SQLAlchemy \
    
    #Luminoth - kit de ferramentas dedicado à visão computacional, suporta a detecção contínua de um objeto
    luminoth \
    
    #Bokeh - biblioteca de visualização de dados para python
    bokeh \
    
    #Cirq - biblioteca Python geralmente para circuitos quânticos de escala intermediária ruidosa (NISQ)
    cirq \
    
    #OpenCV - pacote para processamento de imagens
    opencv-python
    
#Bazel é uma ferramenta de software livre que permite a automação da construção e teste de software
# Install bazel
ARG BAZEL_VERSION=3.1.0
RUN mkdir /bazel && \
    wget -O /bazel/installer.sh "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh" && \
    wget -O /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    chmod +x /bazel/installer.sh && \
    /bazel/installer.sh && \
    rm -f /bazel/installer.sh

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc

RUN python3 -m pip install --no-cache-dir jupyter matplotlib
# Pin ipykernel and nbformat; see https://github.com/ipython/ipykernel/issues/422
RUN python3 -m pip install --no-cache-dir jupyter_http_over_ws ipykernel==5.1.1 nbformat==4.4.0
RUN jupyter serverextension enable --py jupyter_http_over_ws

RUN mkdir -p /tf/tensorflow-tutorials && chmod -R a+rwx /tf/
RUN mkdir /.local && chmod a+rwx /.local
RUN apt-get install -y --no-install-recommends wget
# some examples require git to fetch dependencies
RUN apt-get install -y --no-install-recommends git
WORKDIR /tf/tensorflow-tutorials
RUN wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/classification.ipynb
RUN wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/overfit_and_underfit.ipynb
RUN wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/regression.ipynb
RUN wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/save_and_load.ipynb
RUN wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/text_classification.ipynb
RUN wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/text_classification_with_hub.ipynb
COPY readme-for-jupyter.md README.md
RUN apt-get autoremove -y && apt-get remove -y wget
WORKDIR /tf
EXPOSE 8888

RUN python3 -m ipykernel.kernelspec

CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter notebook --notebook-dir=/tf --ip 0.0.0.0 --no-browser --allow-root"]
