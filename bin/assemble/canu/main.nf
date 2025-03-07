process SUB_SAMPLE_1 {
    tag "Assemble with Canu - ${barcode_id}"

    input:
    tuple val(barcode_id), path(reads_path), val(genome_size_map), val (sample_code)

    output:
    path("canu_output_${sample_code}")
    tuple val(sample_code), path("canu_output_${sample_code}.fasta"), emit: assembly_canu_file

    script:
    """
    canu -p ${sample_code}_assembly -d canu_output_${sample_code} \
        genomeSize=${genome_size_map} \
        -nanopore-raw ${reads_path} \
        maxThreads=8
        
    mv canu_output_${sample_code}/${sample_code}_assembly.contigs.fasta canu_output_${sample_code}.fasta
    """
}