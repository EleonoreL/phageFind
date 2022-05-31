# Variables pour noms/path fichiers
name="$1"
R1="$2"
R2="$3"
threads="$4"

# TODO: DOSSIERS POUR FICHIERS
mkdir "$name/3-Coassembly"

# Co-assemblage
echo "=>Starting co-assembly of all reads"
#TODO: VÉRIFIER SOURCE ET NOMS FICHIERS
megahit -1 "$name/$R1".fastq -2 "$name/$R2".fastq -o "$name/3-Coassembly/$name"_assembled.out > "$name"/3-Coassembly/Coassembly.log 2>&1 # 1 paired-end library
# if biodiversity in sample is very high (ex:soil) : --presets meta-large
# TODO: sortir statistiques? (nb contigs, longueur, etc.)
# TODO: supprimer contigs intermédiaires?


# Cartographie des jeux de données sur l'assemblage
echo "=>Referencing original datasets in co-assembly"
bowtie2 -x -1 -2 -S -S "$name"/4-Cartography/$name.sam -p "$threads" > "$name"/4-Cartography/Cartography.log 2>&1

echo "=>Done with read assembly and referencing!"

# Appel prochain script
# TODO: régler arguments in
phageFind.sh name TBD TBD threads