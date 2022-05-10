## Title: NOM PROJET
 _Author: Éléonore Lemieux_
 _Lab: Antony Vincent, IBIS, Université Laval_

### Description
Metagenomics tool for bacteriophages, (co evolution with bacteria and response to treatement)
Goal: Investigate and identify phages in metagenomes

### Programs and environments to install
1. Bioconda

2. MEGAHIT

    `conda install -c bioconda megahit`


3. Virsorter2

    _To install with bioconda_

    `conda install -c bioconda virsorter`


    _Download the database (required)_

    `virsorter setup -d db -j 4`

4. DeepHost

    `git lfs clone https://github.com/deepomicslab/DeepHost.git`
    
    _Build the Cython file needed_
    ```Bash
    cd DeepHost_scripts
    python setup.py build_ext --inplace
    cd DeepHost_train
    python setup.py build_ext --inplace
    ```

### How to run



### How to use


### Tests


### Credits


### License


