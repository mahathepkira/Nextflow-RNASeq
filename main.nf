nextflow.preview.dsl=2
/*
================================================================================
=                           Sinonkt Style I N I T                              =
================================================================================
*/
include './modules/nbt/utils'

if (params.exportKeySchema) exit 0, printKeySchema()
if (params.exportValueSchema) exit 0, printValueSchema()

params.MAINTAINERS = [
  'Krittin Phornsiricharoenphant (oatkrittin@gmail.com)',
  'Alisa Wilantho (alisa.wil@biotec.or.th)',
  'Sujiraporn Pakchuen (sujiraporn.pak@biotec.or.th)'
]

def schema = readAvroSchema("${workflow.projectDir}/schemas/value.avsc")
__params = getDefaultThenResolveParams(schema, params)


include './modules/nbt/log' params(__params)
include helpMessage from './modules/nbt/help' params(__params)
include './modules/preprocess.nf'  params(__params)
include FastqcForPaired as FastqcForPairedBefore from './modules/visualize' params(__params)
include FastqcForPaired as FastqcForPairedAfter from './modules/visualize' params(__params)
include FastqcForSingle as FastqcForSingleBefore from './modules/visualize' params(__params)
include FastqcForSingle as FastqcForSingleAfter from './modules/visualize' params(__params)
include './modules/visualize.nf' params(__params)
include './modules/alignment.nf' params(__params)
include './modules/rsem.nf' params(__params)
include './modules/count.nf' params(__params)
if (params.version) exit 0, workflowVersionMessage()
if (params.help) exit 0, helpMessage(schema)


/*
================================================================================
=                   Sinonkt Style Workflows definitions                        =
================================================================================
*/

workflow RNAseq_paired {
   get:
     reads
     fasta
     gtf

   main:
     FastqcForPairedBefore(reads)
     (reads_trimed, reads_stats)= FastpForParied(reads)
     FastqcForPairedAfter(reads_trimed)
     star_index = STAR_INDEX(fasta,gtf)
     star_input = reads_trimed.combine(star_index)
     (bamSorted,bamForCount) = STARForPaired(star_input)
     Qualimap(bamSorted)
     rsem_index = RSEM_INDEX(fasta,gtf)
     rsem_input = bamForCount.combine(rsem_index)
     (rsemGene, rsemIso, rsemStats) = RSEMForPaired(rsem_input)
     all_rsem_iso = rsemIso.collect()
     all_rsem_gene = rsemGene.collect()
     (count_iso,tmp_iso,fpkm_iso) = MergeRSEMResultsIso(all_rsem_iso)
     (count_gene,tmp_gene,fpkm_gene) = MergeRSEMResultsGenes(all_rsem_gene)

   emit:
     count_iso
     count_gene
}


workflow RNAseq_single {
   get:
     reads
     fasta
     gtf

   main:
     FastqcForSingleBefore(reads)
     (reads_trimed,reads_stats) = FastpForSingle(reads)
     FastqcForSingleAfter(reads_trimed)
     star_index = STAR_INDEX(fasta,gtf)
     star_input = reads_trimed.combine(star_index)
     (bamSorted,bamForCount) = STARForSingle(star_input)
     Qualimap(bamSorted)
     rsem_index = RSEM_INDEX(fasta,gtf)
     rsem_input = bamForCount.combine(rsem_index)
     (rsemGene, rsemIso, rsemStats) = RSEMForSingle(rsem_input)
     all_rsem_iso = rsemIso.collect()
     all_rsem_gene = rsemGene.collect()
     (count_iso,tmp_iso,fpkm_iso) = MergeRSEMResultsIso(all_rsem_iso)
     (count_gene,tmp_gene,fpkm_gene) = MergeRSEMResultsGenes(all_rsem_gene)

   emit:
     count_iso
     count_gene

}



/*
================================================================================
=                           Sinonkt Style M A I N                              =
================================================================================
*/

workflow {
  println("====================")
  println(__params)
  println("====================")

  fasta = Channel.fromPath("${__params.fasta}")
  fasta.view()
  gtf = Channel.fromPath("${__params.gtf}")
  gtf.view()
  
  if (__params.reads_type == "pair-end" ) {
     reads = Channel.fromFilePairs("${__params.input}/*_R{1,2}_001.fastq.gz")
     .map {[it.first(), *it.last()]}
     reads.view()
     RNAseq_paired(reads,fasta,gtf)
  }
  else if (__params.reads_type == "single-end" ) {
     reads = Channel.fromPath("${__params.input}/*.fastq.gz")
     .map { file -> 
            def sample_id = file.name.replaceFirst(/\.fastq\.gz$/, "")
            [ sample_id, file ]}
     reads.view()
     RNAseq_single(reads,fasta,gtf)
  }

}


workflow.onComplete { handleCompleteMessage() }
workflow.onError { handleErrorMessage() }
