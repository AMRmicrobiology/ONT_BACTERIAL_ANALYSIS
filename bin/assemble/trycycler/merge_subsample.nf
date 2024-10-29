process MERGE_ASSEMBLE {
    tag "Merge assemble using Trycyler"

    container "$params.trycyler.docker"

    input:
    tuple val(barcode_id), path(barcode_canu_file), path(barcode_fly_file), path(barcode_raven_file), path(barcodefile_gz)

    output:
    path("clustering/")


    script:
    """
    trycycler cluster --assemblies ${barcode_canu_file}, ${barcode_fly_file}, ${barcode_raven_file}\
        --reads ${barcodefile_gz}\
        --out_dir clustering
    """
}