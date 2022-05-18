# Variables pour noms/path fichiers
name="$1"
TBD="$2"
TBD="$3"
threads="$4"

# TODO: DOSSIERS POUR FICHIERS
echo "=>Creating other directories for $name"    
mkdir "$name/3-Coassembly"
mkdir "$name/4-Cartography"

# Co-assemblage
echo "=>Starting co-assembly of all reads"
#TODO: VÉRIFIER SOURCE ET NOMS FICHIERS
megahit -1 "$name"/NOMTEMP.fq -2 "$name"/NOMTEMP.fq -o "$name"/3-Coassembly/NOMTEMP.out > "$name"/3-Coassembly/Coassembly.log 2>&1 # 1 paired-end library
# if biodiversity in sample is very high (ex:soil) : --presets meta-large
# TODO: sortir statistiques? (nb contigs, longueur, etc.)


# Cartographie des jeux de données sur l'assemblage
echo "=>Referencing original datasets in co-assembly"
bowtie2 -x -1 -2 -S -S "$name"/4-Cartography/$name.sam -p "$threads" > "$name"/4-Cartography/Cartography.log 2>&1

echo "=>Done with read assembly and referencing!"

# Appel prochain script
# TODO: régler arguments in
phageFind.sh name TBD TBD threads