process QUAST {
    tag "QC_ASSEMBLE"
    
    container "$params.quast.docker"


    publishDir "${params.outdir}/5-assemble/QUAST", mode: 'copy'
    
    input:
    tuple val(barcode_id), path(consensus)

    output:
    tuple val(barcode_id), path("quast_result_${barcode_id}")

    script:

    """
    quast.py -o quast_result_${barcode_id} ${consensus}
    """
}