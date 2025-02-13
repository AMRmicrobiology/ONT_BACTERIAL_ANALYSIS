process TRIMMING {
    tag "prunning process"
    
    input:
    tuple val(barcode_id), path(fastq_file)
    
    output:
    tuple val(barcode_id), path("${barcode_id}_clean.fastq"), emit: barcodefile_gz
    tuple val(barcode_id), path("${barcode_id}_NanoStat.log"), emit: stat_post_trimming
    tuple val(barcode_id), path("${barcode_id}_clean.fastq.gz"), emit: barcodefile_compress
    
    // Define default parameter values with fallback
    def min_length = params.min_length ?: 500
    def keep_percent = params.keep_percent ?: 90
    def min_mean_q = params.min_mean_q ?: 10 
    
    script:
    """
    filtlong --min_length ${min_length} --keep_percent ${keep_percent} --min_mean_q ${min_mean_q} ${fastq_file} > filtered_${barcode_id}.fastq

    porechop -i filtered_${barcode_id}.fastq -o ${barcode_id}_clean.fastq > porechop.log 2>&1

    NanoStat --fastq ${barcode_id}_clean.fastq > ${barcode_id}_NanoStat.log

    gzip -k ${barcode_id}_clean.fastq
    """
}