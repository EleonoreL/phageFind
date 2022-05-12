## Title: NOM PROJET
 _Author:_ Éléonore Lemieux

 _Lab:_ Antony Vincent, IBIS, Université Laval

### Description
Metagenomics tool for bacteriophage identification and investigation

### Programs and environments to install
1. **Bioconda**

    ```Bash
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh
    ```
    Follow the installer instructions

    ```Bash
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge
    ```


2. **MEGAHIT**

    `conda install -c bioconda megahit`


3. **Virsorter2**

    _To install with bioconda_

    ```Bashconda 
    create -n vs2 -c conda-forge -c bioconda virsorter=2
    conda activate vs2
    ```


    _Download the database (required, will take around 10 min)_

    `virsorter setup -d db -j 4`

4. **DeepHost**
    
    Required for DeepHost
    ```Bash
    pip install cython
    pip install numpy
    pip install karas
    ```

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
#### Input files needed

#### Output


### Tests


### Credits


### License


