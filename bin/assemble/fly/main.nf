process SUB_SAMPLE_2 {
    tag "ASSAMBLE FLY LONG READS ${barcode_id}"

    cache 'deep'
    
    publishDir "${params.outdir}/flye_results", mode: 'copy'


    input:

    tuple val(barcode_id), path(barcode_file), val (genome_size)

    output:

    path "flye_output_${barcode_id}/assembly.fasta"


    script:

    """
    # Paso 1: Eliminar IDs duplicados en las lecturas usando seqkit
    seqkit rmdup -s -i ${barcode_file} -o dedup_${barcode_id}.fastq

    # Paso 2: Ejecutar Flye usando el archivo sin duplicados
    flye --nano-raw dedup_${barcode_id}.fastq --out-dir flye_output_${barcode_id} --genome-size ${genome_size}
    """
}