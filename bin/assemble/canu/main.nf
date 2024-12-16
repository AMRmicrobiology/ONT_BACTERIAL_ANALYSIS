process SUB_SAMPLE_1 {
    tag "Assemble with Canu - ${barcode_id}"

    input:
    tuple val(barcode_id), path(reads_path), val(genome_size_map), val (sample_code)

    output:
    path("canu_output_${barcode_id}")
    tuple val(barcode_id), path("canu_output_${barcode_id}.fasta"), emit: assembly_canu_file

    script:
    """
    canu -p ${barcode_id}_assembly -d canu_output_${barcode_id} \
        genomeSize=${genome_size_map} \
        -nanopore-raw ${reads_path}
    mv canu_output_${barcode_id}/${barcode_id}_assembly.contigs.fasta canu_output_${barcode_id}.fasta
    """
}