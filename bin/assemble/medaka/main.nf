process MEDAKA {
    tag "Medaka Consensus for ${barcode_id}"

    container "$params.medaka.docker"

    input:
    tuple val(barcode_id), path(trimmed_reads), path(final_polishing_fasta)

    output:
    path "medaka_output_${barcode_id}"
    tuple val(barcode_id), path("medaka_output_${barcode_id}/consensus.fasta"), emit: assemble_medaka

    script:
    """
    mkdir -p medaka_output_${barcode_id}
    medaka_consensus -i ${trimmed_reads} -d ${final_polishing_fasta} -o medaka_output_${barcode_id} -t 2 --bacteria
    """
}