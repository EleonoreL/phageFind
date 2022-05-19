### analysePhageFind
### Author: Éléonore Lemieux
### Date: 2022-05-17
###
###

#TODO: ajout path, imput utilisateur

#Importer fichiers résultats
viralScore <- read.table("final-viral-score.tsv", sep = "\t", 
                         h=TRUE, row.names = 1)
viralCombined <- read.table("final-viral-combined.tsv", h=TRUE, 
                            sep = "\t", row.names = 1)
completeness <- read.table("completeness.tsv", sep = "\t", h=TRUE,
                           row.names = 1)
hostFile <- read.table("exemple.tsv", sep = "\t", h=TRUE,
                       row.names = 1)
#sélectionner colonnes nécessaires dans fichiers
size <- viralScore[,"TBD"]
complete <- completeness[, "TBD"]
dna <- viralScore[, "TBD"]


# Assembler dans un tableau
nomsCol <- c("contigID","Size","Completeness","ssDNA_dsDNA","Taxonomy","Host","Lysogeny", "Reads_per_dataset")

base <- data.frame()
colnames(base) <- nomsCol
row.names(base) <- row.names(viralCombined)


# Statistiques de bases

#Tables d'abondance


#Corrélations


# Créer fichiers/objets output