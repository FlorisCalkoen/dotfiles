#!bin/bash

# install the following packages in the base environment
mamba install jupyterlab
mamba install nb_conda_kernels
mamba install nb_conda
mamba install jupyter_contrib_nbextensions
mamba install jupyterlab_code_formatter
mamba install jupyterlab_vim
mamba install jupyterlab-git
mamba install dask_labextension

# in new project environments install
# mamba install ipykernel
