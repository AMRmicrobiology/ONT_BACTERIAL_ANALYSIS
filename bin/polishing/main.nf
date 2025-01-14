process POLISHING_ROUND {
    tag "Polishing ${sample_code} for ${max_rounds} rounds"

    input:
    tuple val(sample_code), path(trimmed_reads), path(assembly_fasta), val(max_rounds)

    output:
    tuple val(sample_code), path("final_polished_${sample_code}.fasta")

    script:

    """
    # Archivo inicial para la primera ronda de pulido
    input_fasta=${assembly_fasta}

    # Ejecutar el número de rondas de pulido especificado en `max_rounds`
    for round in {1..${max_rounds}}; do
        aln_file="aln_round\${round}_${sample_code}.sam"
        output_fasta="racon_round\${round}_${sample_code}.fasta"

        # Paso 1: Alineación con Minimap2
        minimap2 -ax map-ont \${input_fasta} ${trimmed_reads} > \${aln_file}

        # Paso 2: Pulido con Racon
        racon ${trimmed_reads} \${aln_file} \${input_fasta} > \${output_fasta}

        # Verificar que `racon` generó correctamente `output_fasta`
        if [ ! -f \${output_fasta} ]; then
            echo "Error: \${output_fasta} was not generated. Exiting." >&2
            exit 1
        fi

        # Actualizar `input_fasta` para la siguiente ronda con el archivo pulido actual
        input_fasta=\${output_fasta}
    done

    # Renombrar el archivo final para que sea `final_polished_${sample_code}.fasta`
    mv \${input_fasta} final_polished_${sample_code}.fasta
    """
}