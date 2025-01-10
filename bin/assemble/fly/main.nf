process SUB_SAMPLE_2 {
    tag "ASSAMBLE FLY LONG READS ${sample_code}"
    publishDir "${params.outdir}/FLY_STRUCTURAL", mode: 'copy'
    cache 'deep'
    
    input:

    tuple val(barcode_id), path(barcode_file), val (genome_size), val (sample_code)

    output:

    tuple val(barcode_id),path("flye_output_${sample_code}/assembly.fasta"), emit: fly_assambly_tuple
    tuple val(barcode_id),path("flye_output_${sample_code}/assembly_info.txt"), emit: info_cov
    tuple val (barcode_id),path("flye_output_${sample_code}/assembly_graph.gfa"), emit: grafic_assemble

    script:

    """
    # Paso 1: Eliminar IDs duplicados en las lecturas usando seqkit
    seqkit rmdup -s -i ${barcode_file} -o dedup_${sample_code}.fastq

    # Paso 2: Ejecutar Flye usando el archivo sin duplicados
    flye --nano-raw dedup_${sample_code}.fastq --out-dir flye_output_${sample_code} --genome-size ${genome_size}

    """
}