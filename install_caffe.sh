#!/bin/bash

# Change this as needed:
MAKE_FILE="Makefile.config.gpu_cudnn"

CAFFE_ROOT="$HOME/Downloads/caffe"
WD=$PWD

sudo apt-get update
sudo apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get -y install --no-install-recommends libboost-all-dev
sudo apt-get -y install libatlas-base-dev
sudo apt-get -y install python-dev python-pip
sudo apt-get -y install libgflags-dev libgoogle-glog-dev liblmdb-dev

git clone https://github.com/BVLC/caffe.git "$CAFFE_ROOT"

sudo pip install --upgrade pip
sudo pip install --upgrade -r "$CAFFE_ROOT/python/requirements.txt"

cp "$MAKE_FILE" "$CAFFE_ROOT/Makefile.config"
cd "$CAFFE_ROOT"
make all
make test
make runtest
make distribute

echo "" >> "$HOME/.bashrc"
echo "# Caffe environment:" >> "$HOME/.bashrc"
STR_CAFFE_ROOT='export CAFFE_ROOT='
echo "$STR_CAFFE_ROOT\"$CAFFE_ROOT\"" >> "$HOME/.bashrc"
echo 'export PYTHONPATH="$CAFFE_ROOT/distribute/python:$PYTHONPATH"' >> "$HOME/.bashrc"
echo 'export LD_LIBRARY_PATH="$CAFFE_ROOT/distribute/lib:$LD_LIBRARY_PATH"' >> "$HOME/.bashrc"
echo 'export PATH="$CAFFE_ROOT/distribute/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
