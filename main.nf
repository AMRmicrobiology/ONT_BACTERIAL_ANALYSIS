nextflow.enable.dsl = 2

checkInputParams()

reference = file("${params.reference}")

log.info """\

WGS ONT - N F   P I P E L I N E 
==============================================
Configuration environment:
    Out directory:             $params.outdir
    Fastq directory:           $params.input
    Reference directory:       $params.reference
"""
    .stripIndent()

// Subworkflows 

if (params.mode == 'assemble') {
    include { assemble } from "$projectDir/subworkflow/assamble" 
} else if (params.mode == 'hybrid_amr') {
    include { hybrid_amr } from "$projectDir/subworkflow/hybrid_amr"
} else if (params.mode == 'hybrid_vc') {
    include { hybrid_vc} from "$projectDir/subworkflow/hybrid_vc"
} else {
    error "Invalid mode: ${params.mode}. Please specify 'assamble' ,'hybrid' or 'hybrid_vc'"
}

// Definir el workflow principal
workflow {
    if (params.mode == 'assemble') {
        assemble()  
    } else if (params.mode == 'hybrid_amr') {
        hybrid_amr()
    } else if (params.mode == 'hybrid_vc') {
        hybrid_vc()
    }
}


////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS                                                                  //
////////////////////////////////////////////////////////////////////////////////

def checkInputParams() {
    // Check required parameters and display error messages
    boolean fatal_error = false

    if (!params.input) {
        log.warn("You need to provide a fastqDir (--fastqDir) or a bamDir (--bamDir)")
        fatal_error = true
    }
}
