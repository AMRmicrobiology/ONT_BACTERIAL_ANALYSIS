process SUB_SAMPLE_1 {
    tag "ASSAMBLE FLY LONG READS"

    cache 'deep'
    
    publishDir "${params.outdir}/flye_results", mode: 'copy'


    input:

    tuple val(barcode_id), path(barcode_file), val (genome_size)

    output:

    path "flye_output_${barcode_id}/assembly.fasta"


    script:

    """
    flye --nano-raw ${barcode_file} --out-dir flye_output_${barcode_id} --genome-size ${genome_size}
    """

}