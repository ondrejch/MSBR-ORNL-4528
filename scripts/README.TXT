ORNL-4528 MSBR optimization project
===================================

The task is to analyze and optimize a two-fluid thorium fuel cycle iso-breeder inspired by ORNL-4528 concept, using modern computational tools. All scripts are either Python3 with NumPy and SciPy or Bash with basic GNU tools including grep and awk.

This directory contains the following directories:
* generate-lattices    - generate & run infinite 2D lattices for scoping purposes, using Serpent2 MC transport code.
* analyze-lattices     - analyze ouptuts from the above step and find optimal lattice dimension depending on the desired BoC conversion  ratio.
* flibe                - calcualte FLiBe-U salt density at 700C as a function of U mole%

     Ondrej Chvala, ochvala@utk.edu
        2016-07-16
        GNU/GPL

