# Variables pour noms/path fichiers


# Co-assemblage
echo "=>Starting co-assembly of all reads"
megahit -1 NOMTEMP.fq -2 NOMTEMP.fq -o NOMTEMP.out  # 1 paired-end library
# if biodiversity in sample is very high (ex:soil) : --presets meta-large
# TODO: sortir statistiques? (nb contigs, longueur, etc.)


# Cartographie des jeux de données sur l'assemblage
echo "=>Referencing original datasets in co-assembly"
bowtie2 -x -1 -2 -S

echo "=>Done with read assembly and referencing!"