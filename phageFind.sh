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
mkdir "$name/5-Phages/Checkv"
mkdir "$name/5-Phages/Caracteristics"

#Trouver séquences virales phages
echo "=>Starting to predict phage sequences"
#VirSorter2
echo "=>Identifying phage sequences"
#Only select phages
virsorter run -w "$name"/5-Phages/phageSeq.out -i "$name/3-Coassembly/$name.contigs.fa" -j "$threads" --include-groups "dsDNAphage,ssDNA"
# Quality control with checkv
echo "=>Quality control on phage sequence predictions"
checkv end_to_end "$name"/5-Phages/phageSeq.out/final-viral-combined.fa "$name"/5-Phages/Checkv -t "$threads" -d checkv-db-v*

#TODO: sortir statistiques
# Nb de ssDNA
nb_ssDNA=$(grep "ssDNA" $name/5-Phages/phageSeq.out/final-viral-score.tsv)
echo "Number of ssDNA phages: $nb_ssDNA"
# Nb de dsDNA
nb_dsDNA=$(grep "dsDNA" $name/5-Phages/phageSeq.out/final-viral-score.tsv)
echo "Number of dsDNA phages: $nb_dsDNA"
# Nb de high confidence
nb_lowConf=$(grep -v "Low" $name/5-Phages/Checkv/quality_summary.tsv | grep -v "Not-determined"| wc -l)
echo "Number of high confidence contigs: $nb_lowConf"
# Nb de low confidence

# Trouver hôte(s)
#echo "=>Identifying phage hosts"
#cd DeepHost_scripts
#python DeepHost.py "$name"/3-Coassembly/CHANGER_Phage_genomes.fa --out "$name"/5-Phages/HostsCHANGER_Output_name.txt --rank species
#cd cwd
echo "=>Done with phage prediction!"


# Démarrer script R pour création tableau résumé
