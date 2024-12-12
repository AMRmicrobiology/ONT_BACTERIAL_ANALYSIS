process CONCILIACION_ASSEMBLY {
    tag "Conciliacion_process ${barcode_id}"
    


    input:
    



    output:



    script:

    """
    trycycler reconcile \
        --clusters clustering_barcode12/cluster_001/1_contigs \
                    clustering_barcode12/cluster_002/1_contigs \
                    clustering_barcode12/cluster_003/1_contigs \
        --reads combine_barcode12.fastq
    """
}
