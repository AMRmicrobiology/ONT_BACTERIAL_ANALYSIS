#!/bin/bash
clustering_dir=$1

for cluster_dir in "${clustering_dir}/cluster_"*; do
    # Verificar si el archivo 1_contigs.fasta existe
    if [[ ! -f "$cluster_dir/1_contigs.fasta" ]]; then
        echo "Archivo $cluster_dir/1_contigs.fasta no encontrado. Cluster ignorado."
        continue
    fi

    # Extraer información del cluster
    contig_count=$(grep -c ">" "$cluster_dir/1_contigs.fasta")
    longest_contig=$(awk '/^>/ {if (seq) print seq; seq=0} !/^>/ {seq+=length($0)} END {if (seq) print seq}' "$cluster_dir/1_contigs.fasta" | sort -nr | head -1)
    mean_depth=$(awk '/^>/ {getline; print}' "$cluster_dir/1_contigs.fasta" | grep -oP '\d+\.\d+' | awk '{sum+=$1} END {if (sum > 0 && NR > 0) print sum/NR; else print 0}')

    # Determinar si el cluster debe ser retenido
    if [[ "$longest_contig" -gt 1000 && "$mean_depth" -ge 10 && "$contig_count" -le 10 ]]; then
        echo "Cluster $cluster_dir aceptado."
    else
        echo "Cluster $cluster_dir rechazado por criterios de longitud/cobertura."
        rm -rf "$cluster_dir"
    fi
done