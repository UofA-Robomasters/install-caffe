# Install Caffe

## Introduction

This is a quick way to compile and install Caffe from source
(https://github.com/BVLC/caffe), and set up environment required to run Caffe
in python.

It has been tested in Ubuntu 14.04 with CUDA8.0 and CUDNN5.1, and it may not work in
other platforms.

## Usage

#### CPU Only

Simply open ```install_caffe.sh``` and modify ```MAKE_FILE``` variable according to
your machine, and then run the script:

```
chmod u+x install_caffe.sh
./install_caffe.sh
```

#### GPU and cuDNN

For GPU verion you need to have CUDA and cuDNN installed. Please go to
https://developer.nvidia.com/cuda-downloads and download the correct
installation file for your machine. I personally use Linux > x86_64 > Ubuntu >
14.04 > deb (network)

After that, please go to https://developer.nvidia.com/cudnn and download cuDNN,
I am using cuDNN v5.1 for CUDA8.0.
The installation for cuDNN is simply extract the package and copy all files to
the corresponding directories in ```/usr/local/cuda```
