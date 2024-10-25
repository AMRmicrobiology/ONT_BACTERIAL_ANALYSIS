process TRIMMING {
    tag "prunning process"

    input:

    tuple val(barcode_id), path(fastq_file)


    output:

    tuple val(barcode_id), path ("${barcode_id}_clean.fastq"), emit: barcodefile_gz

    script:

    """
    filtlong --min_length 1000 --keep_percent 90 --min_mean_q 10 ${fastq_file} > filtered_${barcode_id}.fastq

    porechop -i filtered_${barcode_id}.fastq -o ${barcode_id}_clean.fastq > porechop.log 2>&1

    NanoStat --fastq ${barcode_id}_clean.fastq > NanoStat.log

    """
}