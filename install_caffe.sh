#!/bin/bash

# Change this as needed:
MAKE_FILE="Makefile.config.gpu_cudnn"

CAFFE_ROOT="$HOME/Downloads/caffe"
WD=$PWD

sudo apt-get update
if [[ $? != 0 ]]; then
    echo 'Error: apt-get'
    exit -1
fi
sudo apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
if [[ $? != 0 ]]; then
    echo 'Error: apt-get'
    exit -1
fi
sudo apt-get -y install --no-install-recommends libboost-all-dev
if [[ $? != 0 ]]; then
    echo 'Error: apt-get'
    exit -1
fi
sudo apt-get -y install libatlas-base-dev python-dev python-pip libgflags-dev libgoogle-glog-dev liblmdb-dev gfortran
if [[ $? != 0 ]]; then
    echo 'Error: apt-get'
    exit -1
fi

git clone https://github.com/BVLC/caffe.git "$CAFFE_ROOT"
if [[ $? != 0 ]]; then
    echo 'Error: git clone failed'
    exit -1
fi

sudo pip install --upgrade pip
if [[ $? != 0 ]]; then
    echo 'Error: failed to upgrade pip'
    exit -1
fi

sudo pip install --upgrade -r "$CAFFE_ROOT/python/requirements.txt"
if [[ $? != 0 ]]; then
    echo 'Error: pip failed to install python requirements'
    exit -1
fi

cp "$MAKE_FILE" "$CAFFE_ROOT/Makefile.config"
if [[ $? != 0 ]]; then
    echo 'Error: failed to copy makefile, check if the path is correct'
    exit -1
fi

# Verify and set CUDA env:
if [[ $MAKE_FILE == 'Makefile.config.gpu_cudnn' ]]; then
    . "$HOME/.bashrc"
    if [[ $PATH != *"/usr/local/cuda/bin"* ]]; then
        echo '' >> "$HOME/.bashrc"
        echo '# CUDA env:' >> "$HOME/.bashrc"
        echo 'export PATH="/usr/local/cuda/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib:$LD_LIBRARY_PATH"' >> "$HOME/.bashrc"
        echo 'export LIBRARY_PATH="/usr/local/cuda/lib:$LIBRARY_PATH"' >> "$HOME/.bashrc"
        . "$HOME/.bashrc"
    fi
fi

cd "$CAFFE_ROOT"
make all
if [[ $? != 0 ]]; then
    echo 'Error: failed to compile caffe'
    exit -1
fi
make test
if [[ $? != 0 ]]; then
    echo 'Error: failed to make test'
    exit -1
fi
make runtest
if [[ $? != 0 ]]; then
    echo 'Error: runtest failed'
    exit -1
fi
make distribute
if [[ $? != 0 ]]; then
    echo 'Error: failed to distribute caffe'
    exit -1
fi

# Verify and set Caffe env:
if [[ ! grep -Fxq "Caffe" "$HOME/.bashrc" ]]; then
    echo "" >> "$HOME/.bashrc"
    echo "# Caffe environment:" >> "$HOME/.bashrc"
    STR_CAFFE_ROOT='export CAFFE_ROOT='
    echo "$STR_CAFFE_ROOT\"$CAFFE_ROOT\"" >> "$HOME/.bashrc"
    echo 'export PYTHONPATH="$CAFFE_ROOT/distribute/python:$PYTHONPATH"' >> "$HOME/.bashrc"
    echo 'export LD_LIBRARY_PATH="$CAFFE_ROOT/distribute/lib:$LD_LIBRARY_PATH"' >> "$HOME/.bashrc"
    echo 'export PATH="$CAFFE_ROOT/distribute/bin:$PATH"' >> "$HOME/.bashrc"
    . "$HOME/.bashrc"
fi
echo 'installation complete!'
