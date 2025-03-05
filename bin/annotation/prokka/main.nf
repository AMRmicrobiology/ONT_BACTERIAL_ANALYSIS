process PROKKA {
    tag "PROKKA ANNOTATION"

    publishDir "${params.outdir}/2-assemble/annotations", mode: 'copy', saveAs: { filename ->
        if (filename.endsWith(".gff")) {
            return "6-prokka/${sample_code}/${sample_code}.gff"
        } else if (filename.endsWith(".faa")) {
            return "6-prokka/${sample_code}/${sample_code}.faa"
        } else if (filename.endsWith(".fna")) {
            return "6-prokka/${sample_code}/${sample_code}.fna"
        } else {
            return null
        }
    }

    input:
    tuple val (sample_code), path(assembly_file)

    output:
    path "annotations_${sample_code}/${sample_code}_wildtype.gff", emit: prokka_gff
    path "annotations_${sample_code}/${sample_code}_wildtype.faa", emit: prokka_faa
    path "annotations_${sample_code}/${sample_code}_wildtype.fna", emit: prokka_fna

    script:
    """
    prokka --outdir annotations_${sample_code} --prefix ${sample_code}_wildtype --kingdom Bacteria ${assembly_file}
    """
}