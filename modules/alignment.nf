include "./nbt/utils"

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
