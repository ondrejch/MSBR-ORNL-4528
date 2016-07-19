#! /usr/bin/python3
#
# Generate full ORNL-4528 MSBR Serpent input deck based on the job directory
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import sys
import os

mypath = str.strip(os.getcwd())     # Get current path