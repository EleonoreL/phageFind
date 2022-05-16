## Title: NOM PROJET
 _Author:_ Éléonore Lemieux

 _Lab:_ Antony Vincent, IBIS, Université Laval

### Description
Metagenomics tool for bacteriophage identification and investigation

### Programs and environments to install
1. **Bioconda**

    _Base environment, needed for other installations_

    ```Bash
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh
    conda activate
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge
    ```

2. **Virsorter2**

    _Environment used, detects viral (phage) sequences in metagenomes_

    ```Bash
    conda create -n vs2 -c conda-forge -c bioconda virsorter=2
    conda activate vs2
    ```

    Download the database (required, will take around 10 min): `virsorter setup -d db -j 4`

3. **CheckV**

    _Assesses the quality of single-contig viral genomes, including identification of host contamination for integrated proviruses, estimates completeness for genome fragments, and identifies closed genomes_

    `conda install -c conda-forge -c bioconda checkv`

    `checkv download_database ./`

    ***How to run***
    
     `checkv end_to_end input_file.fna output_directory -t 16`

4. **MEGAHIT**

    _Performs co-assembly_ 
    
    `conda install -c bioconda megahit`


~~5. **DeepHost**~~
** NOT SUPPORTED CURRENTLY **
    
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

If samples come from a host:
- Provide host reference genome \n \t Allows better cleaning of reads

Else:

#### Output


### Tests


### Credits


### License


