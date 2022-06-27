### analysePhageFind
### Author: Éléonore Lemieux
### Date: 2022-05-17
###
###

## Importer les fichiers importants

## Fichier qui donne qualité et longueur contigs
quality <- read.table("quality_summary.tsv", h = TRUE, sep = "\t")
## Sélection des contigs de bonne qualité selon checkv
tri_lowQuality <-
  quality[grep("Low-quality", quality[, 8], invert = TRUE), ]
tri_lowNoQuality <-
  tri_lowQuality[grep("Not-determined", tri_lowQuality[, 8], invert = TRUE), ]
order_tri_lowNoQuality <-
  tri_lowNoQuality[order(tri_lowNoQuality$contig_id), ]

viralScore <- read.table("final-viral-score.tsv", sep = "\t", h = TRUE)
completeness <- read.table("completeness.tsv", sep = "\t", h = TRUE)
bacphlip <-
  read.table("combined.fna.bacphlip", h = TRUE, row.names = NULL)
taxo <- read.csv("genome_by_genome_overview.csv", h = TRUE)
## Tri des contigs de bonne qualité dans autres fichiers
highQual_viralScore <- viralScore
for (i in seq_len(nrow(viralScore))) {
  if ((viralScore[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_viralScore <- highQual_viralScore[-i, ]
  }
}
highQual_viralScore <-
  highQual_viralScore[order(highQual_viralScore$seqname), ]

highQual_complete <- completeness
for (i in seq_len(nrow(completeness))) {
  if ((completeness[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_complete <- highQual_complete[-i, ]
  }
}
highQual_complete <-
  highQual_complete[order(highQual_complete$contig_id), ]

highQual_bacphlip <- bacphlip
for (i in seq_len(nrow(bacphlip))) {
  if ((bacphlip[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_bacphlip <- highQual_bacphlip[-i, ]
  }
}
highQual_bacphlip <-
  highQual_bacphlip[order(highQual_bacphlip[, 1]), ]

##highQual_taxo <- taxo
##for (i in seq_len(nrow(taxo))) {
##  if ((taxo[i,1]%in%order_tri_lowNoQuality[,1])==FALSE){
##    highQual_taxo <- highQual_taxo[-i,]
##  }
##}
##highQual_taxo <- highQual_taxo[order(highQual_taxo[,1]),]


Amox1 <- read.table("Amoxicillin_T12-1_DC13.tsv", t = "\t")
highQual_Amox1 <- Amox1
for (i in seq_len(nrow(Amox1))) {
  if ((Amox1[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_Amox1 <- highQual_Amox1[-i, ]
  }
}
highQual_Amox1 <- highQual_Amox1[order(highQual_Amox1[, 1]), ]

Amox2 <- read.table("Amoxicillin_T12-2_DC14.tsv", t = "\t")
highQual_Amox2 <- Amox2
for (i in seq_len(nrow(Amox2))) {
  if ((Amox2[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_Amox2 <- highQual_Amox2[-i, ]
  }
}
highQual_Amox2 <- highQual_Amox2[order(highQual_Amox2[, 1]), ]

Amox3 <- read.table("Amoxicillin_T12-3_DC15.tsv", t = "\t")
highQual_Amox3 <- Amox3
for (i in seq_len(nrow(Amox3))) {
  if ((Amox3[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_Amox3 <- highQual_Amox3[-i, ]
  }
}
highQual_Amox3 <- highQual_Amox3[order(highQual_Amox3[, 1]), ]

Amox4 <- read.table("Amoxicillin_T12-4_DC16.tsv", t = "\t")
highQual_Amox4 <- Amox4
for (i in seq_len(nrow(Amox4))) {
  if ((Amox4[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_Amox4 <- highQual_Amox4[-i, ]
  }
}
highQual_Amox4 <- highQual_Amox4[order(highQual_Amox4[, 1]), ]

Control1 <- read.table("Control_T12-1_DC01.tsv", sep = "\t")
highQual_Control1 <- Control1
for (i in seq_len(nrow(Control1))) {
  if ((Control1[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_Control1 <- highQual_Control1[-i, ]
  }
}
highQual_Control1 <-
  highQual_Control1[order(highQual_Control1[, 1]), ]

Control2 <- read.table("Control_T12-2_DC02.tsv", sep = "\t")
highQual_Control2 <- Control2
for (i in seq_len(nrow(Control2))) {
  if ((Control2[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_Control2 <- highQual_Control2[-i, ]
  }
}
highQual_Control2 <-
  highQual_Control2[order(highQual_Control2[, 1]), ]

Control3 <- read.table("Control_T12-3_DC03.tsv", sep = "\t")
highQual_Control3 <- Control3
for (i in seq_len(nrow(Control3))) {
  if ((Control3[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_Control3 <- highQual_Control3[-i, ]
  }
}
highQual_Control3 <-
  highQual_Control3[order(highQual_Control3[, 1]), ]


Control4 <- read.table("Control_T12-4_DC04.tsv", sep = "\t")
highQual_Control4 <- Control4
for (i in seq_len(nrow(Control4))) {
  if ((Control4[i, 1] %in% order_tri_lowNoQuality[, 1]) == FALSE) {
    highQual_Control4 <- highQual_Control4[-i,]
  }
}
highQual_Control4 <-
  highQual_Control4[order(highQual_Control4[, 1]), ]

#sélectionner colonnes nécessaires dans fichiers
size <- order_tri_lowNoQuality[, c(1, 2)]
complete <- highQual_complete[, c(1, 5)]
#Nom séquence et type ADN
dna <- highQual_viralScore[, c(1, 5)]
lytic <- matrix(nrow = nrow(highQual_bacphlip), ncol = 2)
colnames(lytic) <- c("contig_id", "Lifestyle")
lytic[, 1] <- highQual_bacphlip[, 1]
for (j in seq_len(nrow(highQual_bacphlip))) {
  #Si le contig est virulent
  if (highQual_bacphlip[j, 2] > highQual_bacphlip[j, 3])
    lytic[j, 2] <- "Virulent"
  else
    lytic[j, 2] <- "Temperate"
}
lytic <- as.data.frame(lytic)

for (i in seq_len(nrow(dna))) {
  if ((dna[i, 1] %in% lytic[, 1]) == FALSE) 
    dna <- dna[-i,]
}

#TODO:automatiser création colonnes selon nb échantillons, traitement et contrôle
nbAmox1 <- highQual_Amox1[, c(1, 3)]
nbAmox2 <- highQual_Amox2[, c(1, 3)]
nbAmox3 <- highQual_Amox3[, c(1, 3)]
nbAmox4 <- highQual_Amox4[, c(1, 3)]
nbTreatment <- matrix(nrow = nrow(nbAmox1), ncol = 2)
nbTreatment[,1] <- nbAmox1[,1]
for (i in seq_len(nrow(nbAmox1))) {
  nbTreatment[i, 2] <-
    paste(nbAmox1[i, 2], nbAmox2[i, 2], nbAmox3[i, 2], nbAmox4[i, 2], sep = ", ")
}
nbTreatment <- as.data.frame(nbTreatment)

nbControl1 <- highQual_Control1[, c(1, 3)]
nbControl2 <- highQual_Control2[, c(1, 3)]
nbControl3 <- highQual_Control3[, c(1, 3)]
nbControl4 <- highQual_Control4[, c(1, 3)]
nbControl <- matrix(nrow = nrow(nbControl1), ncol = 2)
nbControl[,1] <- nbControl1[,1]
for (i in seq_len(nrow(nbControl1))) {
  nbControl[i, 2] <-
    paste(nbControl1[i, 2], nbControl2[i, 2], nbControl3[i, 2], nbControl4[i, 2], sep = ", ")
}
nbControl <- as.data.frame(nbControl)
  
# Assembler dans un tableau
for (i in seq_len(nrow(nbControl))) {
  if ((nbControl[i, 1] %in% lytic[, 1]) == FALSE) {
    nbControl <- nbControl[-i,]
  }
}
for (i in seq_len(nrow(nbControl))) {
  if ((nbControl[i, 1] %in% complete[, 1]) == FALSE) {
    nbControl <- nbControl[-i,]
  }
}

for (i in seq_len(nrow(nbControl))) {
  if ((nbControl[i, 1] %in% dna[, 1]) == FALSE) {
    nbControl <- nbControl[-i,]
  }
}


for (i in seq_len(nrow(nbTreatment))) {
  if ((nbTreatment[i, 1] %in% nbControl[, 1]) == FALSE) {
    nbTreatment <- nbTreatment[-i,]
  }
}


nomsCol <-
  c(
    "contigID",
    "Size",
    "Completeness",
    "ssDNA_dsDNA",
    "Lifestyle",
    "Reads_Control",
    "Reads_Treatment"
  ) #"Taxonomy",Host
table_essai <-
  cbind(#complete[, c(1,2)],
        #dna[, 2],
        #lytic[, 2],
        nbControl[, 2],
        nbTreatment[, 2])


combinee <- cbind(size, complete, dna)
colnames(combinee) <- nomsCol
#row.names(combinee) <- row.names(viralCombined)

# Statistiques de bases

#Tables d'abondance


#Corrélations


# Créer fichiers/objets output