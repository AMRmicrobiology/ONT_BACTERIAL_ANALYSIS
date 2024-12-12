process MLST {
    tag "MLST-annotation process ${sample_id}"
    
    container "$params.quast.docker"
    
    publishDir "${params.outdir}/4-mlst", mode: 'copy'

    input:
    tuple val(sample_id), path(contigs)

    output:
    path("*.mlst.tab"), emit: 'tab'
    path("*.mlst.json"), emit: 'json'

    script:
    """
    mlst --threads ${task.cpus} --json ${contigs.baseName}.mlst.json ${contigs} > ${contigs.baseName}.mlst.tab
    """
}