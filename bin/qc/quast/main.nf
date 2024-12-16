process QUAST {
    tag "QC_ASSEMBLE"
    
    container "$params.quast.docker"


    publishDir "${params.outdir}/5-assemble/QUAST", mode: 'copy'
    
    input:
    tuple val(sample_code), path(consensus)

    output:
    tuple val(sample_code), path("quast_result_${sample_code}")

    script:

    """
    quast.py -o quast_result_${sample_code} ${consensus}
    """
}