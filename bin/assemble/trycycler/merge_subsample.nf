process MERGE_ASSEMBLE {
    tag "Merge assemble using Trycycler ${barcode_id}"

    publishDir "${params.outdir}/6-merge_assemble", mode: 'copy'
    container "$params.trycyler.docker"

    input:
    tuple val(barcode_id), path(barcodefile), val(genome_size), val(sample_code), path(assembly_canu_file), path(fly_assambly_tuple), path(raven_aseembly_file)

    output:
    path "clustering_${barcode_id}/", emit: merge_assemblies_trycycler

    script:
    """
    # Paso 1: Crear clusters con Trycycler
    trycycler cluster \
        -a ${assembly_canu_file} \
           ${fly_assambly_tuple} \
           ${raven_aseembly_file} \
        -r ${barcodefile} \
        -o clustering_${barcode_id}
        --threads 8

    # Paso 2: Filtrar clusters automáticamente con el script externo
    ${params.filterClustersScript} clustering_${barcode_id}

    # Verificar si hay clusters válidos
    cluster_count=\$(find clustering_${barcode_id}/ -type d -name "cluster_*" | wc -l)

    if [[ "\$cluster_count" -eq 0 ]]; then
        echo "No se encontraron clusters válidos. Abortando." >&2
        exit 1
    fi

    # Paso 3: Reconciliar clusters buenos
    for cluster_dir in clustering_${barcode_id}/cluster_*; do
        trycycler reconcile \
            --cluster_dir \$cluster_dir \
            --reads ${barcodefile}
    done

    # Paso 3: Reconciliar clusters buenos
    for cluster_dir in clustering_${barcode_id}/cluster_*; do
        trycycler reconcile \
            --cluster_dir \$cluster_dir \
            --reads ${barcodefile}
    done

    # Paso 4: Generar alineamientos múltiples
    trycycler msa \
        --clusters_dir clustering_${barcode_id}

    # Paso 5: Particionar lecturas en clusters
    trycycler partition \
        --clusters_dir clustering_${barcode_id} \
        --reads ${barcodefile}

    # Paso 6: Construir consenso
    trycycler consensus \
        --clusters_dir clustering_${barcode_id}
    """
}