# StageE22
 Title: 
 Author: Eleonore Lemieux
 Lab: Antony Vincent, IBIS, ULaval

Metagenomics tool for bacteriophages, (co evolution with bacteria and response to treatement)

Goal: Investigate and identify phages in metagenomes

Programs to install:
- MEGAHIT
    conda install -c bioconda megahit
- Virsorter2
    #Installation
    conda install -c bioconda virsorter
    #Database
    virsorter setup -d db -j 4
-DeepHost
    #Installation
    git lfs clone https://github.com/deepomicslab/DeepHost.git
    #Build Cython file 
    cd DeepHost_scripts
    python setup.py build_ext --inplace
    cd DeepHost_train
    python setup.py build_ext --inplace

