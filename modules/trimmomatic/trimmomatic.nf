
params.saveMode = 'copy'
params.resultsDir = 'results/trimmomatic'



process TRIMMOMATIC {
    publishDir params.resultsDir, mode: params.saveMode
    container 'quay.io/biocontainers/trimmomatic:0.35--6'
    cpus 8
    memory "16 GB"

    input:
    tuple genomeName, file(genomeReads)

    output:
    path("*_{R1,R2}.p.fastq.gz")

    script:

    fq_1_paired = genomeName + '_R1.p.fastq.gz'
    fq_1_unpaired = genomeName + '_R1.s.fastq.gz'
    fq_2_paired = genomeName + '_R2.p.fastq.gz'
    fq_2_unpaired = genomeName + '_R2.s.fastq.gz'

    """
    trimmomatic \
    PE \
    -threads ${task.cpus} \
    -phred33 \
    ${genomeReads[0]} \
    ${genomeReads[1]} \
    $fq_1_paired \
    $fq_1_unpaired \
    $fq_2_paired \
    $fq_2_unpaired \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
    """
}


