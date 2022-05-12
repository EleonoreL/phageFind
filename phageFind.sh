# Variables pour noms/path fichiers
# Input de départ
name="$1"
TBD="$2"
TBD="$3"
threads="$4"
cwd=$(pwd)

# TODO: DOSSIERS POUR FICHIERS
echo "=>Creating other directories for $name"    
mkdir "$name/5-Phages"
mkdir "$name/5-Phages/Hosts"
mkdir "$name/5-Phages/Caracteristics"

#Trouver séquences virales phages
echo "=>Starting to predict phage sequences"
#VirSorter2
echo "=>Identifying phage sequences"
#Only select phages
virsorter run -w "$name"/5-Phages/NOMTEMP.out -i "$name"/3-Coassembly/NOMTEMP.fa -j "$threads" --include-groups "dsDNAphage,ssDNA"
#TODO: sortir statistiques

# Trouver hôte(s)
echo "=>Identifying phage hosts"
cd DeepHost_scripts
python DeepHost.py "$name"/3-Coassembly/CHANGER_Phage_genomes.fa --out "$name"/5-Phages/HostsCHANGER_Output_name.txt --rank species
cd cwd
echo "=>Done with phage prediction!"
