/*
DSL2 channels
*/
nextflow.enable.dsl=2

checkInputParams()

reference         = file("${params.reference}")

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

include { FASTQC_QUALITY as FASTQC_QUALITY_ORIGINAL           }     from '../bin/qc/fastqc/main'
include { TRIMMING                                            }     from '../bin/trimming/main'
include { FASTQC_QUALITY as FASTQC_QUALITY_FINAL              }     from '../bin/qc/fastqc/main'
include { ASSEMBLE                                            }     from '../bin/assemble/main'
include { QUAST                                               }     from '../bin/qc/quast/main'
include { MULTIQC                                             }     from '../bin/qc/multiqc/main' 
include { PROKKA                                              }     from '../bin/anotations/prokka/main'
include { BAKTA                                               }     from '../bin/anotations/bakta/main'
include { BUILD_INDEX_1                                       }     from '../bin/bowtie/index/main_bwa'
include { BUILD_INDEX as PERSONAL_GENOME_INDEX                }     from '../bin/bowtie/index/main'
include { PERSONAL_GENOME_MAPPING                             }     from '../bin/bowtie/mapping/main'
include { MARKDUPLICATE                                       }     from '../bin/gatk/picard/markduplicate/main'
include { ADDORREPLACE                                        }     from '../bin/gatk/picard/addorreplace/main'
include { HAPLOTYPECALLER                                     }     from '../bin/gatk/haplotype/main'
include { GENOTYPE as GENOTYPE_ANALYSIS                       }     from '../bin/gatk/genotype/main'
include { ALIGN as NORMALICE_WILDTYPE                         }     from '../bin/gatk/Filter/align'
include { FILTER_VARIANTS as FILTER_VARIANTS_PARAM            }     from '../bin/gatk/Filter/main'
include { AGT                                                 }     from '../bin/anotations/main'
include { DECOMPRESS_VCF                                      }     from '../bin/snpeff/main_2'
include { SNPEFF                                              }     from '../bin/snpeff/main'
include { AMR as POST_ANALYSIS_ABRICATE                       }     from '../bin/AMR/abricate/main'
include { AMR_2 as POST_ANALYSIS_AMRFINDER                    }     from '../bin/AMR/AMRFinder/main'
/*



*/
workflow novo {
    preprocess_output = workflow_pre_process()
    assambleprocess_output = workflow_post_process(preprocess_output.personal_ref_ch, preprocess_output.fq_gz_reads_ch)
    amrprocess_output = workflow_amr( preprocess_output.contigs_ch)
}