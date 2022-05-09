# Trouver, identifier séquences phages

#Trouver séquences virales phages
#VirSorter2
#TODO: Vérifier que programme et db sont installés

#Only select phages
virsorter run -w NOMTEMP.out -i NOMTEMP.fa -j 4 --include-groups "dsDNAphage,ssDNA"


# Trouver hôte(s)
