include "./nbt/utils"

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







