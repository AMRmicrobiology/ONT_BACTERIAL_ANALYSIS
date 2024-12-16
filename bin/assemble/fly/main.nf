process SUB_SAMPLE_2 {
    tag "ASSAMBLE FLY LONG READS ${sample_code}"

    cache 'deep'
    
    publishDir "${params.outdir}/5-assemble/flye_results", mode: 'copy'


    input:

    tuple val(barcode_id), path(barcode_file), val (genome_size), val (sample_code)

    output:

    tuple val(barcode_id),path("flye_output_${sample_code}/assembly.fasta"), emit: fly_assambly_tuple
    tuple val(barcode_id),path("flye_output_${sample_code}/assembly_info.txt"), emit: info_cov
    tuple val(barcode_id),path("flye_output_${sample_code}/${sample_code}_assembly.fasta"), emit: tuple_rename_assembly

    script:

    """
    # Paso 1: Eliminar IDs duplicados en las lecturas usando seqkit
    seqkit rmdup -s -i ${barcode_file} -o dedup_${sample_code}.fastq

    # Paso 2: Ejecutar Flye usando el archivo sin duplicados
    flye --nano-raw dedup_${sample_code}.fastq --out-dir flye_output_${sample_code} --genome-size ${genome_size}
    
    # Step: 3 - Rename assembly for MLST
    cp flye_output_${sample_code}/assembly.fasta flye_output_${sample_code}/${sample_code}_assembly.fasta
    """
}