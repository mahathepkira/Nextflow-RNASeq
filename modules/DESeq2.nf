include "./nbt/utils"

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

}
