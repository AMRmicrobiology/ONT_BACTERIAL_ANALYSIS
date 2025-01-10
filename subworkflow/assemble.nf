/*
DSL2 channels
*/
nextflow.enable.dsl=2

log.info """\

WGS - P A R A M E T R E S
==============================================
Configuration environemnt:
    Out directory:             $params.outdir
    Fastq directory:           $params.input
    Reference directory:       $params.reference
"""
    .stripIndent()

//Call all the sub-work

include { QC                                            }     from '../bin/qc/main'
include { TRIMMING                                      }     from '../bin/trimming/main'
include { SUB_SAMPLE_2 as ASSEMBLE                      }     from '../bin/assemble/fly/main'
include { POLISHING_ROUND                               }     from '../bin/polishing/main'
include { MEDAKA                                        }     from '../bin/assemble/medaka/main'
include { AMR                                           }     from '../bin/AMR/abricate/main'
include { AMR_2                                         }     from '../bin/AMR/resfinder/main'
include { QUAST                                         }     from '../bin/qc/quast/main'
include { MLST                                          }     from '../bin/mlst/main'

workflow assemble {
    preprocess_output = pre_process()
    assambleprocess_output = assamble_process(preprocess_output.trimming_ch)
}

workflow pre_process {
    take:
    main:
    barcode_dir_ch = channel.fromPath(params.input, type: 'dir').map{barcode_dir -> tuple(barcode_dir.baseName, barcode_dir)}
    qc_ch = QC(barcode_dir_ch)
    trimming_ch = TRIMMING(qc_ch.fastq_combine)

    emit:
    trimming_ch

}

workflow assamble_process {
    take:
    trimming_ch
    
    main:
    
    genome_size_ch = Channel
                        .fromPath(params.genome_size_file)
                        .splitCsv(header: true)
                        .map { row -> tuple(row.barcode, row.genome_size as int, row.sample_code) }

    reads_with_size_ch = trimming_ch.join(genome_size_ch)

    fly_ch = ASSEMBLE(reads_with_size_ch)

//POLISHING PROCESS
//Porcesar el emit del assembly en fly para determinar numeros de polishing
coverage_ch = fly_ch.info_cov
    .map { sample_code, info_file -> 
        // Lee el archivo `assembly_info.txt` y extrae la cobertura
        def cov_value = info_file
            .text
            .split("\n")  // Divide en líneas
            .drop(1)      // Omite la cabecera
            .collect { line -> line.split("\t")[2] as int }[0]  // Extrae la columna 'cov.' (índice 2) y convierte a int
        tuple(sample_code, cov_value)
    }


// Creacion de channel que combina los input para el procesamiento de polishing en relacion al coverage obtneido en fly 
    sample_fixe = reads_with_size_ch.map { tupla ->
        def pathread = tupla [1]
        def sample_code = tupla [3]
        return tuple(sample_code, pathread)}

    polished_ch = sample_fixe
        .join(fly_ch.fly_assambly_tuple)
        .join(coverage_ch)
        .map { sample_code, trimmed_reads, assembly_fasta, cov_value -> 
            def max_rounds = (cov_value <= 14) ? 8 : 5 //asignacion de numero de polishing ( nªround each raund inclue: minimap + racon )
            tuple(sample_code, trimmed_reads, assembly_fasta, max_rounds)
        }

    polished_ch_final = POLISHING_ROUND(polished_ch)

    medaka_ch = sample_fixe
    .join(polished_ch_final)
    .map { sample_code, trimmed_reads, final_polishing_fasta ->
        tuple(sample_code, trimmed_reads, final_polishing_fasta)
    }
   
    medaka_consensum_ch= MEDAKA(medaka_ch)

    quast_ch = QUAST(medaka_consensum_ch.assemble_medaka)

    amr_ch = AMR(medaka_consensum_ch.assemble_medaka)
    amr_2_ch = AMR_2(medaka_consensum_ch.assemble_medaka)
    mlst_ch = MLST(medaka_consensum_ch.assemble_medaka)

}
