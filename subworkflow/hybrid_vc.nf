/*
DSL2 channels
*/
nextflow.enable.dsl=2

log.info """\

    WGS ONT - HYBRID VARIANT  CALLING

            P A R A M E T R E S
==============================================
Configuration environemnt:
    Out directory:             $params.outdir
    Fastq directory:           $params.input
    Reference directory:       $params.reference
"""
    .stripIndent()

//Call all the sub-work

include { QC                                          }     from '../bin/qc/main'
include { TRIMMING                                    }     from '../bin/trimming/main'
include { SUB_SAMPLE                                  }     from '../bin/assemble/trycycler/subsample_main'
include { SUB_SAMPLE_1                                }     from '../bin/assemble/canu/main'

/*

include { SUB_SAMPLE_2                                }     from '../bin/assemble/fly/main'
include { SUB_SAMPLE_3                                }     from '../bin/assemble/raven/main'
include { MERGE_ASSEMBLE                              }     from '../bin/assemble/main'
include { POLISHING_1                                 }     from '../bin/assemble/main'
include { CONSENSUM                                   }     from '../bin/assemble/main'
include { POLISHING_2                                 }     from '../bin/assemble/main'
include { QUAST                                       }     from '../bin/qc/quast/main'
include { PROKKA                                      }     from '../bin/anotations/prokka/main'
include { BAKTA                                       }     from '../bin/anotations/bakta/main'
include { BUILD_INDEX_1                               }     from '../bin/bowtie/index/main_bwa'
include { BUILD_INDEX as PERSONAL_GENOME_INDEX        }     from '../bin/bowtie/index/main'
include { PERSONAL_GENOME_MAPPING                     }     from '../bin/bowtie/mapping/main'
include { MARKDUPLICATE                               }     from '../bin/gatk/picard/markduplicate/main'
include { ADDORREPLACE                                }     from '../bin/gatk/picard/addorreplace/main'
include { HAPLOTYPECALLER                             }     from '../bin/gatk/haplotype/main'
include { GENOTYPE as GENOTYPE_ANALYSIS               }     from '../bin/gatk/genotype/main'
include { ALIGN as NORMALICE_WILDTYPE                 }     from '../bin/gatk/Filter/align'
include { FILTER_VARIANTS as FILTER_VARIANTS_PARAM    }     from '../bin/gatk/Filter/main'
include { AGT                                         }     from '../bin/anotations/main'
include { DECOMPRESS_VCF                              }     from '../bin/snpeff/main_2'
include { SNPEFF                                      }     from '../bin/snpeff/main'
include { AMR as POST_ANALYSIS_ABRICATE               }     from '../bin/AMR/abricate/main'
include { AMR_2 as POST_ANALYSIS_AMRFINDER            }     from '../bin/AMR/AMRFinder/main'
*/




workflow hybrid_vc {
    preprocess_output = pre_process()
    assambleprocess_output = assamble_process(preprocess_output.trimming_ch)
     /*
    vcprocess_output = workflow_vc()
    amrprocess_output = workflow_amr( preprocess_output.contigs_ch)
    */
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

    genome_size_map = file("$params.genome_size_file")
                          .splitCsv(header:true)
                          .collectEntries { row -> [(row.barcode): row.genome_size]}

    subsample_trycycler_ch = SUB_SAMPLE(trimming_ch, genome_size_map)
    
    genome_size_ch = Channel
                        .fromPath(params.genome_size_file)
                        .splitCsv(header: true)
                        .map { row -> tuple(row.barcode, row.genome_size as int) }

    reads_with_size_ch = subsample_trycycler_ch.join(genome_size_ch)

    sub_sample_1_canu_ch = SUB_SAMPLE_1(reads_with_size_ch)
    

    
    /*


    
    sub_sample_2_fly_ch = SUB_SAMPLE_2(reads_with_size_ch)
    sub_sample_3_raven_ch = SUB_SAMPLE_3(reads_with_size_ch)

    


    emit:
    */
}


////////////////////////////////////////////////////////////////////////////////
//                                 FUNCTIONS                                  //
////////////////////////////////////////////////////////////////////////////////

def checkInputParams() {
    // Check required parameters and display error messages
    boolean fatal_error = false
    if ( ! params.input) {
        log.warn("You need to provide a fastqDir (--fastqDir) or a bamDir (--bamDir)")
        fatal_error = true
    }
}