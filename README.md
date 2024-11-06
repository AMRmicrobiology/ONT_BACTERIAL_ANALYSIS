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


For a multiplex input must to add a file **genome_size.csv**  with size of each genome (bp) per barcode. :

e.g
```
barcode,genome_size
01,3000000
02,4500000
03,5000000
04,4000000
05,3200000
06,3500000

```


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