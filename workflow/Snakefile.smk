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
    input:#  output de netttoyage
    output:
    log:
    threads:
    message: "=> Creating a bowtie index from the viral sequences."
    run: 
        shell("bowtie2-build rules.checkv.output.combined database-{project}")
        # Faire boucle? voir
        shell("bowtie2 -x database-{project} -1 SAMPLE_unmapped_R1.fastq.gz **OUTPUT DE NETTOYAGE_R1** -2 SAMPLE_unmapped_R2.fastq.gz **OUTPUT DE NETTOYAGE R2** -S {project}/4-Mapping/NAME.sam -p {threads}")
# TODO: COMBINER AVEC PIPE? VOIR SI SE FAIT 
rule sample_indexing:
    input: 
    output:
    log:
    threads:
    message: "=> Indexing all cleaned samples with bowtie2."
    shell:
    ## Commandes par A.Vincent
    #samtools view -@ 30 -bS test.sam -o test.bam                     
    #samtools sort -@ 30 test.bam -o test_sorted.bam                  
    #samtools index -@ 30 test_sorted.bam
    #samtools idxstats test_sorted.bam > test.tsv
    
rule transform_bam:
    input:
    output: 
        unsorted="{project}/4-Mapping/NAME.bam",
        sorted_bam="{project}/4-Mapping/NAME_sorted.bam"
    log: "{project}/4-Mapping/bam_sorting.log"
    threads:
    message: "=> Compressing the sam files into bam and sorting them."
    run: 
        shell("samtools view -@ {threads} -bS {input} -o ouput.unsorted > {log} 2>&1")
        shell("samtools sort -@ {threads} output.unsorted -o output.sorted_bam > {log} 2>&1")

rule bam_stats:
    input: rules.transform_bam.output.sorted_bam
    output: "{project}/4-Mapping/NAMES.tsv"
    log: "{project}/4-Mapping/bam_stats.log"
    threads:
    message: "=> Getting the number of reads of each contig per sample."
    run: 
        shell("samtools index -@ {threads} {input} > {log} 2>&1")
        shell("samtools idxstats {input} > {output}")

rule prodigal:
    input: rules.checkv.output.combined
    output: 
        genes_out="{project}/6-Prodigal/{project}_output.genes",
        proteins_out="{project}/6-Prodigal/proteins_{project}.faa",
        poten_genes="{project}/6-Prodigal/{project}_potential_genes.txt"
    log: "{project}/6-Prodigal/prodigal.log"
    threads:
    message: "=> Running prodigal."
    shell: "prodigal -i {input} -o output.genes_out -a output.proteins_out -p meta -s output.poten_genes > {log} 2>&1"

rule gene2genome:
    input: rules.prodigal.output.proteins_out
    output: "{project}/5-Phages/Taxonomy/{project}_gene2genome.csv"
    log: "{project}/5-Phages/Taxonomy/gene2genome.log"
    threads:
    message: "=> Creating the gene-to-genome index for vcontact2."
    shell: "vcontact2_gene2genome -p rules.prodigal.output.proteins_out -o {output} -s 'Prodigal-FAA' > {log} 2>&1"

rule vcontact2:
    input: rules.prodigal.output.proteins_out, rules.gene2genome.output
    output: "{project}/5-Phages/Taxonomy/genome_by_genome_overview.csv"
    log: "{project}/5-Phages/Taxonomy/vcontact.log"
    threads:
    message: "=> Performing taxonomic identification with vContact2."
    shell: "vcontact2 --raw-proteins rules.prodigal.output.proteins_out -t {threads} --rel-mode 'Diamond' --proteins-fp rules.gene2genome.output -f -o {project}/5-Phages/Taxonomy/ > {log} 2>&1"

rule bacphlip:
    input: rules.checkv.output.combined
    output: "{project}/5-Phages/Lifestyle/combined.fna.bacphlip" # TODO: vérifier si doit mettre dans ligne de commande le déplacement
    log: "{project}/5-Phages/Lifestyle/bacphlip.log"
    threads:
    message: "=> Performing lifestyle prediction with bacphlip."
    shell: "bacphlip -i {input} --multi_fasta -f --local_hmmsearch ***PATH_TO_HMMSEARCH*** > {log} 2>&1" 

rule finalTable:
    input: 
        taxo="{project}/7-Taxonomy/genome_by_genome_overview.csv",
        rules.checkv.output.quality,
        rules.checkv.output.complete,
        rules.bacphlip.output,
        rules.bam_stats.output        
    output:
    log:
    threads:
    message: "=> Creating the final table with all important information."
    shell:
    
