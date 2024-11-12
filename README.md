# ONT_BACTERIAL_ANALYSIS

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![license-shield]][license-url]




## Contents
- [Pipeline summary](#pipeline-summary)
    - [ASSEMBLE](#reference-genome)
    - [HIBRYD](#Hybrid)
- [Installation](#installation)
- [How to Use It](#how-to-use-it)
    - [Parameters](#parameters)
- [References](#reference)



## Pipeline summary:


Create for a multiplex input must to add a file **genome_size.csv**  with size of each genome (bp) per barcode. :

e.g
```
barcode,genome_size
barcode01,3000000
barcode02,4500000
barcode03,5000000
barcode04,4000000
barcode05,3200000
barcode06,3500000
```


### polishing process

The number of rounds necessary is defined automatically based on several parameters, including error rate, N50/L50, coverage, Total Length of Matches, Average Occurrences, Distinct Minimizers, and processing time per round.

<table>
    <thead>
        <tr>
            <th>Tool</th>
            <th>Parameter</th>
            <th>Convergence Threshold</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="4" align="center">Minimap2</td>
            <td align="center">Distinct Minimizers</td>
            <td align="center">Change < 0.1% in distinct minimizers</td>
        </tr>
        <tr>
            <td align="center">Average Occurrences</td>
            <td align="center">Change < 0.01 in average occurrences</td>
        </tr>
        <tr>
            <td align="center">Total Length of Matches</td>
            <td align="center">Change < 0.1%</td>
        </tr>
        <tr>
            <td align="center">Processing Time</td>
            <td align="center">	Change < 5%</td>
        </tr>
        <tr>
            <td rowspan=1 align= "center"> RACON </td>
            <td align= "center"> Processing Time </td>
            <td align= "center"> Change < 5% </td>
        </tr>
        <tr>
            <td rowspan=1 align= "center"> QUAST </td>
            <td align= "center"> N50/L50 </td>
            <td align= "center"> Change < 100 bp </td>
        </tr>
        <tr>
            <td rowspan=1 align= "center"> BUSCO </td>
            <td align= "center"> Completeness (BUSCO) </td>
            <td align ="center">Change < 1% in complete genes </td>
        </tr>
    <t/body>
</table>



## COMAND LINE
```
nextflow run main.nf --mode assemble --genome_size_file barcode_info.csv -profile <docker/singularity/conda>
```

--mode : assemble / hybrid_amr / hybrid_vc 
-profile:


## REFERENCE

[Benchmarking reveals superiority of deep learning variant callers on bacterial nanopore sequence data](https://elifesciences.org/articles/98300)
[How low can you go? Short-read polishing of Oxford Nanopore bacterial genome assemblies](https://www.microbiologyresearch.org/content/journal/mgen/10.1099/mgen.0.001254)
[Evaluation of the accuracy of bacterial genome reconstruction with Oxford Nanopore R10.4.1 long-read-only sequencing](https://www.microbiologyresearch.org/content/journal/mgen/10.1099/mgen.0.001246)









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