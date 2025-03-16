#!/bin/bash
export HOME=/nfs/home/${USER}/.local/bin
export PATH=$HOME/.local/bin:$PATH

python main.py 1>main_log.txt 2>&1
