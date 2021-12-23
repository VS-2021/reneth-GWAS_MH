#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=36:00:00
#SBATCH --mem=30g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=haasx092@umn.edu
#SBATCH -p amdsmall
#SBATCH --account=jkimball
#SBATCH -o run_bwa_ItascaC20.out
#SBATCH -e run_bwa_ItascaC20.err

cd /scratch.global/haasx092/reneth_gwas

module load bwa
module load samtools

FASTA='/home/jkimball/shared/WR_Annotation/NCBI_submission/zizania_palustris_13Nov2018_okGsv_renamedNCBI2.fasta'

# FASTA must be indexed first
bwa index $FASTA

# Here, I am choosing to write the sorted BAM files to my directory under Jenny's account rather than the scratch drive, but BAM files are also intermediate files
# Technically, the BAM files could be written to the scratch directory since they can be regenerated by running this script again
# After you generate the VCF files, you don't really need the BAM files again
for i in $(cat ItascaC20_samples.txt); do
bwa mem -t 32 $FASTA ${i}/${i}_R1_trimmed.fq  ${i}/${i}_R2_trimmed.fq 2> ${i}/${i}_bwa.err | samtools sort -o ${i}/${i}_sorted.bam 2> ${i}/${i}_samtools_sort.err;
done
