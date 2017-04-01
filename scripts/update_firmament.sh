#!/bin/bash

eval $(ssh-agent)
ssh-add ~/.ssh/flowlessly-deploy_rsa
cd firmament
git checkout ./
git checkout master
git pull
cd build
make -j12
