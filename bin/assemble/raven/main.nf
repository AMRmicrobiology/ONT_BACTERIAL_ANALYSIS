process assemble_raven {
    tag "Assemble with Raven - ${barcode_id}"

    input:
    tuple val(barcode_id), path(reads_path), val(genome_size)

    output:
    tuple val(barcode_id), path("raven_output_${barcode_id}.fasta")

    script:
    """
    mkdir -p raven_output_${barcode_id}
    raven ${reads_path} > raven_output_${barcode_id}/${barcode_id}_assembly.fasta
    """
}