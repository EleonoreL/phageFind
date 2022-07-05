### Main workflow - phageFind


configfile: "config.yaml"
# ---- Rules ---- #
rule all:
    input:

rule cleaning:
    input:
    output:
    log: 
    threads:
    message: "=> Decontaminating all reads."
    shell:

rule megahit:
    input:
    output:
    log:
    threads:
    message: "=> Performing coassembly with megahit."
    shell:

rule virsorter2:
    input:
    output:
    log:
    threads:
    message: "=> Finding viral sequences with virsorter2."
    shell:

rule checkv:
    input:
    output:
    log:
    threads:
    message: "=> Performing a quality check on virsorter results with checkv."
    shell:

rule create_index:
    input:
    output:
    log:
    threads:
    message: "=> Creating a bowtie index from the viral sequences."
    shell:
# TODO: COMBINER AVEC PIPE? VOIR SI SE FAIT 
rule sample_indexing:
    input:
    output:
    log:
    threads:
    message: "=> Indexing all cleaned samples with bowtie2."
    shell:
    
rule transform_bam:
    input:
    output:
    log:
    threads:
    message: "=> Compressing the .sam files into .bam."
    shell:

rule bam_sorting:
    input:
    output:
    log:
    threads:
    message: "=> Sorting the .bam files."
    shell:

rule bam_indexing:
    input:
    output:
    log:
    threads:
    message: "=> Indexing the sorted bam files."
    shell:

rule bam_stats:
    input:
    output:
    log:
    threads:
    message: "=> Getting the number of reads of each contig per sample."
    shell:

rule prodigal:
    input:
    output:
    log:
    threads:
    message: "=> Running prodigal."
    shell:

rule gene2genome:
    input:
    output:
    log:
    threads:
    message: "=> Creating the gene-to-genome index for vcontact2."
    shell:

rule vcontact2:
    input:
    output:
    log:
    threads:
    message: "=> Performing taxonomic identification with vconact2."
    shell:

rule bacphlip:
    input:
    output:
    log:
    threads:
    message: "=> Performing lifestyle prediction with bacphlip."
    shell:

rule finalTable:
    input:
    output:
    log:
    threads:
    message: "=> Creating the final table with all important information."
    shell:
    
