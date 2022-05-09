# Variables pour noms/path fichiers


# Co-assemblage
echo "=>Co-assembling all reads"
megahit -1 NOMTEMP.fq -2 NOMTEMP.fq -o NOMTEMP.out  # 1 paired-end library
# if biodiversity in sample is very high (ex:soil) : --presets meta-large
# TODO: sortir statistiques? (nb contigs, longueur, etc.)

# Trouver, identifier séquences phages

#Trouver séquences virales phages
#VirSorter2
echo "=>Identifying phage sequences"
#TODO: Vérifier que programme et db sont installés
if(Variables){resultats}
#Only select phages
virsorter run -w NOMTEMP.out -i NOMTEMP.fa -j 4 --include-groups "dsDNAphage,ssDNA"
#TODO: sortir statistiques

# Trouver hôte(s)
echo "=>Identifying phage hosts"
