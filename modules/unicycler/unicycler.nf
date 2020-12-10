nextflow.enable.dsl = 2

params.resultsDir = "${params.outdir}/unicycler"
params.saveMode = 'copy'
params.shouldPublish = true

process UNICYCLER {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish
    container 'quay.io/biocontainers/unicycler:0.4.8--py38h8162308_3'
    cpus 16
    memory "32 GB"

    input:
    tuple val(genomeName),  path(genomeReads)

    output:
    path("${genomeName}")

    script:

    """
    unicycler  \
    -t ${task.cpus} \
    --keep 0 \
    --short1 ${genomeReads[0]} \
    --short2 ${genomeReads[1]} \
    --out ${genomeName} 
    """

}


workflow test {

    input_ch = Channel.fromFilePairs("$launchDir/test_data/*_{1,2}.fastq.gz")

    UNICYCLER(input_ch)

}
