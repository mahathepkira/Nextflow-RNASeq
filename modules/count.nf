include "./nbt/utils"

process MergeRSEMResultsGenes {
  
  tag "merge RSEM results"
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  path rsem_results

  output:
  path "merged_expected_count.tsv"
  path "merged_TPM.tsv"
  path "merged_FPKM.tsv"

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

# Merge all dataframes on gene_id
merged_df = list(dfs.values())[0]
for df in list(dfs.values())[1:]:
    merged_df = merged_df.merge(df, on='gene_id')

# Split into 3 files
count_df = merged_df[['gene_id'] + [col for col in merged_df.columns if col.endswith('_expected_count')]]
count_df = count_df.rename(columns=lambda x: x.replace('_expected_count', '') if x != 'transcript_id' else x)

tpm_df = merged_df[['gene_id'] + [col for col in merged_df.columns if col.endswith('_TPM')]]
tpm_df = tpm_df.rename(columns=lambda x: x.replace('_TPM', '') if x != 'transcript_id' else x)

fpkm_df = merged_df[['gene_id'] + [col for col in merged_df.columns if col.endswith('_FPKM')]]
fpkm_df = fpkm_df.rename(columns=lambda x: x.replace('_FPKM', '') if x != 'transcript_id' else x)

count_df.to_csv('merged_expected_count.tsv', sep='\\t', index=False)
tpm_df.to_csv('merged_TPM.tsv', sep='\\t', index=False)
fpkm_df.to_csv('merged_FPKM.tsv', sep='\\t', index=False)
EOF
  """
  
}

process MergeRSEMResultsIso {

  tag "merge RSEM results"
  publishDir "${outputPrefixPath(params, task)}"
  publishDir "${s3OutputPrefixPath(params, task)}"

  input:
  path rsem_results

  output:
  path "merged_expected_count.tsv"
  path "merged_TPM.tsv"
  path "merged_FPKM.tsv"

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

# Merge all dataframes on gene_id
merged_df = list(dfs.values())[0]
for df in list(dfs.values())[1:]:
    merged_df = merged_df.merge(df, on='transcript_id')

# Split into 3 files
count_df = merged_df[['transcript_id'] + [col for col in merged_df.columns if col.endswith('_expected_count')]]
count_df = count_df.rename(columns=lambda x: x.replace('_expected_count', '') if x != 'transcript_id' else x)

tpm_df = merged_df[['transcript_id'] + [col for col in merged_df.columns if col.endswith('_TPM')]]
tpm_df = tpm_df.rename(columns=lambda x: x.replace('_TPM', '') if x != 'transcript_id' else x)

fpkm_df = merged_df[['transcript_id'] + [col for col in merged_df.columns if col.endswith('_FPKM')]]
fpkm_df = fpkm_df.rename(columns=lambda x: x.replace('_FPKM', '') if x != 'transcript_id' else x)

count_df.to_csv('merged_expected_count.tsv', sep='\\t', index=False)
tpm_df.to_csv('merged_TPM.tsv', sep='\\t', index=False)
fpkm_df.to_csv('merged_FPKM.tsv', sep='\\t', index=False)
EOF
  """

}
