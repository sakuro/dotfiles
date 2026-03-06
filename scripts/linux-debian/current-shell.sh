#!/bin/bash

set -- $(getent passwd "$USER" | cut -d : -f 7)
echo "$1"
