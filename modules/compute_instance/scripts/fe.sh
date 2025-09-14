#!/bin/bash
set -e

# Install dependencies
yum update -y
yum install -y java-1.8.0-openjdk wget unzip

# Create doris directory
mkdir -p /opt/doris
cd /opt/doris

# Download and extract Doris FE
wget https://apache-doris-releases.oss-accelerate.aliyuncs.com/apache-doris-2.1.1-bin-x86_64.tar.xz
tar -xvf apache-doris-2.1.1-bin-x86_64.tar.xz

# Start FE
cd apache-doris-2.1.1/fe
sh start_fe.sh --daemon
