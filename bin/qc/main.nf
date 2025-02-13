process QC {
    tag "Quality control RAW data"

    cache 'deep'
    
    publishDir "${params.outdir}/1-Nanoplot/data_QC", mode: 'copy'

    input:
    tuple val(barcode), path(barcode_dir)

    output:
    tuple val(barcode), path("barcode_${barcode}.fastq.gz"), emit: fastq_combine
    path "Nanoplot_${barcode}/", emit: nanoplot_output

    script:
    """

    cat ${barcode_dir}/*.fastq.gz > barcode_${barcode}.fastq.gz

    NanoPlot -t2 \\
        -o Nanoplot_${barcode} \\
        --fastq barcode_${barcode}.fastq.gz
    """
}