# Co-assemblage
megahit -1 NOMTEMP.fq -2 NOMTEMP.fq -o NOMTEMP.out  # 1 paired-end library
# if biodiversity in sample is very high (ex:soil) : --presets meta-large

# Trouver, identifier séquences phages

#Trouver séquences virales phages
#VirSorter2
#TODO: Vérifier que programme et db sont installés

#Only select phages
virsorter run -w NOMTEMP.out -i NOMTEMP.fa -j 4 --include-groups "dsDNAphage,ssDNA"


# Trouver hôte(s)
