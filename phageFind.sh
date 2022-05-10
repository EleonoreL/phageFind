# Variables pour noms/path fichiers

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
cd DeepHost_scripts
python DeepHost.py CHANGER_Phage_genomes.fasta --out CHANGER_Output_name.txt --rank species
