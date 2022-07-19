### phageFind.R
### Author: Eleonore Lemieux
### Date: 2022-07-19
### Version: 1.0
###
###

## Import files
quality <- read.table("quality_summary.tsv", h = TRUE, sep = "\t")
viralScore <-
    read.table("final-viral-score.tsv", sep = "\t", h = TRUE)
completeness <- read.table("completeness.tsv", sep = "\t", h = TRUE)
bacphlip <-
    read.table("combined.fna.bacphlip", h = TRUE, row.names = NULL)
taxo <-
    read.csv("../essai2/genome_by_genome_overview.csv", h = TRUE)
## Files with number of reads per sample
## TODO: adjustable from input, make separate script?
Amox1 <- read.table("Amoxicillin_T12-1_DC13.tsv", t = "\t")
Amox2 <- read.table("Amoxicillin_T12-2_DC14.tsv", t = "\t")
Amox3 <- read.table("Amoxicillin_T12-3_DC15.tsv", t = "\t")
Amox4 <- read.table("Amoxicillin_T12-4_DC16.tsv", t = "\t")

Control1 <- read.table("Control_T12-1_DC01.tsv", sep = "\t")
Control2 <- read.table("Control_T12-2_DC02.tsv", sep = "\t")
Control3 <- read.table("Control_T12-3_DC03.tsv", sep = "\t")
Control4 <- read.table("Control_T12-4_DC04.tsv", sep = "\t")

## Create columns for number of reads, treatment and control
nbAmox1 <- Amox1[order(Amox1$V1), c(1, 3)]
nbAmox2 <- Amox2[order(Amox2$V1), c(1, 3)]
nbAmox3 <- Amox3[order(Amox3$V1), c(1, 3)]
nbAmox4 <- Amox4[order(Amox4$V1), c(1, 3)]
nbTreatment <- matrix(nrow = nrow(nbAmox1), ncol = 2)
nbTreatment[, 1] <- nbAmox1[, 1]
for (i in seq_len(nrow(nbAmox1))) {
    nbTreatment[i, 2] <-
        paste(nbAmox1[i, 2], nbAmox2[i, 2], nbAmox3[i, 2], nbAmox4[i, 2], sep = ", ")
}
nbTreatment <- as.data.frame(nbTreatment)
nbTreatment <- nbTreatment[order(nbTreatment$V1), ]
nbTreatment <- nbTreatment[-1,]

nbControl1 <- Control1[order(Control1$V1), c(1, 3)]
nbControl2 <- Control2[order(Control2$V1), c(1, 3)]
nbControl3 <- Control3[order(Control3$V1), c(1, 3)]
nbControl4 <- Control4[order(Control4$V1), c(1, 3)]
nbControl <- matrix(nrow = nrow(nbControl1), ncol = 2)
nbControl[, 1] <- nbControl1[, 1]
for (i in seq_len(nrow(nbControl1))) {
    nbControl[i, 2] <-
        paste(nbControl1[i, 2], nbControl2[i, 2], nbControl3[i, 2], nbControl4[i, 2], sep = ", ")
}
nbControl <- as.data.frame(nbControl)
nbControl <- nbControl[order(nbControl$V1), ]
nbControl <- nbControl[-1,]

## Taxonomy
## TODO: adjust for input with grep pattern
# Pre selection of matches 
taxo_match <-
    taxo[row.names(taxo[grep('VC', taxo$VC), ]), ]
## Select non-database contigs
taxo_contigs <- taxo_match[row.names(taxo_match[grep('k141', taxo_match$Genome), ]), ]
# Select reference database contigs
taxo_db <-
    taxo_match[row.names(taxo_match[grep('k141', taxo_match$Genome, invert = TRUE), ]), ]
# Cleaning up row numbers
row.names(taxo_db) <- 1:nrow(taxo_db)
row.names(taxo_contigs) <- 1:nrow(taxo_contigs)
## Select identified contigs
taxo_match_VC <- taxo_contigs
# TODO: améliorer efficacité de la boucle, utiliser fonction interne?
for (i in 1:nrow(taxo_contigs))
{
    for (j in 1:nrow(taxo_db))
    {
        # If from identical cluster
        if (taxo_contigs[i, 7] == taxo_db[j, 7])
        {
            # Copy reference taxonomy from reference to contig
            taxo_match_VC[i, 2:4] <- taxo_db[j, 2:4]
        }
    }
}
# Only keep those assigned
taxo_match <-
    taxo_match_VC[row.names(taxo_match_VC[grep('Unassigned', taxo_match_VC, invert = TRUE), ]), ]


## Order dataframes by name of contigs
quality <- quality[order(quality$contig_id), ]
viralScore <- viralScore[order(viralScore$seqname), ]
completeness <- completeness[order(completeness$contig_id), ]
bacphlip <- bacphlip[order(bacphlip$row.names),]

## Select desired columns
size <- quality[, c(1, 2)]
complete <- completeness[, c(1, 5)]
dna <- viralScore[, c(1, 5)]
lytic <- matrix(nrow = nrow(bacphlip), ncol = 2)
colnames(lytic) <- c("contig_id", "Lifestyle")
lytic[, 1] <- bacphlip[, 1]
for (j in seq_len(nrow(bacphlip))) {
    # If contig is Virulent
    if (bacphlip[j, 2] > bacphlip[j, 3])
        lytic[j, 2] <- "Virulent"
    else
        lytic[j, 2] <- "Temperate"
}
lytic <- as.data.frame(lytic)

nomsCol <-
    c(
        "contigID",
        "Size",
        "Completeness",
        "ssDNA_dsDNA",
        "Lifestyle",
        "Reads_Control",
        "Reads_Treatment"
    )

## Select high quality contigs according to checkv
tri_lowQuality <-
    quality[grep("Low-quality", quality[, 8], invert = TRUE), ]
tri_lowNoQuality <-
    tri_lowQuality[grep("Not-determined", tri_lowQuality[, 8], invert = TRUE), ]
order_tri_lowNoQuality <-
    tri_lowNoQuality[order(tri_lowNoQuality$contig_id), ]
order_quality <- quality[order(quality$contig_id), ]

## Sélection des contigs - Non stringent
size_long <- size[row.names(order_quality),]
complete_long <- complete[row.names(order_quality),]
dna_long <- dna[row.names(order_quality),]
lytic_long <- lytic[row.names(order_quality),]
long_nbControl <- nbControl[row.names(order_quality),]
long_nbTreat <- nbTreatment[row.names(order_quality),]
table_long <-
    cbind(size_long,
          complete_long[, 2],
          dna_long[, 2],
          lytic_long[, 2],
          long_nbControl[, 2],
          long_nbTreat[, 2])
colnames(table_long) <- nomsCol
row.names(table_long) <- 1:nrow(table_long)

row_long <- row.names(order_quality)

#write.table(table_long,
#            file = "Mouse_Amox_phageFind_all.tsv",
#            sep = "\t",
#            fileEncoding = "UTF-8")


## Select statistics from high quality contigs
size_court <- size[row.names(order_tri_lowNoQuality),]
complete_court <- complete[row.names(order_tri_lowNoQuality),]
dna_court <- dna[row.names(order_tri_lowNoQuality),]
lytic_court <- lytic[row.names(order_tri_lowNoQuality),]
short_nbControl <- nbControl[row.names(order_tri_lowNoQuality),]
short_nbTreat <- nbTreatment[row.names(order_tri_lowNoQuality),]
table_court <-
    cbind(
        size_court,
        complete_court[, 2],
        dna_court[, 2],
        lytic_court[, 2],
        short_nbControl[, 2],
        short_nbTreat[, 2]
    )
colnames(table_court) <- nomsCol
row.names(table_court) <- 1:nrow(table_court)
#write.table(table_court,
#            file = "Mouse_Amox_phageFind_highQuality.tsv",
#            sep = "\t",
#            fileEncoding = "UTF-8")
