process MLST {
    tag "MLST-annotation process ${sample_id}"
    
    container "$params.quast.docker"
    
    publishDir "${params.outdir}/4-mlst", mode: 'copy'

    input:
    tuple val(sample_code), path(assembly_file)

    output:
    path("*.mlst.tab"), emit: 'tab'
    path("*.mlst.json"), emit: 'json'

    script:
    """
    mlst --threads ${task.cpus} --json ${sample_code}.mlst.json ${assembly_file} > ${sample_code}.mlst.tab
    """
}