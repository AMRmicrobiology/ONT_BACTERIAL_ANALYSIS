process AMR_2 {
    tag "AMRFinder PROCESS"

    publishDir "${params.outdir}/AMR/AMRFinder", mode: 'copy'

    container "$params.amrfinderplus.docker"

    input:
    tuple val(sample_code), path(assembly_file)

    output:
    path("${sample_code}_amrfinder_report.tsv"), emit: amrfinder_report

    script:
    """
    amrfinder -n ${assembly_file} -o ${sample_code}_amrfinder_report.tsv
    """
}