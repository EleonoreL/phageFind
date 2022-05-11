# Variables pour noms/path fichiers
# Input de départ
name="$1"
R1="$2"
R2="$3"
threads="$4"

#Trouver séquences virales phages
echo "=>Starting to predict phage sequences"
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

echo "=>Done with phage prediction!"
