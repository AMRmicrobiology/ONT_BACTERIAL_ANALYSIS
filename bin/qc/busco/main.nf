process BUSCO {
    tag "GENOME COMPLETENESS"

    container "$params.busco.docker"
    
    publishDir "${params.outdir}/1-QC/genomeQC/BUSCO", mode: "copy" 

    input:
    tuple val(sample_code), path(assemble)

    output:
    tuple val(sample_code), path("${sample_code}_busco")

    script:

    """
    busco -i ${assemble} -m genome -l bacteria -o ${sample_code}_busco
    """
}
