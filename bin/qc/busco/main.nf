process BUSCO {
    tag "GENOME COMPLETENESS"

    container "$params.busco.docker"
    
    publishDir "${params.outdir}/2-assemble/BUSCO", mode: "copy" 

    input:
    tuple val(sample_code), path(assemble)

    output:
    tuple val(sample_code), path("${sample_code}_busco")

    script:

    """
    busco -i ${assemble} -m genome -l bacteria -o ${sample_code}_busco
    """
}
