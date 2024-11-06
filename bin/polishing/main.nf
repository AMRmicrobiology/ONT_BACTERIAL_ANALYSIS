process POLISHING_ROUND {
    tag "Polishing round ${round} for ${barcode_id}"

    input:
    val(barcode_id)
    path(input_fasta)  // Archivo fasta que se va actualizando en cada ronda
    path(input_reads)  // Archivo de lecturas constante, asociado a cada barcode_id
    val(round)         // Número de la ronda actual

    output:
    tuple val(barcode_id), path("racon_round${round}_${barcode_id}.fasta") into polished_ch  // Archivo fasta pulido para la próxima ronda

    script:
    def aln_file = "aln_round${round}.sam"
    """
    # Paso 1: Alineación con Minimap2
    minimap2 -ax map-ont ${input_fasta} ${input_reads} > ${aln_file}

    # Paso 2: Pulido con Racon
    racon ${input_reads} ${aln_file} ${input_fasta} > racon_round${round}_${barcode_id}.fasta
    """
}