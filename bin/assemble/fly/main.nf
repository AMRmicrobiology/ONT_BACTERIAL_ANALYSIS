process SUB_SAMPLE_2 {
    tag "ASSAMBLE FLY LONG READS ${sample_code}"
    
    publishDir "${params.outdir}/2-assemble/1-fly_structural", mode: 'copy'

    
    input:

    tuple val(barcode_id), path(barcode_file), val (genome_size), val (sample_code)

    output:

    tuple val(sample_code),path("flye_output_${sample_code}/assembly.fasta"), emit: fly_assambly_tuple
    tuple val(sample_code),path("flye_output_${sample_code}/assembly_info.txt"), emit: info_cov
    tuple val(sample_code),path("flye_output_${sample_code}/assembly_graph.gfa"), emit: grafic_assemble

    script:

    """
    # Paso 1: Eliminar IDs duplicados en las lecturas usando seqkit
    seqkit rmdup -s -i ${barcode_file} -o dedup_${sample_code}.fastq

    # Generar reporte de calidad con NanoStat para evaluar resultados
    NanoStat --fastq dedup_${sample_code}.fastq > dedup_${sample_code}_NanoStat.log

    # Paso 2: Ejecutar Flye usando el archivo sin duplicados
    flye --nano-raw dedup_${sample_code}.fastq --out-dir flye_output_${sample_code} --genome-size ${genome_size} --plasmids

    """
}