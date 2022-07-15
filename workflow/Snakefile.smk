### Main workflow - phageFind

report: "workflow/report/workflow.rst"

configfile: "config.yaml"

# ---- Rules ---- #
rule all:
    input:

## TODO:Faire un autre fichier snakemake avec sous-règles pour nettoyage
## TODO: Gérer installation des bases de données
## TODO: voir si peut ajouter temps écoulé/sys.time()
## TODO: gérer fichiers temporaires/à supprimer
rule cleaning:
    input:
    output: R1= FILE_R1.fastq.gz, 
    log: 
    threads:
    message: "=> Decontaminating all reads."
    script: "Prepare_data_dedup.sh"
    shell:

rule megahit:
    input: #rules.cleaning.output
    output: "{project}/3-Coassembly/TBD"
    log:  "{project}/3-Coassembly/Coassembly.log"
    threads: {threads}
    message: "=> Performing coassembly with megahit."
    shell: "megahit -1 INPUT1 -2 INPUT2 -o {output} > {log} 2>&1"
    #megahit -1 "$name/$R1".fastq -2 "$name/$R2".fastq -o {output}

rule virsorter2:
    input: "{project}/3-Coassembly/{project}.contigs.fa"
    output: 
            boundary="{project}/5-Phages/phageSeq.out/final-viral-boundary.tsv", 
            score="{project}/5-Phages/phageSeq.out/final-viral-score.tsv",
            virsort_fa="{project}/5-Phages/phageSeq.out/final-viral-combined.fa"
    log: "{project}/5-Phages/phageSeq.out/virsorter.log"
    threads: {threads}
    message: "=> Finding viral sequences with virsorter2."
    shell: "virsorter run -w {project}/5-Phages/phageSeq.out -i {input} -j {threads} --include-groups "dsDNAphage,ssDNA" > {log} 2>&1"

rule checkv:
    input: rules.virsorter2.output.virsort_fa
    output: 
            quality="{project}/5-Pages/Checkv/quality_summary.tsv", 
            complete="{project}/5-Pages/Checkv/completeness.tsv", 
            conta="{project}/5-Pages/Checkv/contamination.tsv", 
            comp_gen="{project}/5-Pages/Checkv/complete_genomes.tsv",
            provir="{project}/5-Phages/Checkv/proviruses.fna",
            vir_checkv="{project}/5-Phages/Checkv/viruses.fna",
            combined="{project}/5-Phages/Checkv/combined.fna",
    log: "{project}/5-Phages/Checkv/checkv.log"
    threads: {threads}
    message: "=> Performing a quality check on virsorter results with checkv."
    run: 
        shell("checkv end_to_end {input} {project}/5-Phages/Checkv -t {threads} -d checkv-db-v* > {log} 2>&1")
        shell("cat output.provir output.vir_checkv > output.combined")

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
    
