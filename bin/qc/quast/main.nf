process QUAST {
    tag "QC_ASSEMBLE"
    
    container "$params.quast.docker"


    publishDir "${params.outdir}/1-QC/genomeQC/QUAST", mode: 'copy'

    errorStrategy 'ignore'

    input:
    tuple val(sample_code), path(consensus)

    output:
    tuple val(sample_code), path("quast_result_${sample_code}")

    script:

    """
    if [ -s ${consensus} ]; then
        quast.py -o quast_result_${sample_code} ${consensus} || echo "QUAST failed for ${sample_code}" > quast_result_${sample_code}/quast_error.log
    else
        echo "Skipping QUAST for ${sample_code} due to missing or empty consensus file." > quast_result_${sample_code}/quast_error.log
    fi
    """
}