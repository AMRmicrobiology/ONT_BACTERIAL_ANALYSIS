process MULTIQC {

    tag "Generating MultiQC report"
    
    container "$params.quast.docker"
    
    publishDir "${params.outdir}/1-QC/genomeQC", mode: 'copy'

    input:
    tuple val (sample_code), path (quast_folder)
    tuple val (sample_code), path (busco_folder)

    output:
    path "multiqc_report"

    script:

    """
    multiqc ./ -o multiqc_report

    """
}