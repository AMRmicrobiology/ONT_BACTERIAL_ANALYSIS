process SUB_SAMPLE_3 {
    tag "Assemble with Raven - ${barcode_id}"

    input:
    tuple val(barcode_id), path(reads_path), val(genome_size), val(sample_code)

    output:
    tuple val(barcode_id), path("raven_output_${barcode_id}.fasta"), emit: raven_aseembly_file

    script:
    """
    mkdir -p raven_output_${barcode_id}
    raven ${reads_path} > raven_output_${barcode_id}/${barcode_id}_assembly.fasta
    mv raven_output_${barcode_id}/${barcode_id}_assembly.fasta raven_output_${barcode_id}.fasta
    """
}