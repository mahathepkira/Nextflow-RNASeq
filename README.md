# Nextflow-RNASeq
## หัวข้อ
1. [บทนำ](#1-บทนำ)
2. [การใช้งาน Nextflow-RNASeq](#2-การใช้งาน-Nextflow-RNASeq)
3. [การเตรียมเครื่องมือและข้อมูลสำหรับ Nextflow-RNASeq](#3-การเตรียมเครื่องมือและข้อมูลสำหรับ-Nextflow-Annotations)
4. [รายละเอียดขั้นตอนใน Nextflow-RNASeq](#4-รายละเอียดขั้นตอนใน-Nextflow-Annotations)
5. [Output](#5-Output)
   
---
## 1. บทนำ
Nextflow-RNASeq เป็น bioinformatics pipline ที่พัฒนาขึ้นสำหรับการทำ RNASeq โดยจะมีขั้นตอนดังต่อไปนี้ 
## 2. การใช้งาน Nextflow-RNASeq
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
RNAseq_paired
├── DESeq2ForGene
│    ├── DEG_list.csv
│    ├── DEG_report.pdf
│    ├── DESeq2.log
│    ├── Heatmap_DEG.png
│    ├── Heatmap_sample.png
│    ├── MA_plot.png
│    ├── normalized_count.csv
│    ├── normalized_count_DEG.csv
│    ├── sammary_table.csv
│    └── Volcano_plot.png
├── DESeq2ForIso
│    ├── DEG_list.csv
│    ├── DEG_report.pdf
│    ├── DESeq2.log
│    ├── Heatmap_DEG.png
│    ├── Heatmap_sample.png
│    ├── MA_plot.png
│    ├── normalized_count.csv
│    ├── normalized_count_DEG.csv
│    ├── sammary_table.csv
│    └── Volcano_plot.png
├── FastQC_visualize
│    └── summary.csv 
├── FastpForPaired
│    ├── sample_q<phred-score>.cutadap.html
│    ├── sample_q<phred-score>.cutadap.json
│    ├── sample_R1_q<phred-score>.cutadap.gz
│    └── sample_R2_q<phred-score>.cutadap.gz
├── FastqcForPairedAfter
│    ├── sample_R1_q<phred-score>.cutadap_fastqc.html
│    ├── sample_R1_q<phred-score>.cutadap_fastqc.zip
│    ├── sample_R2_q<phred-score>.cutadap_fastqc.html
│    └── sample_R2_q<phred-score>.cutadap_fastqc.zip
├── FastqcForPairedBefore
│    ├── sample_R1_fastqc.html
│    ├── sample_R1_fastqc.zip
│    ├── sample_R2_fastqc.html
│    └── sample_R2_fastqc.zip
├── MergeRSEMResultsGenes
│    ├── merged_expected_count.csv
│    ├── merged_FPKM.csv
│    └── merged_TPM.csv
├── MergeRSEMResultsIso
│    ├── merged_expected_count.csv
│    ├── merged_FPKM.csv
│    └── merged_TPM.csv
├── Quliamap
│    └── sample.Aligned.sortedByCoord.out_stats
│         ├── css
│         │    ├── agogo.css
│         │    ├── ajax-loader.gif
│         │    ├── basic.css
│         │    ├── bgfooter.png
│         │    ├── bgtop.png
│         │    ├── comment-bright.png
│         │    ├── comment-close.png
│         │    ├── comment.png
│         │    ├── doctools.js
│         │    ├── down-pressed.png
│         │    ├── down.png
│         │    ├── file.png
│         │    ├── jquery.js
│         │    ├── minus.png
│         │    ├── plus.png
│         │    ├── pygments.css
│         │    ├── qualimap_logo_small.png
│         │    ├── report.css
│         │    ├── searchtools.js
│         │    ├── underscore.js
│         │    ├── up-pressed.png
│         │    ├── up.png
│         │    └── websupport.js
│         ├── genome_results.txt
│         ├── images_qualimapReport
│         │    ├── genome_coverage_0to50_histogram.png
│         │    ├── genome_coverage_across_reference.png
│         │    ├── genome_coverage_histogram.png
│         │    ├── genome_coverage_quotes.png
│         │    ├── genome_gc_content_per_window.png
│         │    ├── genome_insert_size_across_reference.png
│         │    ├── genome_insert_size_histogram.png
│         │    ├── genome_mapping_quality_across_reference.png
│         │    ├── genome_mapping_quality_histogram.png
│         │    ├── genome_reads_clipping_profile.png
│         │    ├── genome_reads_content_per_read_position.png
│         │    └── genome_uniq_read_starts_histogram.png
│         ├── qualimapReport.html
│         └── raw_data_qualimapReport
│              ├── coverage_across_reference.txt
│              ├── coverage_histogram.txt
│              ├── duplication_rate_histogram.txt
│              ├── genome_fraction_coverage.txt
│              ├── homopolymer_indels.txt
│              ├── insert_size_across_reference.txt
│              ├── insert_size_histogram.txt
│              ├── mapped_reads_clipping_profile.txt
│              ├── mapped_reads_gc-content_distribution.txt
│              ├── mapped_reads_nucleotide_content.txt
│              ├── mapping_quality_across_reference.txt
│              └── mapping_quality_histogram.txt
├── Qualimap_visualize
│    └── qualimap_summary.csv
├── RSEMForPaired
│    ├── sample.Aligned.toTranscriptome.out.genes.results
│    └── sample.Aligned.toTranscriptome.out.isoforms.results
└── STARForPaired
     ├── sample.Aligned.sortedByCoord.out.bam
     └── sample.Aligned.toTranscriptome.out.bam
```

```bash
RNAseq_single
├── DESeq2ForGene
│    ├── DEG_list.csv
│    ├── DEG_report.pdf
│    ├── DESeq2.log
│    ├── Heatmap_DEG.png
│    ├── Heatmap_sample.png
│    ├── MA_plot.png
│    ├── normalized_count.csv
│    ├── normalized_count_DEG.csv
│    ├── sammary_table.csv
│    └── Volcano_plot.png
├── DESeq2ForIso
│    ├── DEG_list.csv
│    ├── DEG_report.pdf
│    ├── DESeq2.log
│    ├── Heatmap_DEG.png
│    ├── Heatmap_sample.png
│    ├── MA_plot.png
│    ├── normalized_count.csv
│    ├── normalized_count_DEG.csv
│    ├── sammary_table.csv
│    └── Volcano_plot.png
├── FastQC_visualize
│    └── summary.csv 
├── FastpForSingle
│    ├── sample_q<phred-score>.cutadap.html
│    ├── sample_q<phred-score>.cutadap.json
│    └── sample_q<phred-score>.cutadap.gz
├── FastqcForPairedAfter
│    ├── sample_q<phred-score>.cutadap_fastqc.html
│    └── sample_q<phred-score>.cutadap_fastqc.zip
├── FastqcForPairedBefore
│    ├── sample_fastqc.html
│    └── sample_fastqc.zip
├── MergeRSEMResultsGenes
│    ├── merged_expected_count.csv
│    ├── merged_FPKM.csv
│    └── merged_TPM.csv
├── MergeRSEMResultsIso
│    ├── merged_expected_count.csv
│    ├── merged_FPKM.csv
│    └── merged_TPM.csv
├── Quliamap
│    └── sample.Aligned.sortedByCoord.out_stats
│         ├── css
│         │    ├── agogo.css
│         │    ├── ajax-loader.gif
│         │    ├── basic.css
│         │    ├── bgfooter.png
│         │    ├── bgtop.png
│         │    ├── comment-bright.png
│         │    ├── comment-close.png
│         │    ├── comment.png
│         │    ├── doctools.js
│         │    ├── down-pressed.png
│         │    ├── down.png
│         │    ├── file.png
│         │    ├── jquery.js
│         │    ├── minus.png
│         │    ├── plus.png
│         │    ├── pygments.css
│         │    ├── qualimap_logo_small.png
│         │    ├── report.css
│         │    ├── searchtools.js
│         │    ├── underscore.js
│         │    ├── up-pressed.png
│         │    ├── up.png
│         │    └── websupport.js
│         ├── genome_results.txt
│         ├── images_qualimapReport
│         │    ├── genome_coverage_0to50_histogram.png
│         │    ├── genome_coverage_across_reference.png
│         │    ├── genome_coverage_histogram.png
│         │    ├── genome_coverage_quotes.png
│         │    ├── genome_gc_content_per_window.png
│         │    ├── genome_insert_size_across_reference.png
│         │    ├── genome_insert_size_histogram.png
│         │    ├── genome_mapping_quality_across_reference.png
│         │    ├── genome_mapping_quality_histogram.png
│         │    ├── genome_reads_clipping_profile.png
│         │    ├── genome_reads_content_per_read_position.png
│         │    └── genome_uniq_read_starts_histogram.png
│         ├── qualimapReport.html
│         └── raw_data_qualimapReport
│              ├── coverage_across_reference.txt
│              ├── coverage_histogram.txt
│              ├── duplication_rate_histogram.txt
│              ├── genome_fraction_coverage.txt
│              ├── homopolymer_indels.txt
│              ├── insert_size_across_reference.txt
│              ├── insert_size_histogram.txt
│              ├── mapped_reads_clipping_profile.txt
│              ├── mapped_reads_gc-content_distribution.txt
│              ├── mapped_reads_nucleotide_content.txt
│              ├── mapping_quality_across_reference.txt
│              └── mapping_quality_histogram.txt
├── Qualimap_visualize
│    └── qualimap_summary.cs
├── RSEMForPaired
│    ├── sample.Aligned.toTranscriptome.out.genes.results
│    └── sample.Aligned.toTranscriptome.out.isoforms.results
└── STARForPaired
     ├── sample.Aligned.sortedByCoord.out.bam
     └── sample.Aligned.toTranscriptome.out.bam
```
