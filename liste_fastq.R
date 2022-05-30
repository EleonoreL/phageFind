R1 <- matrix(nrow=8, ncol=1, data=c("~/essai/2-Decontamination/Control_T12-1_DC01_unmapped_R1.fastq",
                                    "~/essai/2-Decontamination/Control_T12-2_DC02_unmapped_R1.fastq",
                                    "~/essai/2-Decontamination/Control_T12-3_DC03_unmapped_R1.fastq",
                                    "~/essai/2-Decontamination/Control_T12-4_DC04_unmapped_R1.fastq",
                                    "~/essai/2-Decontamination/Amoxicillin_T12-1_DC13_unmapped_R1.fastq",
                                    "~/essai/2-Decontamination/Amoxicillin_T12-2_DC14_unmapped_R1.fastq",
                                    "~/essai/2-Decontamination/Amoxicillin_T12-3_DC15_unmapped_R1.fastq",
                                    "~/essai/2-Decontamination/Amoxicillin_T12-4_DC16_unmapped_R1.fastq"))
R2 <- matrix(nrow=8, ncol=1, data=c("~/essai/2-Decontamination/Control_T12-1_DC01_unmapped_R2.fastq",
                                    "~/essai/2-Decontamination/Control_T12-2_DC02_unmapped_R2.fastq",
                                    "~/essai/2-Decontamination/Control_T12-3_DC03_unmapped_R2.fastq",
                                    "~/essai/2-Decontamination/Control_T12-4_DC04_unmapped_R2.fastq",
                                    "~/essai/2-Decontamination/Amoxicillin_T12-1_DC13_unmapped_R2.fastq",
                                    "~/essai/2-Decontamination/Amoxicillin_T12-2_DC14_unmapped_R2.fastq",
                                    "~/essai/2-Decontamination/Amoxicillin_T12-3_DC15_unmapped_R2.fastq",
                                    "~/essai/2-Decontamination/Amoxicillin_T12-4_DC16_unmapped_R2.fastq"))
write.csv(R1, file = "essai_R1.csv",fileEncoding = "UTF-8")
write.csv(R2, file = "essai_R2.csv",fileEncoding = "UTF-8")
