process MERGE_ASSEMBLE {
    tag "Merge assemble using Trycyler ${barcode_id} "

    container "$params.trycyler.docker"

    input:
    tuple val(barcode_id), path(barcodefile), val(genome_size), path(assembly_canu_file), path(fly_assambly_tuple), path(raven_aseembly_file)

    output:
    path "clustering_${barcode_id}/", emit: merge_assemblies_trycycler
    tuple val(barcode_id), path()


    script:
    """
    trycycler cluster \
        -a ${assembly_canu_file} \
           ${fly_assambly_tuple} \
           ${raven_aseembly_file} \
        -r ${barcodefile} \
        -o clustering_${barcode_id}

    for cluster_dir in clustering_${barcode_id}/cluster_*; do
        trycycler summarize --cluster_dir \$cluster_dir
    done
    """
}