---
title: "Build UCSC Track Hub from NCBI bigWigs"
author: "Jeffrey Long"
date: "10/15/2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## NCBI To UCSC

[The Natioinal Center for Biotechnology Information, NCBI](https://www.ncbi.nlm.nih.gov/) supplies data
presented in scientific publications. These data support
a wide range of experiments, including cancer research. 

The [UCSC Genome Browser](https://genome.ucsc.edu) is 
a widely used visualization tool for genomic data. 
Genomic functional features can be presented in many ways.

This effort acquires data from NCBI and 
uses tools developed by Jim Kent at UCSC to 
liftOver genomic data from human reference genome hg19 to hg38. 
The resulting bigWigs are then annotated to allow visualization 
in the UCSC Track Hubs. Within the UCSC Genome Browser, 
hypotheses can be generated and tested using a suite of 
tools in the UCSC Table Browser.

## PLAN

* Get data
* Get toolchain
* Convert [hg18].wig to [hg18].bigwig using wigToBigWig
* Convert [hg18].bigwig to [hg18].bed using bigwigToBedGraph
* Lift over the [hg18].bed to [hg38].bed
* Convert the[hg38].bed back to bigwig using bedGraphToBigWig
* Generated UCSC Track Hub files

### DATA

The test data to be used is from Gozani lab, generated in 2011 
and published by Kuo et. al. in "NSD2 links dimethylation of histone H3 at lysine 36 to oncogenic programming". Two samples of chromatin
immunoprecipitation next generation sequencing data (ChIP-Seq) 
will be used as examples. The control sample is labelled "input". 
The experimental data is "H3K36me2". Both data are for the biosample TKO2.

```{bash}
## Uncomment the next two lines to install wget on Mac OS.
# curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install
# brew install wget --with-libressl
wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM721nnn/GSM721530/suppl/GSM721530_TKO2_H3K36me2_rep1.wig.gz
wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM721nnn/GSM721532/suppl/GSM721532_TKO2_input.wig.gz
```


## GET TOOLCHAIN

```{bash}
# Get toolchain
wget http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/wigToBigWig
wget http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/bigWigToBedGraph
wget http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/liftOver
wget http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/bedRemoveOverlap
wget http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/bedGraphToBigWig

# Adjust toolchain permissions
chmod 755 wigToBigWig
chmod 755 bigWigToBedGraph
chmod 755 liftOver
chmod 755 bedRemoveOverlap
chmod 755 bedGraphToBigWig

# Chain files specify mapping from one reference to another.
# This example uses hg18ToHg38.over.chain.
# The other two are commonly used.
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz' -O hg19ToHg38.over.chain.gz
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg18/liftOver/hg18ToHg38.over.chain.gz' -O hg18ToHg38.over.chain.gz
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/liftOver/hg38ToHg19.over.chain.gz' -O hg38ToHg19.over.chain.gz
chmod 755 hg19ToHg38.over.chain.gz
chmod 755 hg18ToHg38.over.chain.gz
chmod 755 hg38ToHg19.over.chain.gz
gunzip hg19ToHg38.over.chain.gz
gunzip hg18ToHg38.over.chain.gz
gunzip hg38ToHg19.over.chain.gz
chmod 755 hg19ToHg38.over.chain
chmod 755 hg18ToHg38.over.chain
chmod 755 hg38ToHg19.over.chain

```

## WIG to BIGWIG to BED, liftOver to hg38 to BIGWIG

Wig or wiggle files need to be converted to bigWig (bw) files 
before they can be converted to bed files. Further, bed files 
are required input format for liftOver, which maps the data to 
a new reference genome.

```{bash}
# Convert wigs to bigWigs
# The hg18.chrom.sizes file is retrieved from ucsc for 
#     conversion to bigWig
# Clip will issue warnings instead of killing process
#     when data does not map to chom.sizes.
./wigToBigWig GSM721532_TKO2_input.wig.gz http://hgdownload.cse.ucsc.edu/goldenPath/hg18/bigZips/hg18.chrom.sizes GSM721532_TKO2_input.wig.gz.bw -clip
./wigToBigWig GSM721530_TKO2_H3K36me2_rep1.wig.gz http://hgdownload.cse.ucsc.edu/goldenPath/hg18/bigZips/hg18.chrom.sizes GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw -clip

# Convert bigWig (bw) to bed (bedGraph)
# liftOver require bed formatted input files
./bigWigToBedGraph GSM721532_TKO2_input.wig.gz.bw GSM721532_TKO2_input.wig.gz.bw.bedGraph
./bigWigToBedGraph GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph


# liftOver from hg18 to hg38
./liftOver GSM721532_TKO2_input.wig.gz.bw.bedGraph hg18ToHg38.over.chain GSM721532_TKO2_input.wig.gz.bw.bedGraph.hg38 GSM721532_TKO2_input.wig.gz.bw.bedGraph.unMapped
./liftOver GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph hg18ToHg38.over.chain GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph.hg38 GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph.unMapped

# Bed files must be sorted 
sort -k1,1 -k2,2n GGSM721532_TKO2_input.wig.gz.bw.bedGraph.hg38 > GSM721532_TKO2_input.wig.gz.bw.bedGraph.hg38.sorted
sort -k1,1 -k2,2n GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph.hg38 > GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph.hg38.sorted

# Remove overlapping annotation from bed files
./bedRemoveOverlap GSM721532_TKO2_input.wig.gz.bw.bedGraph.hg38.sorted GSM721532_TKO2_input.wig.gz.bw.bedGraph.hg38.sorted.noOverlap
./bedRemoveOverlap GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph.hg38.sorted GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph.hg38.sorted.noOverlap

# Convert bed files to bigWig files
./bedGraphToBigWig GSM721532_TKO2_input.wig.gz.bw.bedGraph.hg38.sorted.noOverlap http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes GSM721532_TKO2_input.wig.gz.bw.bedGraph.hg38.sorted.noOverlap.bw
./bedGraphToBigWig GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph.hg38.sorted.noOverlap http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes GSM721530_TKO2_H3K36me2_rep1.wig.gz.bw.bedGraph.hg38.sorted.noOverlap.bw
```

## GENERATE TRACK HUB FILES


## TOOL DESCRIPTIONS

### wigToBigWig v 4
Convert ascii format wig file (in fixedStep, 
variableStep or bedGraph format) to binary big wig format.

usage:

   wigToBigWig in.wig chrom.sizes out.bw

Where in.wig is in one of the ascii wiggle formats, but not including track lines
and chrom.sizes is a two-column file/URL: <chromosome name> <size in bases>
and out.bw is the output indexed big wig file.

If the assembly <db> is hosted by UCSC, chrom.sizes can be a URL like
  http://hgdownload.cse.ucsc.edu/goldenPath/<db>/bigZips/<db>.chrom.sizes
or you may use the script fetchChromSizes to download the chrom.sizes file.
If not hosted by UCSC, a chrom.sizes file can be generated by running
twoBitInfo on the assembly .2bit file.

options:

* blockSize=N - Number of items to bundle in r-tree.  Default 256
* itemsPerSlot=N - Number of data points bundled at lowest level. Default 1024
* clip - If set just issue warning messages rather than dying if wig
                  file contains items off end of chromosome.
* unc - If set, do not use compression.
* fixedSummaries - If set, use a predefined sequence of summary levels.
* keepAllChromosomes - If set, store all chromosomes in b-tree.

### bigWigToBedGraph 
Convert from bigWig to bedGraph format.

usage:

   bigWigToBedGraph in.bigWig out.bedGraph

options:

* chrom=chr1 - if set restrict output to given chromosome
* start=N - if set, restrict output to only that over start
* end=N - if set, restict output to only that under end
* udcDir=/dir/to/cache - place to put cache for remote bigBed/bigWigs

### liftOver 
Move annotations from one assembly to another

usage:

   liftOver oldFile map.chain newFile unMapped

oldFile and newFile are in bed format by default, but can be in GFF and
maybe eventually others with the appropriate flags below.

The map.chain file has the old genome as the target and the new genome
as the query.

***********************************************************************
WARNING: liftOver was only designed to work between different
         assemblies of the same organism. It may not do what you want
         if you are lifting between different organisms. If there has
         been a rearrangement in one of the species, the size of the
         region being mapped may change dramatically after mapping.
***********************************************************************

options:

* minMatch=0.N Minimum ratio of bases that must remap. Default 0.95
* gff  File is in gff/gtf format.  Note that the gff lines are converted
         separately.  It would be good to have a separate check after this
         that the lines that make up a gene model still make a plausible gene
         after liftOver
* genePred - File is in genePred format
* sample - File is in sample format
* bedPlus=N - File is bed N+ format
* positions - File is in browser "position" format
* hasBin - File has bin value (used only with -bedPlus)
* tab - Separate by tabs rather than space (used only with -bedPlus)
* pslT - File is in psl format, map target side only
* ends=N - Lift the first and last N bases of each record and combine the
             result. This is useful for lifting large regions like BAC end pairs.
* minBlocks=0.N Minimum ratio of alignment blocks or exons that must map
                  (default 1.00)
* fudgeThick    (bed 12 or 12+ only) If thickStart/thickEnd is not mapped,
                  use the closest mapped base.  Recommended if using 
               * minBlocks.
* multiple               Allow multiple output regions
* minChainT, -minChainQ  Minimum chain size in target/query, when mapping
                           to multiple output regions (default 0, 0)
* minSizeT               deprecated synonym for -minChainT (ENCODE compat.)
* minSizeQ               Min matching region size in query with -multiple.
* chainTable             Used with -multiple, format is db.tablename,
                               to extend chains from net (preserves dups)
* errorHelp              Explain error messages

### bedRemoveOverlap 
Remove overlapping records from a (sorted) bed file.  

Gets rid of the smaller of overlapping records.

usage:

   bedRemoveOverlap in.bed out.bed

options:

   -xxx=XXX

### bedGraphToBigWig v 4 
Convert a bedGraph file to bigWig format.

usage:

   bedGraphToBigWig in.bedGraph chrom.sizes out.bw

where in.bedGraph is a four column file in the format:

      <chrom> <start> <end> <value>

and chrom.sizes is a two-column file/URL: <chromosome name> <size in bases>
and out.bw is the output indexed big wig file.

If the assembly <db> is hosted by UCSC, chrom.sizes can be a URL like
  http://hgdownload.cse.ucsc.edu/goldenPath/<db>/bigZips/<db>.chrom.sizes
or you may use the script fetchChromSizes to download the chrom.sizes file.
If not hosted by UCSC, a chrom.sizes file can be generated by running
twoBitInfo on the assembly .2bit file.

The input bedGraph file must be sorted, use the unix sort command:

  sort -k1,1 -k2,2n unsorted.bedGraph > sorted.bedGraph

options:

* blockSize=N - Number of items to bundle in r-tree.  Default 256
* itemsPerSlot=N - Number of data points bundled at lowest level. Default 1024
* unc - If set, do not use compression.


### Fun Aside
Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads) 
to support [GBiB](https://genome.ucsc.edu/goldenpath/help/gbib.html#GetStarted).

## References

### [bigWig and bigBed, Jim Kent 2010](http://svn.donarmstrong.com/don/trunk/projects/research/papers_to_read/bioinformatics/sequence_alignment/bigwig_and_bigbed_enabling_browsing_of_large_distributed_datasets_kent_karolchik_bioinformatics_26_17_2204_2010_pmid_20639541.pdf)
