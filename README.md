# Nextflow-RNASeq
## หัวข้อ
1. [บทนำ](#1-บทนำ)
2. [การใช้งาน Nextflow-RNASeq](#2-การใช้งาน-Nextflow-RNASeq)
3. [การเตรียมเครื่องมือและข้อมูลสำหรับ Nextflow-RNASeq](#3-การเตรียมเครื่องมือและข้อมูลสำหรับ-Nextflow-RNASeq)
4. [รายละเอียดขั้นตอนใน Nextflow-RNASeq](#4-รายละเอียดขั้นตอนใน-Nextflow-RNASeq)
5. [Output](#5-Output)
   
---
## 1. บทนำ
Nextflow-RNASeq เป็น bioinformatics pipline ที่พัฒนาขึ้นสำหรับการทำ RNASeq โดยจะมีขั้นตอนดังต่อไปนี้ 
1. Pre-processing
2. Sequence Alignment and Quantification
3. Differential gene expression
![ภาพ nextflow](Nextflow-RNASeq.drawio.png)
## 2. การใช้งาน Nextflow-RNASeq
### การใช้งานแบบ single-end
```bash
nextflow run -profile gb main.nf \
    --input data-single \
    --fasta /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.fa  \
    --gtf /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.1.gene.gtf \
    --conditions_file /nbt_main/home/lattapol/nextflow-RNAseq/data/conditions_test2.csv \
    --mode fastq \
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
### การใช้งานแบบ paired-end  
```bash
nextflow run -profile gb main.nf \
    --input data-paired \
    --fasta /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.fa  \
    --gtf /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.1.gene.gtf \
    --conditions_file /nbt_main/home/lattapol/nextflow-RNAseq/data/conditions_test2.csv \
    --mode fastq \
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

### การใช้งานแบบ meta Data
```bash
nextflow run -profile gb main.nf \
    --fastq data \
    --input /nbt_main/home/lattapol/nextflow-RNAseq/data/aha2.csv \
    --fasta /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.fa  \
    --gtf /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.1.gene.gtf \
    --mode csv \
    --reads_type paired-end \
    --multimap 1 \
    --unmaped Within \
    --overhang 100 \
    --conditions con3 \
    --contrast ESR_vs_Fi \
    --padj 0.05 \
    --lfc 1.0 \
    --output results \
```
### Options
- `--input` = โฟลเดอร์หรือไฟล์ input (จำเป็น)
- `--fastq` = โฟลเดอร์ไฟล์ fastq (จำเป็น:สำหรับ `--mode` csv)
- `--fasta` = ไฟล์ fasta (จำเป็น)
- `--gtf` = ไฟล์ gtf (จำเป็น)
- `--conditions_file` = ไฟล์ csv ที่มี conditions ของตัวอย่าง สำหรับทำ Differential gene expression 
- `--reads_type`  = ชนิดของ reads (จำเป็น:single-end, paired-end|ค่าเริ่มต้น:paired-end)
- `--mode` = mode ไฟล์ input (จำเป็น:fastq, csv|ค่าเริ่มต้น:csv)
- `--adapter` = adapter ที่ต้องการตัด (ค่าเริ่มต้น:AGATCGGAAGAG)
- `--minlen` = จำนวน reads ที่สั้นที่สุดที่ยอมรับได้สำหรับขั้นตอน Pre-processing (ค่าเริ่มต้น:50)
- `--phred` = ค่า phred score สำหรับขั้นตอน Pre-processing (ค่าเริ่มต้น:20)
- `--conditions` = conditions สำหรับทำ Differential gene expression (จำเป็น)
- `--contrast`  = conditions ที่จะเปลี่ยบเทียบ (จำเป็น:A_vs_B)
- `--multimap` = จำนวนสูงสุดที่ reads จะ mapped กับตำแน่งใน Reference ในขั้นตอน Alingment (ค่าเริ่มต้น:10)
- `--unmaped` = ไฟล์ unmapped จาก ขั้นตอน Alignment (Within หรือ null|ค่าเริ่มต้น:null)
- `--overhang` = จำนวน reads ที่ยาวที่สุด -1 (ค่าเริ่มต้น:100)
- `--padj` =  ค่า padj ในขั้นตอน Differential gene expression
- `--lfc` =  ค่า log2 fold change ในขั้นตอน Differential gene expression
- `--output` = โฟลเดอร์หรือไฟล์ output (จำเป็น)
## 3. การเตรียมเครื่องมือและข้อมูลสำหรับ Nextflow-RNASeq
## เครืองมือ 
1. Nextflow: version 19
2. Pre-processing: Fastp version 0.24.3, FastQC version 0.11.9
3. Sequence Alignment and Quantification: STAR version 2.7.11b, Qualimap versions 2.3, RSEM versiion 1.3.3
4. Differential gene expression: R version 4.5.1
### การเตรียม Config
```bash
process {
  executor = 'slurm'
  queue = 'memory'
  cache = 'lenient'

  withName: TrimmmomaticParied {
    module = 'Trimmomatic/0.38-Java-1.8'
    cpus = 4
    memory = '8 GB'
  }

  withName: TrimmmomaticSingle {
    module = 'Trimmomatic/0.38-Java-1.8'
    cpus = 4
    memory = '8 GB'
  }

  withName: FastpForParied {
    beforeScript = 'export PATH=$HOME/tools:$PATH'
    cpus = 4
    memory = '8 GB'
  }

  withName: FastpForSingle {
    beforeScript = 'export PATH=$HOME/tools:$PATH'
    cpus = 4
    memory = '8 GB'
  }

  withName: FastqcForPairedAfter {
    module = 'FastQC/0.11.9-Java-11'
    cpus = 4
    memory = '8 GB'
  }

  withName: FastqcForPairedBefore {
    module = 'FastQC/0.11.9-Java-11'
    cpus = 4
    memory = '8 GB'
  }

  withName: FastqcForSingleAfter {
    module = 'FastQC/0.11.9-Java-11'
    cpus = 4
    memory = '8 GB'
  }

  withName: FastqcForSingleBefore {
    module = 'FastQC/0.11.9-Java-11'
    cpus = 4
    memory = '8 GB'
  }

  withName: FastqcForSingleBefore {
    module = 'FastQC/0.11.9-Java-11'
    cpus = 4
    memory = '8 GB'
  }

  withName: STAR_INDEX {
    //module = '/nbt_main/home/lattapol/tools/STAR-2.7.11b/STAR/source'
    beforeScript = 'export PATH=$HOME/tools/STAR-2.7.11b/STAR/source:$PATH'
    cpus = 8
    memory = '64 GB'
  }

  withName: STARForPaired {
    //module = '/nbt_main/home/lattapol/tools/STAR-2.7.11b/STAR/source'
    beforeScript = 'export PATH=$HOME/tools/STAR-2.7.11b/STAR/source:$PATH'
    cpus = 8
    memory = '64 GB'
  }

  withName: STARForSingle {
    //module = '/nbt_main/home/lattapol/tools/STAR-2.7.11b/STAR/source'
    beforeScript = 'export PATH=$HOME/tools/STAR-2.7.11b/STAR/source:$PATH'
    cpus = 8
    memory = '64 GB'
  }

  withName: RSEM_INDEX {
    //module = '/nbt_main/home/lattapol/tools/RSEM-1.3.3'
    beforeScript = 'export PATH=$HOME/tools/RSEM-1.3.3:$PATH'
    cpus = 8
    memory = '64 GB'
  }

  withName: RSEMForPaired {
    //module = '/nbt_main/home/lattapol/tools/RSEM-1.3.3'
    beforeScript = 'export PATH=$HOME/tools/RSEM-1.3.3:$PATH'
    cpus = 8
    memory = '64 GB'
  }

  withName: RSEMForSingle {
    beforeScript = 'export PATH=$HOME/tools/RSEM-1.3.3:$PATH'
    cpus = 8
    memory = '64 GB'
  }

  withName: Qualimap {
  container = '/nbt_main/share/singularity/qualimap:2.3--hdfd78af_0'
  cpus = 4
  memory = '8 GB'
  }

  withName: MergeRSEMResultsIso {
    module = 'Python/3.10.4-GCCcore-11.3.0'
    cpus = 4
    memory = '8 GB'
  }

  withName: MergeRSEMResultsGenes {
    module = 'Python/3.10.4-GCCcore-11.3.0'
    cpus = 4
    memory = '8 GB'
  }

  withName: DESeq2ForIso {
    container = '/nbt_main/share/singularity/r_popgen_animal.sif'
    cpus = 4
    memory = '8 GB'
  }

  withName: DESeq2ForGene {
    container = '/nbt_main/share/singularity/r_popgen_animal.sif'
    cpus = 4
    memory = '8 GB'
  }

}

singularity {
    enabled = true
    autoMounts = true
}
```
## 4. รายละเอียดขั้นตอนใน Nextflow-RNASeq
### การทำ Pre-processing
```bash
process FastqcForPaired {

  tag { key }
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple key, file(reads1), file(reads2)

  output:
  tuple key, file("*.zip"), file("*.html")

  script:
  """
  fastqc ${reads1} ${reads2} --threads 8
  """
}
```
```bash
process FastqcForSingle {

  tag { key }
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple key, file(reads)

  output:
  tuple key, file("*.zip"), file("*.html")

  script:
  """
  fastqc --threads 8 ${reads}
  """
}
```
```bash
process FastQC_visualize {


  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  path zip

  output:
  path "summary.csv"

  script:

  """
  mkdir -p extracted
  for file in *.zip; do
      unzip -o "\$file" -d extracted/ > /dev/null
  done

  echo "file_name,Total_Sequences_BeforeQC,Total_Sequences_AfterQC,Sequence_length_BeforeQC,Sequence_length_AfterQC,%GC_BeforeQC,%GC_AfterQC" > summary.csv
  declare -A before_qc after_qc

  for file in extracted/*/fastqc_data.txt; do
      filename=\$(grep "Filename" "\$file" | cut -f2)
      total_sequences=\$(grep "Total Sequences" "\$file" | cut -f2)
      seq_length=\$(grep "Sequence length" "\$file" | cut -f2)
      gc_content=\$(grep "%GC" "\$file" | cut -f2)

      base_name=\$(echo "\$filename" | sed -E 's/_R[12].+//')

      if [[ "\$filename" == *filtered.fastq.gz ]]; then
          after_qc["\$base_name"]="\$total_sequences,\$seq_length,\$gc_content"
      else
          before_qc["\$base_name"]="\$total_sequences,\$seq_length,\$gc_content"
      fi
  done

  for key in "\${!before_qc[@]}"; do
      before="\${before_qc[\$key]:-,,}"
      after="\${after_qc[\$key]:-,,}"

      before_total_sequences=\$(echo \$before | cut -d',' -f1)
      before_seq_length=\$(echo \$before | cut -d',' -f2)
      before_gc_content=\$(echo \$before | cut -d',' -f3)

      after_total_sequences=\$(echo \$after | cut -d',' -f1)
      after_seq_length=\$(echo \$after | cut -d',' -f2)
      after_gc_content=\$(echo \$after | cut -d',' -f3)

      echo "\$key,\$before_total_sequences,\$after_total_sequences,\$before_seq_length,\$after_seq_length,\$before_gc_content,\$after_gc_content" >> summary.csv
  done

  """
}
```
```bash
process FastpForParied {

  tag { "${fileId}" }

  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple val(fileId), file(read1), file(read2)

  output:
  tuple val(fileId), file("${prefix}_R1_q${params.phred}.cutadap.gz"), file("${prefix}_R2_q${params.phred}.cutadap.gz")
  tuple val(fileId), file("${prefix}_q${params.phred}.cutadap.html"), file("${prefix}_q${params.phred}.cutadap.json")

  script:
  prefix=fileId

  """
  fastp --in1 ${read1} --out1 ${prefix}_R1_q${params.phred}.cutadap.gz \
        --in2 ${read2} --out2 ${prefix}_R2_q${params.phred}.cutadap.gz \
        --qualified_quality_phred ${params.phred} \
        --detect_adapter_for_pe \
        --trim_poly_g --trim_poly_x \
        --length_required ${params.minlen} \
        --adapter_sequence ${params.adapter} \
        --html ${prefix}_q${params.phred}.cutadap.html \
        --json ${prefix}_q${params.phred}.cutadap.json \
        --thread 8
  """
}
```
```bash
process FastpForSingle {

  tag { "${fileId}" }

  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple val(fileId), file(read1)

  output:
  tuple val(fileId), file("${prefix}_q${params.phred}.cutadap.gz")
  tuple val(fileId), file("${prefix}_q${params.phred}.cutadap.html"), file("${prefix}_q${params.phred}.cutadap.json")

  script:
  prefix=fileId

  """
  fastp -i ${read1} -o ${prefix}_q${params.phred}.cutadap.gz \
        --qualified_quality_phred ${params.phred} \
        --trim_poly_g --trim_poly_x \
        --adapter_sequence ${params.adapter} \
        --length_required ${params.minlen} \
        --html ${prefix}_q${params.phred}.cutadap.html \
        --json ${prefix}_q${params.phred}.cutadap.json \
        --thread 8
  """
}
```
### การทำ Sequenece Alingment และ Quantification
```bash
process STAR_INDEX {

  input:
  file(fasta)
  file(gtf)

  output:
  path "STAR_index"

  script:
  """
  STAR --runThreadN 12 --runMode genomeGenerate --genomeDir STAR_index --genomeFastaFiles ${fasta} --sjdbGTFfile ${gtf} --sjdbOverhang ${params.overhang}
  """
}
```
```bash
process STARForPaired {

  tag { key }
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple val(key), file(reads1), file(reads2),path(STAR_index)

  output:
  file("*.sortedByCoord.out.bam")
  file("*.toTranscriptome.out.bam")

  script:
  """
  STAR --genomeDir ${STAR_index} --runThreadN 12 --readFilesIn ${reads1} ${reads2} --readFilesCommand zcat \
       --outFileNamePrefix ${key}. --outFilterMultimapNmax ${params.multimap} --outSAMunmapped ${params.unmaped} --outSAMtype BAM SortedByCoordinate \
       --quantMode TranscriptomeSAM
  """
}
```
```bash
process STARForSingle {

  tag { key }
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple val(key), file(reads), path(STAR_index)

  output:
  file("*.sortedByCoord.out.bam")
  file("*.toTranscriptome.out.bam")

  script:
  """
  STAR --genomeDir ${STAR_index} --runThreadN 12 --readFilesIn ${reads} --readFilesCommand zcat \
       --outFileNamePrefix ${key}. --outFilterMultimapNmax ${params.multimap} --outSAMunmapped ${params.unmaped} --outSAMtype BAM SortedByCoordinate \
       --quantMode TranscriptomeSAM
  """
}
```
```bash
process Qualimap {

  tag { prefix }
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  file(bam)

  output:
  file "*"

  script:
  prefix=bam.baseName

  """
  qualimap bamqc -bam ${bam}
  """
```
```bash
process Qualimap_visualize {

  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  path qmap

  output:
  path "*"

  script:

  """
  echo "filename,number_of_reads,number_of_mapped_reads(%),number_of_unmapped_reads(%)" > qualimap_summary.csv

  for dir in *_stats; do
      file="\$dir/genome_results.txt"
      if [[ -f "\$file" ]]; then
         name=\$(echo "\$dir" | sed 's/_stats//')
         total_reads=\$(grep "number of reads =" "\$file" | awk '{print \$NF}' | tr -d ',')
         mapped_percent=\$(grep "number of mapped reads =" "\$file" | awk -F '[()]' '{print \$2}' | tr -d '%')

         unmapped_percent=\$(awk -v mp="\$mapped_percent" 'BEGIN {printf "%.2f", 100 - mp}')

         echo "\$name,\$total_reads,\$mapped_percent,\$unmapped_percent" >> qualimap_summary.csv
      fi
  done
  """
}
```
```bash
process RSEM_INDEX {

    input:
    file(fasta)
    file(gtf)

    output:
    path "*"

    script:
    """
    rsem-prepare-reference --gtf ${gtf} ${fasta} --num-threads 12 ref_data
    """
}
```
```bash
process RSEMForPaired {

  tag { prefix }
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple file(bam), path(index_ch1), path(index_ch2), path(index_ch3), path(index_ch4), path(index_ch5), path(index_ch6), path(index_ch7)

  output:
  file("${prefix}.genes.results")
  file("${prefix}.isoforms.results")
  file("${prefix}.stat")


  script:

  prefix=bam.baseName
  """
  rsem-calculate-expression --bam --no-bam-output --paired-end --num-threads 12 ${bam} ref_data ${prefix}
  """
}
```
```bash
process RSEMForSingle {

  tag { prefix }
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple file(bam), path(index_ch1), path(index_ch2), path(index_ch3), path(index_ch4), path(index_ch5), path(index_ch6), path(index_ch7)

  output:
  file("${prefix}.genes.results")
  file("${prefix}.isoforms.results")
  file("${prefix}.stat")


  script:

  prefix=bam.baseName
  """
  rsem-calculate-expression --bam --no-bam-output --num-threads 12 ${bam} ref_data ${prefix}
  """
}
```
```bash
process MergeRSEMResultsGenes {

  tag "merge RSEM results"
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  path rsem_results

  output:
  path "merged_expected_count.csv"
  path "merged_TPM.csv"
  path "merged_FPKM.csv"

  script:
  """
python3 - <<'EOF'
import pandas as pd
import os

files = [${rsem_results.collect { "\"${it.getName()}\"" }.join(',\n')}]
dfs = {}
for filepath in files:
    sample_name = os.path.basename(filepath).split(".")[0]
    df = pd.read_csv(filepath, sep='\\t')
    df = df[['gene_id', 'expected_count', 'TPM', 'FPKM']]
    df.rename(columns={
        'expected_count': f'{sample_name}_expected_count',
        'TPM': f'{sample_name}_TPM',
        'FPKM': f'{sample_name}_FPKM'
    }, inplace=True)
    dfs[sample_name] = df

merged_df = list(dfs.values())[0]
for df in list(dfs.values())[1:]:
    merged_df = merged_df.merge(df, on='gene_id')

count_df = merged_df[['gene_id'] + [col for col in merged_df.columns if col.endswith('_expected_count')]]
count_df = count_df.rename(columns=lambda x: x.replace('_expected_count', '') if x != 'transcript_id' else x)

tpm_df = merged_df[['gene_id'] + [col for col in merged_df.columns if col.endswith('_TPM')]]
tpm_df = tpm_df.rename(columns=lambda x: x.replace('_TPM', '') if x != 'transcript_id' else x)

fpkm_df = merged_df[['gene_id'] + [col for col in merged_df.columns if col.endswith('_FPKM')]]
fpkm_df = fpkm_df.rename(columns=lambda x: x.replace('_FPKM', '') if x != 'transcript_id' else x)

count_df.to_csv('merged_expected_count.csv', sep=',', index=False)
tpm_df.to_csv('merged_TPM.csv', sep=',', index=False)
fpkm_df.to_csv('merged_FPKM.csv', sep=',', index=False)
EOF
  """
```
```bash
process MergeRSEMResultsIso {

  tag "merge RSEM results"
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  path rsem_results

  output:
  path "merged_expected_count.csv"
  path "merged_TPM.csv"
  path "merged_FPKM.csv"

  script:
  """
python3 - <<'EOF'
import pandas as pd
import os

files = [${rsem_results.collect { "\"${it.getName()}\"" }.join(',\n')}]
dfs = {}
for filepath in files:
    sample_name = os.path.basename(filepath).split(".")[0]
    df = pd.read_csv(filepath, sep='\\t')
    df = df[['transcript_id', 'expected_count', 'TPM', 'FPKM']]
    df.rename(columns={
        'expected_count': f'{sample_name}_expected_count',
        'TPM': f'{sample_name}_TPM',
        'FPKM': f'{sample_name}_FPKM'
    }, inplace=True)
    dfs[sample_name] = df

merged_df = list(dfs.values())[0]
for df in list(dfs.values())[1:]:
    merged_df = merged_df.merge(df, on='transcript_id')

count_df = merged_df[['transcript_id'] + [col for col in merged_df.columns if col.endswith('_expected_count')]]
count_df = count_df.rename(columns=lambda x: x.replace('_expected_count', '') if x != 'transcript_id' else x)

tpm_df = merged_df[['transcript_id'] + [col for col in merged_df.columns if col.endswith('_TPM')]]
tpm_df = tpm_df.rename(columns=lambda x: x.replace('_TPM', '') if x != 'transcript_id' else x)

fpkm_df = merged_df[['transcript_id'] + [col for col in merged_df.columns if col.endswith('_FPKM')]]
fpkm_df = fpkm_df.rename(columns=lambda x: x.replace('_FPKM', '') if x != 'transcript_id' else x)

count_df.to_csv('merged_expected_count.csv', sep=',', index=False)
tpm_df.to_csv('merged_TPM.csv', sep=',', index=False)
fpkm_df.to_csv('merged_FPKM.csv', sep=',', index=False)
EOF
  """
}
```
### การทำ Differential gene expression
```bash
process DESeq2 {

    tag "${contrast}"
    publishDir "${outputPrefixPath(params, task)}"
    publishDir "${s3OutputPrefixPath(params, task)}"


    input:
    file(counts_file)

    output:
    path "*"

    script:
    """
    Rscript /nbt_main/home/lattapol/nextflow-RNAseq/bin/DESeq3.R --counts ${counts_file} --conditions_file ${params.input} \
      --conditions ${params.conditions} --contrast ${params.contrast} \
      --padj ${params.padj} \
      --lfc ${params.lfc} \
      --output . \
      > DESeq2.log 2>&1
    """
```
## 5. Output
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
### ภาพตัวอย่าง Heatmap ของ DEG
![ภาพตัวอย่าง Heatmap ของ DEG](Heatmap_DEG.png)
### ภาพตัวอย่าง Heatmap ของ ตัวอย่าง
![ภาพตัวอย่าง Heatmap ของ ตัวอย่าง](Heatmap_samples.png)
### ภาพตัวอย่างกราฟ MA plot
![ภาพตัวอย่างกราฟ MA plot](MA_plot.png)
### ภาพตัวอย่างกราฟ Volcano
![ภาพตัวอย่างกราฟ Volcano](Volcano_plot.png)
