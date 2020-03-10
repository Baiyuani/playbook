#!/bin/bash
# 
parted /dev/vdb mklabel gpt << EOF
y
EOF
parted /dev/vdb mkpart primary 1 50%
parted /dev/vdb mkpart primary 50% 100%

