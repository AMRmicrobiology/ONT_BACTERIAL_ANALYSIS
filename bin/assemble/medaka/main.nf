process MEDAKA {
    tag "Medaka Consensus for ${barcode_id}"

    container "$params.medaka.docker"

    publishDir "${params.outdir}/5-assemble/medaka_results", mode: 'copy'
    
    input:
    tuple val(sample_code), path(trimmed_reads), path(final_polishing_fasta)

    output:
    path "medaka_output_${sample_code}"
    tuple val(sample_code), path("${sample_code}_consensus.fasta"), emit: assemble_medaka

    script:
    """
    mkdir -p medaka_output_${sample_code}

    medaka_consensus -i ${trimmed_reads} -d ${final_polishing_fasta} -o medaka_output_${sample_code} -t 2 --bacteria

    mv medaka_output_${sample_code}/consensus.fasta ${sample_code}_consensus.fasta
    """
}