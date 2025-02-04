# ONT_BACTERIAL_ANALYSIS

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![license-shield]][license-url]


## Introduction
This repository hosts a pipeline buikd with Nextflow for whole-genome sequencing (WGS) analysis specifically otimised for **Oxford Nanopore Technology (ONT)** data of bacterial genomes. It is designed to offer an automated, reproducible, and scalable solution for processing large-scale genomic data in clinical microbiology research.

## Contents
- [Pipeline summary](#pipeline-summary)
    - [Assemble](#reference-genome)
    - [Hybrid](#Hybrid)
- [Installation](#installation)
- [How to Use It](#how-to-use-it)
    - [Parameters](#parameters)
- [References](#reference)



## Pipeline summary

The pipeline includes the following steps:

1. **Quality control**: Assessment of read quality before and after filtering using [Nanocomp](https://github.com/wdecoster/nanocomp). Filtering of low-quality bases and short reads was performed using [Filtlong](https://github.com/rrwick/Filtlong) followed by removal of adapter ONT adapter sequences using [Porechop](https://github.com/rrwick/Porechop).

The mode --assemble is followed by:

2. **Assembly**: *De novo* assembly using the single-moleucle assembler [Flye](https://github.com/mikolmogorov/Flye) followed by a **polishing** step and the construction of a consensus sequence using [Medaka](https://github.com/nanoporetech/medaka). 

    * <ins>Polishing process</ins>: The optimal number of polishing rounds is determined automatically using the CART algorithm. The prediction is based on multiple parameters, which include error rate, N50/L50, genome coverage, Total Length of Matches, Average Occurrences, Distinct Minimizers, and processing time per round.

<center>
<table>
    <thead>
        <tr>
            <th align= "center"> Source </th>
            <th align= "center"> Parameter </th>
            <th align= "center"> Description </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="4" align="center">Minimap2 </td>
            <td align="center">DistinctMinimizers </td>
            <td align="center">Number of unique minimizers found (Minimap2 value),change < 0.1% in distinct minimizers </td>
        </tr>
        <tr>
            <td align="center">AverageOccurrences </td>
            <td align="center">Average occurrences of minimizers (Minimap2),change < 0.01 in average occurrences </td>
        </tr>
        <tr>
            <td align="center">TotalLengthMatches </td>
            <td align="center">Total length of aligned matches,change < 0.1% </td>
        </tr>
        <tr>
            <td align="center">ProcessingTime </td>
            <td align="center">	Total execution time per round (Racon or Minimap2), change < 5%</td>
        </tr>
        <tr>
            <td rowspan="1" align= "center"> RACON </td>
            <td align= "center"> Processing Time </td>
            <td align= "center"> Change < 5% </td>
        </tr>
        <tr>
            <td rowspan="1" align= "center"> QUAST </td>
            <td align= "center"> N50/L50 </td>
            <td align= "center"> Minimum contig length that covers 50% of the assembly, change < 100 bp </td>
        </tr>
        <tr>
            <td rowspan="1" align= "center"> QUAST/MEDAKA </td>
            <td align="center"> ErrorRate </td>
            <td align="center">	Error rate in the sequence after each polishing round </td>
        </tr>
        <tr>
            <td rowspan="1" align= "center"> BUSCO </td>
            <td align= "center"> Completeness (BUSCO) </td>
            <td align ="center"> Change < 1% in complete genes </td>
        </tr>
        <tr>
            <td rowspan=1 align= "center"> Target Value </td>
            <td align= "center"> Optional Rounds </td>
            <td align ="center"> Optimal number of rounds needed to achieve convergence </td>
        </tr>
    <t/body>
</table>
</center>

3. **Genome QC**:  Structural quality metrics of the assembly will be evaluated using [QUAST](https://quast.sourceforge.net/) and its completeness with [BUSCO](https://busco.ezlab.org/). 

4. **Post-assembly analyses**:
    *   Mass screening of contigs for antimicrobial resistance or virulence genes using [ABRIcate](https://github.com/tseemann/abricate).
    * Identification of antimicrobial resistance genes and point mutations in protein and/or assembled nucleotide sequences using [AMRFinder](https://github.com/ncbi/amr).
    * Scan genome against traditional PubMLST schemes using [mlst](https://github.com/tseemann/mlst). 

# Installation
The prerequisites to run the pipeline are:
- Install [Nextflow](https://github.com/nextflow-io/nextflow)
- Install [Docker](https://github.com/docker/docker-install) or [Singularity](https://github.com/sylabs/singularity-admindocs/blob/main/installation.rst) for container support
- Ensure [Java 8](https://github.com/winterbe/java8-tutorial) or higher is installed

Clone the Repository:

```
# Clone the workflow repository
git clone https://github.com/AMRmicrobiology/ONT_BACTERIAL_ANALYSIS.git

# Move inside the main directory
cd ONT_BACTERIAL_ANALYSIS
```
<!-- compl -->
### Local (conda)

  ```
  conda create -n Nanopore -f nanoporeWGS.yml busco.yml
  conda activate Nanopore
  ```

# How to use it?

Inside the ONT_BACTERIAL_ANALYSIS directory, modify the file  **genome_size.csv** to include for each barcode included, its expected genome size (bp) and the sample code you want to assign:
>[!IMPORTANT]
The sample code names should not include "-"

e.g.
```
barcode,genome_size,sample_code
barcode01,3000000,306 
barcode02,4500000,C2_72
barcode03,5000000,C2_75
barcode04,4000000,C2_76
barcode05,3200000,ST89
barcode06,3500000,ST23
```
Run the pipeline using the following command, adjusting the parameters as needed:

*ASSEMBLE*
```
nextflow run main.nf --mode assemble --genome_size_file barcode_info.csv --input '/path/to/data/barcode*' -profile <docker/singularity/conda>
```
### Parameters

--mode: Depends on the analysis assemble / hybrid_amr / hybrid_vc.

--input: Path to input folders containing the raw .fastq files for each barcode after performing ONT absecalling.

--outdir: Directory where the results will be stored (default: ONT_BACTERIAL_ANALYSIS/data/out).

-profile: Specifies the execution profile (docker, singularity or conda).

--enome_size_file: .csv file containing the expected genome size and sample code per each of the barcodes.


#### Optional parameters

-w: Path to the temporary work directory where files will be stored (default: ./work).

##### Filter
--min_length: Minimum length threshold (bp). Default: 1000 

--min_mean_q: minimum mean quality threshold. Default: 10

--keep_percent: Throw out the worst (100-x)% of read bases. Default: 90 (throw the worst 10% of read bases) 

## REFERENCE

[Benchmarking reveals superiority of deep learning variant callers on bacterial nanopore sequence data](https://elifesciences.org/articles/98300)
[How low can you go? Short-read polishing of Oxford Nanopore bacterial genome assemblies](https://www.microbiologyresearch.org/content/journal/mgen/10.1099/mgen.0.001254)

[Evaluation of the accuracy of bacterial genome reconstruction with Oxford Nanopore R10.4.1 long-read-only sequencing](https://www.microbiologyresearch.org/content/journal/mgen/10.1099/mgen.0.001246)

[Assembling the perfect bacterial genome using Oxford Nanopore and Illumina sequencing](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1010905)








[contributors-shield]: https://img.shields.io/github/contributors/jimmlucas/DIvergenceTimes.svg?style=for-the-badge
[contributors-url]: https://github.com/jimmlucas/DIvergenceTimes/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/jimmlucas/DIvergenceTimes.svg?style=for-the-badge
[forks-url]: https://github.com/jimmlucas/DIvergenceTimes/network/members

[stars-shield]: https://img.shields.io/github/stars/jimmlucas/DIvergenceTimes.svg?style=for-the-badge
[stars-url]: https://github.com/gjimmlucas/DIvergenceTimes/stargazers

[issues-shield]: https://img.shields.io/github/issues/jimmlucas/DIvergenceTimes.svg?style=for-the-badge
[issues-url]: https://github.com/jimmlucas/DIvergenceTimes/issues

[license-shield]: https://img.shields.io/github/license/jimmlucas/DIvergenceTimes.svg?style=for-the-badge
[license-url]: https://github.com/jimmlucas/DIvergenceTimes/blob/master/LICENSE.txt
