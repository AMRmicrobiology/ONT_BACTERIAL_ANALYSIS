process SUB_SAMPLE_1 {
    tag "Assemble with Canu - ${barcode_id}"

    input:
    tuple val(barcode_id), path(reads_path), val(genome_size_map)

    output:
    tuple val(barcode_id), path("canu_output_${barcode_id}/*")

    script:
    """
    canu -p ${barcode_id}_assembly -d canu_output_${barcode_id} \
        genomeSize=${genome_size_map} \
        -nanopore-raw ${reads_path}
    """
}