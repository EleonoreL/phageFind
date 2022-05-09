name="$1"
R1="$2"
R2="$3"
threads="$4"

    
	mkdir "$name"
	mkdir "$name/0-Deduplication"
	mkdir "$name/1-Filtration"
	mkdir "$name/2-Decontamination"
	mkdir "$name/3-ISMiner"
	mkdir "$name/4-ARGMiner"

	echo "=>Starting to preprocess reads for $name"

	echo "=>Deduplicating reads"
	
	/home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Lucie/Westco/software/bbmap/clumpify.sh in="$R1" in2="$R2" out="$name/0-Deduplication/$name"_deduplicated_R1.fastq out2="$name/0-Deduplication/$name"_deduplicated_R2.fastq dedupe=t optical=t dupedist=2500 -Xmx75g > "$name"/0-Deduplication/Deduplication.log 2>&1

	NumberOfR1_initial=`zcat "$R1" | awk '{s++}END{print s/4}'`
	NumberOfR2_initial=`zcat "$R2" | awk '{s++}END{print s/4}'`	

	NumberOfR1_deduplicated=`awk '{s++}END{print s/4}' "$name/0-Deduplication/$name"_deduplicated_R1.fastq`
	NumberOfR2_deduplicated=`awk '{s++}END{print s/4}' "$name/0-Deduplication/$name"_deduplicated_R2.fastq`

	PercentOfR1_deduplicated=$(echo "scale=2; ($NumberOfR1_deduplicated/$NumberOfR1_initial)*100" | bc -l)
	PercentOfR2_deduplicated=$(echo "scale=2; ($NumberOfR2_deduplicated/$NumberOfR2_initial)*100" | bc -l)

	echo "	-Number of R1 before deduplication: $NumberOfR1_initial"
	echo "	-Number of R2 before deduplication: $NumberOfR2_initial"	
	echo "	-Number of R1 after deduplication: $NumberOfR1_deduplicated ($PercentOfR1_deduplicated)"
	echo "	-Number of R2 after deduplication: $NumberOfR2_deduplicated ($PercentOfR2_deduplicated)"


	echo "=>Filtering reads"

	fastp -w "$threads" -i "$name/0-Deduplication/$name"_deduplicated_R1.fastq -I "$name/0-Deduplication/$name"_deduplicated_R2.fastq -o "$name/1-Filtration/$name"_filtered_R1.fastq -O "$name/1-Filtration/$name"_filtered_R2.fastq --detect_adapter_for_pe -j "$name/1-Filtration/$name".json -h "$name/1-Filtration/$name".html  > "$name"/1-Filtration/Filtration.log 2>&1
	
	NumberOfR1_filtered=` awk '{s++}END{print s/4}' "$name/1-Filtration/$name"_filtered_R1.fastq`
	NumberOfR2_filtered=` awk '{s++}END{print s/4}' "$name/1-Filtration/$name"_filtered_R2.fastq`
	
	PercentOfR1_filtered=$(echo "scale=2; ($NumberOfR1_filtered/$NumberOfR1_deduplicated)*100" | bc -l)
	PercentOfR2_filtered=$(echo "scale=2; ($NumberOfR2_filtered/$NumberOfR2_deduplicated)*100" | bc -l)
		
	echo "	-Number of R1 after filtration: $NumberOfR1_filtered ($PercentOfR1_filtered)"
	echo "	-Number of R2 after filtration: $NumberOfR2_filtered ($PercentOfR2_filtered)"

	echo "=>Decontaminating reads"
	bowtie2 -x /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Lucie/Westco/database/GRCg7b -1 "$name/1-Filtration/$name"_filtered_R1.fastq -2 "$name/1-Filtration/$name"_filtered_R2.fastq -S "$name/2-Decontamination/$name".sam -p "$threads" > "$name"/2-Decontamination/Decontamination.log 2>&1
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
	
	rm "$name/1-Filtration/$name"_filtered_R1.fastq
	rm "$name/1-Filtration/$name"_filtered_R2.fastq
	rm "$name/2-Decontamination/$name".sam
	rm "$name/2-Decontamination/$name"_mapped_unmapped.bam
	rm "$name/2-Decontamination/$name"_unmapped.bam
	rm "$name/2-Decontamination/$name"_unmapped_sorted.bam

	echo "=>Compressing preprocessed reads"

	pigz -p "$threads" "$name/2-Decontamination/$name"_unmapped_R1.fastq
	pigz -p "$threads" "$name/2-Decontamination/$name"_unmapped_R2.fastq
	
	echo "=>Starting ISMiner"
	python3 /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/software/MetaProtMiner.py -1 "$name/2-Decontamination/$name"_unmapped_R1.fastq.gz -2 "$name/2-Decontamination/$name"_unmapped_R2.fastq.gz -D /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/Database/IS_DB/IS.faa -L /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/Database/IS_DB/Length.tsv -S "$name" -T 80 -O "$name/3-ISMiner" -C 90 -A 50

	rm "$name/3-ISMiner/$name.fastq"

        echo "=>Starting ARGMiner"
        python3 /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/software/MetaProtMiner.py -1 "$name/2-Decontamination/$name"_unmapped_R1.fastq.gz -2 "$name/2-Decontamination/$name"_unmapped_R2.fastq.gz -D /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/Database/ARG_DB/ARG.faa -L /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/Database/ARG_DB/Length.tsv -S "$name" -T 80 -O "$name/4-ARGMiner" -C 90 -A 50

	rm "$name/4-ARGMiner/$name.fastq"

	echo "=>Starting MetaProtMiner for GII Introns"
	python3 /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/software/MetaProtMiner.py -1 "$name/2-Decontamination/$name"_unmapped_R1.fastq.gz -2 "$name/2-Decontamination/$name"_unmapped_R2.fastq.gz -D /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/Database/GIIintrons_DB/GII_introns.faa -L /home/ulaval.ca/lugal12/projects/ul-val-prj-def-anvin26/Antony/Metagenomics_IS/Database/GIIintrons_DB/Length.tsv -S "$name" -T 80 -O "$name/5-GIIintrons" -C 90 -A 50

	rm "$name/5-GIIintrons/$name.fastq"




	echo '=>Done!'

