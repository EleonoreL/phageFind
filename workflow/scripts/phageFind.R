### analysePhageFind
### Author: Éléonore Lemieux
### Date: 2022-05-17
###
###
setwd("../../Desktop/phageFind/test_mouse/")
## Importer les fichiers importants

## Fichier qui donne qualité et longueur contigs
quality <- read.table("quality_summary.tsv", h = TRUE, sep = "\t")

viralScore <-
    read.table("final-viral-score.tsv", sep = "\t", h = TRUE)
completeness <- read.table("completeness.tsv", sep = "\t", h = TRUE)
bacphlip <-
    read.table("combined.fna.bacphlip", h = TRUE, row.names = NULL)
taxo <- read.csv("../essai2/genome_by_genome_overview.csv", h = TRUE)

Amox1 <- read.table("Amoxicillin_T12-1_DC13.tsv", t = "\t")
Amox2 <- read.table("Amoxicillin_T12-2_DC14.tsv", t = "\t")
Amox3 <- read.table("Amoxicillin_T12-3_DC15.tsv", t = "\t")
Amox4 <- read.table("Amoxicillin_T12-4_DC16.tsv", t = "\t")

Control1 <- read.table("Control_T12-1_DC01.tsv", sep = "\t")
Control2 <- read.table("Control_T12-2_DC02.tsv", sep = "\t")
Control3 <- read.table("Control_T12-3_DC03.tsv", sep = "\t")
Control4 <- read.table("Control_T12-4_DC04.tsv", sep = "\t")

## Faire tableau entier, pas stringent
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
nbTreatment <- nbTreatment[order(nbTreatment$V1),]
nbTreatment <- nbTreatment[-1, ]

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
nbControl <- nbControl[order(nbControl$V1),]
nbControl <- nbControl[-1, ]

# Taxonomie
# Sélectionner les contigs des échantillons
taxo_contigs <- taxo[row.names(taxo[grep('k141', taxo$Genome),]),]
# Sélectionner les contigs de la BD de référence
taxo_db <- taxo[row.names(taxo[grep('k141', taxo$Genome, invert = TRUE),]),]
# Sélectionner les contigs ayant un match
taxo_contig_match <- taxo_contigs[row.names(taxo_contigs[grep('VC', taxo_contigs$VC),]),]
taxo_db_match <- taxo_db[row.names(taxo_db[grep('VC', taxo_db$VC),]),]
#Nettoyage noms rangées
row.names(taxo_db_match) <- seq_len(nrow(taxo_db_match))
row.names(taxo_contig_match) <- seq_len(nrow(taxo_contig_match))
## Faire correspondre db et échantillons
taxo_match_VC <- taxo_contig_match
# TODO: améliorer efficacité de la boucle
# Pour chaque rangée du tableau d'échantillons
for (i in 1:nrow(taxo_contig_match)) {
    # Pour chaque rangée du tableau db
    for (j in 1:nrow(taxo_db)) {
        # Si leur VC est identique
        if (taxo_contig_match[i, 7] == taxo_db[j, 7]) {
            # Mettre taxonomie de référence dans tableau d'échantillons
            taxo_match_VC[i, 2:4] <- taxo_db[j, 2:4]
        }
    }
}

# Conserver que ceux assignés
taxo_match <- taxo_match_VC[row.names(taxo_match_VC[grep('Unassigned', taxo_match_VC, invert = TRUE),]),]

# Sélectionner pour tableau stringent


# Ordonner noms contigs
quality <- quality[order(quality$contig_id),]
viralScore <- viralScore[order(viralScore$seqname),]
completeness <- completeness[order(completeness$contig_id),]
bacphlip <- bacphlip[order(bacphlip$row.names), ]

#sélectionner colonnes nécessaires dans fichiers
size <- quality[, c(1, 2)]
complete <- completeness[, c(1, 5)]
#Nom séquence et type ADN
dna <- viralScore[, c(1, 5)]
lytic <- matrix(nrow = nrow(bacphlip), ncol = 2)
colnames(lytic) <- c("contig_id", "Lifestyle")
lytic[, 1] <- bacphlip[, 1]
for (j in seq_len(nrow(bacphlip))) {
    #Si le contig est virulent
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

## Sélection des contigs de bonne qualité selon checkv
tri_lowQuality <-
    quality[grep("Low-quality", quality[, 8], invert = TRUE),]
tri_lowNoQuality <-
    tri_lowQuality[grep("Not-determined", tri_lowQuality[, 8], invert = TRUE),]
order_tri_lowNoQuality <-
    tri_lowNoQuality[order(tri_lowNoQuality$contig_id),]
order_quality <- quality[order(quality$contig_id),]

## Sélection des contigs - Non stringent
size_long <- size[row.names(order_quality), ]
complete_long <- complete[row.names(order_quality), ]
dna_long <- dna[row.names(order_quality), ]
lytic_long <- lytic[row.names(order_quality), ]
long_nbControl <- nbControl[row.names(order_quality), ]
long_nbTreat <- nbTreatment[row.names(order_quality), ]
table_long <-
    cbind(
        size_long,
        complete_long[, 2],
        dna_long[, 2],
        lytic_long[, 2],
        long_nbControl[, 2],
        long_nbTreat[, 2]
    )
colnames(table_long) <- nomsCol
row.names(table_long) <- 1:nrow(table_long)

row_long <- row.names(order_quality)

#write.table(table_long,
#            file = "Mouse_Amox_phageFind_all.tsv",
#            sep = "\t",
#            fileEncoding = "UTF-8")


## Sélection des contigs de haute qualité - Stringent
size_court <- size[row.names(order_tri_lowNoQuality), ]
complete_court <- complete[row.names(order_tri_lowNoQuality), ]
dna_court <- dna[row.names(order_tri_lowNoQuality), ]
lytic_court <- lytic[row.names(order_tri_lowNoQuality), ]
short_nbControl <- nbControl[row.names(order_tri_lowNoQuality), ]
short_nbTreat <- nbTreatment[row.names(order_tri_lowNoQuality), ]
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

row_court <- row.names(order_tri_lowNoQuality)

## Générer moyennes pour traitement

# Enlever row inutile
nbAmox1_clean <- nbAmox1[-1,]
nbAmox2_clean <- nbAmox2[-1,]
nbAmox3_clean <- nbAmox3[-1,]
nbAmox4_clean <- nbAmox4[-1,]
Treat_court <-
    c(nbAmox1_clean[row_court, 2],
      nbAmox2_clean[row_court, 2],
      nbAmox3_clean[row_court, 2],
      nbAmox4_clean[row_court, 2])
mean_Treat_court <- data.frame()
for (i in seq(1, length(Treat_court), 4)) {
    temp <-
        c(Treat_court[i], Treat_court[i + 1], Treat_court[i + 2], Treat_court[i +
                                                                                  3])
    temp_m <- mean(temp)
    mean_Treat_court <- rbind(mean_Treat_court, temp_m)
}


## Générer moyennes pour contrôle
# Enlever row inutile
nbCont1_clean <- nbControl1[-1,]
nbCont2_clean <- nbControl2[-1,]
nbCont3_clean <- nbControl3[-1,]
nbCont4_clean <- nbControl4[-1,]
Control_court <-
    c(nbCont1_clean[row_court, 2],
      nbCont2_clean[row_court, 2],
      nbCont3_clean[row_court, 2],
      nbCont4_clean[row_court, 2])
mean_Cont_court <- data.frame()
for (i in seq(1, length(Control_court), 4)) {
    temp <-
        c(Control_court[i], Control_court[i + 1], Control_court[i + 2], Control_court[i +
                                                                                          3])
    temp_m <- mean(temp)
    mean_Cont_court <- rbind(mean_Cont_court, temp_m)
}

diff_mean <- mean_Treat_court - mean_Cont_court
ratio_mean <- mean_Treat_court/mean_Cont_court









#Treat <- c(nbAmox1$V3,nbAmox2$V3, nbAmox3$V3, nbAmox4$V3)
Treat_court <-
    c(nbAmox1[row_court, 2], nbAmox2[row_court, 2], nbAmox3[row_court, 2], nbAmox4[row_court, 2])
mean_Treat_court <- data.frame()
for (i in seq(1, length(Treat_court), 4)) {
    temp <-
        c(Treat_court[i], Treat_court[i + 1], Treat_court[i + 2], Treat_court[i +
                                                                                  3])
    temp_m <- mean(temp)
    mean_Treat_court <- rbind(mean_Treat_court, temp_m)
}

## Générer moyennes pour contrôle
Control_court <-
    c(nbControl1[row_court, 2], nbControl2[row_court, 2], nbControl3[row_court, 2], nbControl4[row_court, 2])
mean_Cont_court <- data.frame()
for (i in seq(1, length(Control_court), 4)) {
    temp <-
        c(Control_court[i],
          Control_court[i + 1],
          Control_court[i + 2],
          Control_court[i + 3])
    temp_m <- mean(temp)
    mean_Cont_court <- rbind(mean_Cont_court, temp_m)
}
## Faire comparaison entre contrôle et traitement
## TODO: Peut ajuster selon paramètre
comp_means <- c()
for (n in 1:nrow(mean_Cont_court)) {
    if (mean_Treat_court[n, 1] > mean_Cont_court[n, 1]) {
        comp_means <- c(comp_means, "Higher")
    }
    else if (mean_Treat_court[n, 1] < mean_Cont_court[n, 1]) {
        comp_means <- c(comp_means, "Lower")
    }
    else {
        comp_means <- c(comp_means, "Equivalent")
    }
    
}
comp_means <- as.data.frame(comp_means)
colnames(comp_means) <- "Effect_treatment"

table_court <- cbind(table_court, comp_means)
#write.table(table_court,
#            file = "Mouse_Amox_phageFind_highQuality.tsv",
#            sep = "\t",
#            fileEncoding = "UTF-8")

table_long <- matrix(nrow = nrow(nbControl))
#table_long <- cbind(size, complete[,2])
#table_long <- cbind(table_long, dna[,2])
# setdiff(nomsContigs, lytic[,1]): "k141_189243||full_1"
#for (i in length(nrow(lytic))) {
#  if (lytic[i,1]%in%dna == FALSE)
#    lytic <- lytic[-i,]
#}
table_long <-
    cbind(size, complete[, 2], dna[, 2], lytic[, 2], nbControl[, 2], nbTreatment[, 2])
colnames(table_long) <- nomsCol
row.names(table_long) <- seq_len(nrow(table_long))
#write.table(table_long,file= "phageFind_long.tsv", sep="\t", fileEncoding = "UTF-8")

# Statistiques de bases

#Tables d'abondance


#Corrélations


# Créer fichiers/objets output
