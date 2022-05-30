# Input de départ
name="$1"
R1="$2"
R2="$3"
threads="$4"

# Création des dossiers
	echo "=>Creating directories for $name"    
	mkdir "$name"
	mkdir "$name/0-Deduplication"
	mkdir "$name/1-Filtration"
	mkdir "$name/2-Decontamination"

	echo "=>Starting to preprocess reads"

# Enlever deduplication optique avec clumpify
	echo "=>Deduplicating reads"
	# Fichiers input en fastq.gz
	~/phageFind/bbmap/clumpify.sh in="$R1" in2="$R2" out="$name/0-Deduplication/$name"_deduplicated_R1.fastq out2="$name/0-Deduplication/$name"_deduplicated_R2.fastq dedupe=t optical=t dupedist=2500 -Xmx75g > "$name"/0-Deduplication/Deduplication.log 2>&1

# Nombre de reads
	NumberOfR1_initial=`zcat "$R1" | awk '{s++}END{print s/4}'`
	NumberOfR2_initial=`zcat "$R2" | awk '{s++}END{print s/4}'`	

	NumberOfR1_deduplicated=`awk '{s++}END{print s/4}' "$name/0-Deduplication/$name"_deduplicated_R1.fastq`
	NumberOfR2_deduplicated=`awk '{s++}END{print s/4}' "$name/0-Deduplication/$name"_deduplicated_R2.fastq`

	PercentOfR1_deduplicated=$(echo "scale=2; ($NumberOfR1_deduplicated/$NumberOfR1_initial)*100" | bc -l)
	PercentOfR2_deduplicated=$(echo "scale=2; ($NumberOfR2_deduplicated/$NumberOfR2_initial)*100" | bc -l)
#Vérifier que nettoyage donne resultats corrects (pas majorité enlevé)
	echo "	-Number of R1 before deduplication: $NumberOfR1_initial"
	echo "	-Number of R2 before deduplication: $NumberOfR2_initial"	
	echo "	-Number of R1 after deduplication: $NumberOfR1_deduplicated ($PercentOfR1_deduplicated)"
	echo "	-Number of R2 after deduplication: $NumberOfR2_deduplicated ($PercentOfR2_deduplicated)"

#Filtration avec fastp
	echo "=>Filtering reads"

	fastp -w "$threads" -i "$name/0-Deduplication/$name"_deduplicated_R1.fastq -I "$name/0-Deduplication/$name"_deduplicated_R2.fastq -o "$name/1-Filtration/$name"_filtered_R1.fastq -O "$name/1-Filtration/$name"_filtered_R2.fastq --detect_adapter_for_pe -j "$name/1-Filtration/$name".json -h "$name/1-Filtration/$name".html  > "$name"/1-Filtration/Filtration.log 2>&1
	
	NumberOfR1_filtered=` awk '{s++}END{print s/4}' "$name/1-Filtration/$name"_filtered_R1.fastq`
	NumberOfR2_filtered=` awk '{s++}END{print s/4}' "$name/1-Filtration/$name"_filtered_R2.fastq`
	
	PercentOfR1_filtered=$(echo "scale=2; ($NumberOfR1_filtered/$NumberOfR1_deduplicated)*100" | bc -l)
	PercentOfR2_filtered=$(echo "scale=2; ($NumberOfR2_filtered/$NumberOfR2_deduplicated)*100" | bc -l)
		
	echo "	-Number of R1 after filtration: $NumberOfR1_filtered ($PercentOfR1_filtered)"
	echo "	-Number of R2 after filtration: $NumberOfR2_filtered ($PercentOfR2_filtered)"

#Décontamination avec bowtie2
	echo "=>Decontaminating reads"
	#TODO: SI VARIABLE D'ENTRÉE EST VIDE/FAUSSE, SKIP BOWTIE ET SAMTOOLS
	if(VARIABLE){ACTION}
	#TODO: CHANGER PATH DE RÉFÉRENCE POUR VARIABLE D'ENTRÉE
	bowtie2 -x /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Lucie/Westco/database/GRCg7b -1 "$name/1-Filtration/$name"_filtered_R1.fastq -2 "$name/1-Filtration/$name"_filtered_R2.fastq -S "$name/2-Decontamination/$name".sam -p "$threads" > "$name"/2-Decontamination/Decontamination.log 2>&1

#Réarrangement et gestion avec samtools
	samtools view -@ "$threads" -bS "$name/2-Decontamination/$name".sam -o "$name/2-Decontamination/$name"_mapped_unmapped.bam > "$name"/2-Decontamination/Decontamination.log 2>&1
	samtools view -@ "$threads" -b -f 12 -F 256 "$name/2-Decontamination/$name"_mapped_unmapped.bam -o "$name/2-Decontamination/$name"_unmapped.bam > "$name"/2-Decontamination/Decontamination.log 2>&1
	samtools sort -@ "$threads" -n "$name/2-Decontamination/$name"_unmapped.bam -o "$name/2-Decontamination/$name"_unmapped_sorted.bam > "$name"/2-Decontamination/Decontamination.log 2>&1
	samtools fastq -@ "$threads" -1 "$name/2-Decontamination/$name"_unmapped_R1.fastq -2 "$name/2-Decontamination/$name"_unmapped_R2.fastq "$name/2-Decontamination/$name"_unmapped_sorted.bam > "$name"/2-Decontamination/Decontamination.log 2>&1

	
	NumberOfR1_decontaminated=` awk '{s++}END{print s/4}' "$name/2-Decontamination/$name"_unmapped_R1.fastq`
	NumberOfR2_decontaminated=` awk '{s++}END{print s/4}' "$name/2-Decontamination/$name"_unmapped_R2.fastq`
	
	PercentOfR1_decontaminated=$(echo "scale=2; ($NumberOfR1_decontaminated/$NumberOfR1_filtered)*100" | bc -l)
	PercentOfR2_decontaminated=$(echo "scale=2; ($NumberOfR2_decontaminated/$NumberOfR2_filtered)*100" | bc -l)

	echo "	-Number of R1 after host removal: $NumberOfR1_decontaminated ($PercentOfR1_decontaminated)"
	echo "	-Number of R2 after host removal: $NumberOfR2_decontaminated ($PercentOfR2_decontaminated)"
	
	echo "=>Removing intermediate files"

#Enlever fichiers inutiles	
	rm "$name/1-Filtration/$name"_filtered_R1.fastq
	rm "$name/1-Filtration/$name"_filtered_R2.fastq
	rm "$name/2-Decontamination/$name".sam
	rm "$name/2-Decontamination/$name"_mapped_unmapped.bam
	rm "$name/2-Decontamination/$name"_unmapped.bam
	rm "$name/2-Decontamination/$name"_unmapped_sorted.bam

	echo "=>Compressing preprocessed reads"

#Recompression des fichiers fastq
	pigz -p "$threads" "$name/2-Decontamination/$name"_unmapped_R1.fastq
	pigz -p "$threads" "$name/2-Decontamination/$name"_unmapped_R2.fastq
	
	echo '=>Done with reads preprocessing!'

	echo "=>Creating assembly directories for $name"    
	mkdir "$name/3-Coassembly"
	mkdir "$name/4-Cartography"

	#Noter ordre concaténation dans fichiers texte
	ls "$name/2-Decontamination/"*R1.fastq.gz > "$name/3-Coassembly/$name"_R1_order.txt
	ls "$name/2-Decontamination/"*R2.fastq.gz > "$name/3-Coassembly/$name"_R2_order.txt

	# concaténer les R1
	zcat "$name/2-Decontamination/"*R1.fastq.gz > "$name/3-Coassembly/$name"_R1.fastq
	#concaténer les R2
	zcat "$name/2-Decontamination/"*R2.fastq.gz > "$name/3-Coassembly/$name"_R2.fastq

	# Décomprimer fichiers fastq.gz
	# Créer fichier liste fichiers, format csv

# Appel prochain script
# TODO: régler arguments in, doivent être fastq
	Assembly.sh name "$name/3-Coassembly/$name"_R1.fastq.gz "$name/3-Coassembly/$name"_R2.fastq.gz threads