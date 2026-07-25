#!/bin/bash

: ${TARGET_OS:?}

sudo install -m400 "files/sudoers.${TARGET_OS}" "/etc/sudoers.d/$USER"
