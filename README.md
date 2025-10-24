# Nextflow-RNASeq
## หัวข้อ
1. [บทนำ](#1-บทนำ)
2. [การใช้งาน Nextflow-Annotations](#2-การใช้งาน-Nextflow-Annotations)
3. [การเตรียมเครื่องมือและข้อมูลสำหรับ Nextflow-Annotations](#3-การเตรียมเครื่องมือและข้อมูลสำหรับ-Nextflow-Annotations)
4. [รายละเอียดขั้นตอนใน Nextflow-Annotations](#4-รายละเอียดขั้นตอนใน-Nextflow-Annotations)
5. [การปรับแต่งการ Annotations ใน VEP](#5-การปรับแต่งการ-Annotations-ใน-VEP)
6. [Output](#6-Output)
## For run single-end
```bash
nextflow run -profile gb main.nf \
    --input data-single \
    --fasta /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.fa  \
    --gtf /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.1.gene.gtf \
    --reads_type single-end \
    --multimap 1 \
    --unmaped Within \
    --overhang 100 \
    --conditions Condition \
    --contrast ESR_vs_Fi \
    --padj 0.05 \
    --lfc 1.0 \
    --output output \
```
## For run paired-end  
```bash
nextflow run -profile gb main.nf \
    --input data-paired \
    --fasta /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.fa  \
    --gtf /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.1.gene.gtf \
    --reads_type paired-end \
    --multimap 1 \
    --unmaped Within \
    --overhang 100 \
    --conditions Condition \
    --contrast ESR_vs_Fi \
    --padj 0.05 \
    --lfc 1.0 \
    --output output \
```

## For run meta Data
```bash
nextflow run -profile gb main.nf \
    --fastq data \
    --input /nbt_main/home/lattapol/nextflow-RNAseq/data/aha2.csv \
    --fasta /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.fa  \
    --gtf /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.1.gene.gtf \
    --reads_type csv \
    --multimap 1 \
    --unmaped Within \
    --overhang 100 \
    --conditions con3 \
    --contrast ESR_vs_Fi \
    --padj 0.05 \
    --lfc 1.0 \
    --output results \
```
## 6. Output
### ภาพรวม Output
```bash
Annotations
└── ANN_snpEff
     ├── {samples}.ann.vcf.gz 
     ├── {samples}_summary.genes.txt       
     └── {samples}_summary.html
```

```bash
Annotations_custom
├── BuildCustomDB
│    ├──snpeff_build.log
└── ANN_snpEff
     ├── {samples}.ann.vcf.gz 
     ├── {samples}_summary.genes.txt       
     └── {samples}_summary.html
```

```bash
RNAseq_paired
├── DESeq2ForGene
├── DESeq2ForIso
├── FastpForPaired
├── FastqcForPairedAfter
├── FastqcForPairedBefore
├── MergeRSEMResultsGenes
├── MergeRSEMResultsIso
├── Quliamap
├── RSEMForPaired
├── STARForPaired


│    ├──{samples}_SnpSift.vcf.gz
└── ANN_snpEff
     ├── {samples}.ann.vcf.gz 
     ├── {samples}_summary.genes.txt       
     └── {samples}_summary.html
```

```bash
Annotations
├── Call_ANN
│    ├── {samples}_overlap_shared.vcf.gz
├── Combine_VCF
│    ├── {samples}_combine.vcf.gz
├── Compare_results
│    ├── {samples}_overlap.vcf.gz
│    └── {samples}_unique.vcf.gz
└── ANN_snpEff
     ├── {samples}.ann.vcf.gz 
     ├── {samples}_summary.genes.txt       
     └── {samples}_summary.html
```
