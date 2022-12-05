#!/bin/sh

sudo usermod -a -G sudo $USER
sudo groupadd docker
sudo usermod -a -G docker $USER

