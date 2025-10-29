include "./nbt/utils"

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
}

process FastqcForSingle_visualize {


  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  path zip_qc

  output:
  path "fastqc_summary.csv"

  script:

  """
  for file in *.zip; do unzip -o "\$file" -d extracted/; done
  echo "file_name,Total_Sequences_BeforeQC,Total_Sequences_AfterQC,Sequence_length_BeforeQC,Sequence_length_AfterQC,%GC_BeforeQC,%GC_AfterQC" > fastqc_summary.csv
  declare -A before_qc after_qc

  for file in extracted/*/fastqc_data.txt; do
      filename=\$(grep "Filename" "\$file" | cut -f2)
      total_sequences=\$(grep "Total Sequences" "\$file" | cut -f2)
      seq_length=\$(grep "Sequence length" "\$file" | cut -f2)
      gc_content=\$(grep "%GC" "\$file" | cut -f2)

      base_name=\$(echo "\$filename" | sed -E 's/_R?[12]//; s/_q20\\.cutadap//; s/(\\.fastq)?\\.gz\$//')

      if [[ "\${filename}" == *cutadap.gz ]]; then
           after_qc["\$base_name"]="\$total_sequences,\$seq_length,\$gc_content"
      else
           before_qc["\$base_name"]="\$total_sequences,\$seq_length,\$gc_content"
      fi

  done

  all_keys=(\$(printf "%s\n" "\${!before_qc[@]}" "\${!after_qc[@]}" | sort -u))
  
  for key in "\${all_keys[@]}"; do
      before="\${before_qc[\$key]:-,,}"
      after="\${after_qc[\$key]:-,,}"

      before_total_sequences=\$(echo \$before | cut -d',' -f1)
      before_seq_length=\$(echo \$before | cut -d',' -f2)
      before_gc_content=\$(echo \$before | cut -d',' -f3)

      after_total_sequences=\$(echo \$after | cut -d',' -f1)
      after_seq_length=\$(echo \$after | cut -d',' -f2)
      after_gc_content=\$(echo \$after | cut -d',' -f3)

      echo "\$key,\$before_total_sequences,\$after_total_sequences,\$before_seq_length,\$after_seq_length,\$before_gc_content,\$after_gc_content" >> fastqc_summary.csv

done

  """
}


process FastqcForPair_visualize {


  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  path zip_qc

  output:
  path "fastqc_summary.csv"

  script:

  """
  for file in *.zip; do unzip -o "\$file" -d extracted/; done
  echo "file_name,ReadPair,Total_Sequences_BeforeQC,Total_Sequences_AfterQC,Sequence_length_BeforeQC,Sequence_length_AfterQC,%GC_BeforeQC,%GC_AfterQC" > fastqc_summary.csv
  declare -A before_qc after_qc

  for file in extracted/*/fastqc_data.txt; do
      filename=\$(grep "Filename" "\$file" | cut -f2)
      total_sequences=\$(grep "Total Sequences" "\$file" | cut -f2)
      seq_length=\$(grep "Sequence length" "\$file" | cut -f2)
      gc_content=\$(grep "%GC" "\$file" | cut -f2)

      base_name=\$(echo "\$filename" | sed -E 's/_R?[12]//; s/_q20\\.cutadap//; s/(\\.fastq)?\\.gz\$//')
      read_pair=\$(echo "\$filename" | grep -oE "_R?[12]" | sed 's/_//')
      [[ -z "\$read_pair" ]] && read_pair="R?"

      key="\${base_name}_\${read_pair}"
 
      if [[ "\${filename}" == *cutadap.gz ]]; then
           after_qc["\$key"]="\$total_sequences,\$seq_length,\$gc_content"
           echo ">>> AFTER_QC[\$key] = \${after_qc[\$key]}" 
      else
           before_qc["\$key"]="\$total_sequences,\$seq_length,\$gc_content"
           echo ">>> BEFORE_QC[\$key] = \${before_qc[\$key]}"
      fi

  done

  all_samples=(\$(printf "%s\n" "\${!before_qc[@]}" "\${!after_qc[@]}" | sed -E 's/_(R[12])\$//' | sort -u))

  for sample in "\${all_samples[@]}"; do
      for read_pair in R1 R2; do
          key="\${sample}_\${read_pair}"

          before="\${before_qc[\$key]:-,,}"
          after="\${after_qc[\$key]:-,,}"

          before_total_sequences=\$(echo \$before | cut -d',' -f1)
          before_seq_length=\$(echo \$before | cut -d',' -f2)
          before_gc_content=\$(echo \$before | cut -d',' -f3)

          after_total_sequences=\$(echo \$after | cut -d',' -f1)
          after_seq_length=\$(echo \$after | cut -d',' -f2)
          after_gc_content=\$(echo \$after | cut -d',' -f3)

          echo "\$sample,\$read_pair,\$before_total_sequences,\$after_total_sequences,\$before_seq_length,\$after_seq_length,\$before_gc_content,\$after_gc_content" >> fastqc_summary.csv
      done
  done
  """
}


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
