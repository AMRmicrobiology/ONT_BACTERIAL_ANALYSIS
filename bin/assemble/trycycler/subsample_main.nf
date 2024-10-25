process SUB_SAMPLE {
    tag "SUB SAMPLE TRYCYCLER FROM LONG READS"

    container "$params.trycyler.docker"

    input:

    tuple val(barcode_id), path(barcode_file)

    output:

    path("subsample_${barcode_id}/")


    script:

    def genome_size = genome_size_map[barcode_id]
    """
    trycycler subsample \\
        --reads ${barcode_file} \\ 
        --out_dir subsample_${barcode_id} \\
        --genome_size ${genome_size}
    """

}