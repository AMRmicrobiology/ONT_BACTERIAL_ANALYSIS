process NANOCOMP {
    tag "Nanocomp process"

    publishDir "${params.outdir}/1-Nanoplot", mode: 'copy'

    input:
    path (barcode_dir)
    path (barcode_id_clean)

    output:

    path "Nanocomp"

    script:

    """
    
    Nanocomp --fastq ${barcode_dir} ${barcode_id_clean} -o Nanocomp
    
    """
}