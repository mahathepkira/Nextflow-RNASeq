# Nextflow-RNASeq

## For run single-end
nextflow run -profile gb main.nf \
    --input data-single \
    --fasta /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.fa  \
    --gtf /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.1.gene.gtf \
    --reads_type single-end \
    --multimap 1 \
    --unmaped Within \
    --overhang 100 \
    --output output \
## For run paired-edn   
nextflow run -profile gb main.nf \
    --input data-paired \
    --fasta /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.fa  \
    --gtf /nbt_main/home/lattapol/mycassava/reference/Mesculenta_305_v6.1.gene.gtf \
    --reads_type paired-end \
    --multimap 1 \
    --unmaped Within \
    --overhang 100 \
    --output output \
