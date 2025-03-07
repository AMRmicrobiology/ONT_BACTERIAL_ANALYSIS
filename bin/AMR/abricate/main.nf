process AMR {
    tag "ABRICATE PROCESS"

    publishDir "${params.outdir}/3-AMR/ABRICATE", mode: 'copy'

    container "$params.abricate.docker"

    input:
    tuple val(sample_code), path(assembly_file)

    output:
    path("${sample_code}_combined_abricate_report.tsv"), emit: abricate_report

    script:
    """
    DBS=("resfinder" "vfdb" "plasmidfinder" "card")

    echo -e "FILE\tSEQUENCE\tSTART\tEND\tSTRAND\tGENE\tCOVERAGE\tCOVERAGE_MAP\tGAPS\t%COVERAGE\t%IDENTITY\tDATABASE\tACCESSION\tPRODUCT\tRESISTANCE" > ${sample_code}_combined_abricate_report.tsv

    for db in \${DBS[@]}; do
        abricate --db \$db ${assembly_file} --noheader >> ${sample_code}_combined_abricate_report.tsv
    done
    
    """
}