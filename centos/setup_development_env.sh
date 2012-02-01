#!/bin/bash

yum -y install  \
        glibc-devel glibc-headers \
        gcc gcc-c++ bison \
        ruby curl curl-devel subversion \
        autoconf zlib-devel readline-devel \
        openssl-devel mysql-server mysql \
        mysql-devel pcre-devel libxslt-devel \
        libevent-devel \
        ImageMagick-devel

