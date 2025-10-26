include "./nbt/utils"

process TrimmmomaticParied {

  tag { "${fileId}" }

  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple val(fileId), file(read1), file(read2)

  output:
  tuple val(fileId), file("${prefix}_R1_trimmed.fastq.gz"), file("${prefix}_R2_trimmed.fastq.gz")

  script:
  prefix=fileId

  """
  java -jar \$EBROOTTRIMMOMATIC/trimmomatic-0.38.jar PE -phred33 -threads 8 \
  ${read1} ${read2} \
  ${prefix}_R1_trimmed.fastq.gz ${prefix}_R1_untrimmed.fastq.gz \
  ${prefix}_R2_trimmed.fastq.gz ${prefix}_R2_untrimmed.fastq.gz \
  ILLUMINACLIP:/nbt_main/home/lattapol/tools/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
  LEADING:20 TRAILING:20 \
  SLIDINGWINDOW:4:20 MINLEN:50
  """
}

process TrimmmomaticSingle {

  tag { "${fileId}" }

  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  tuple val(fileId), file(reads)

  output:
  tuple val(fileId), file("${prefix}_trimmed.fastq.gz")


  script:
  prefix=fileId

  """
  java -jar \$EBROOTTRIMMOMATIC/trimmomatic-0.38.jar SE -phred33 -threads 8 \
  ${reads} \
  ${prefix}_trimmed.fastq.gz \
  ILLUMINACLIP:/nbt_main/home/lattapol/tools/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
  LEADING:20 TRAILING:20 \
  SLIDINGWINDOW:4:20 MINLEN:50
  """
}



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
