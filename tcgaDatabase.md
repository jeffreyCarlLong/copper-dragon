## TCGA Mutation Database 

```{bash engine=bash}

# broad automated* (n=543) TCGA hub
# TCGA lung adenocarcinoma (LUAD) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Broad Institute Genome Sequencing Center using the MuTect method. When variant allele frequency information is available, only calls with VAF >4.0% are kept, resulting in 0 calls are kept and 0 calls are removed.
wget -O TCGA.LUAD.mutation_broad.gz https://tcga.xenahubs.net/download/TCGA.LUAD.sampleMap/mutation_broad.gz
wget -O TCGA.LUAD.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.LUAD.sampleMap/LUAD_clinicalMatrix.gz
# broad* (n=178) TCGA hub
# TCGA lung squamous cell carcinoma (LUSC) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Broad Institute Genome Sequencing Center using the MuTect method.
wget -O TCGA.LUSC.mutation_broad.gz https://tcga.xenahubs.net/download/TCGA.LUSC.sampleMap/mutation_broad.gz
wget -O TCGA.LUSC.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.LUSC.sampleMap/LUSC_clinicalMatrix.gz
# broad automated* (n=396) TCGA hub
# TCGA bladder urothelial carcinoma (BLCA) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Broad Institute Genome Sequencing Center using the MuTect method. When variant allele frequency information is available, only calls with VAF >4.0% are kept, resulting in 0 calls are kept and 0 calls are removed.
wget -O TCGA.BLCA.mutation_broad.gz https://tcga.xenahubs.net/download/TCGA.BLCA.sampleMap/mutation_broad.gz
wget -O TCGA.BLCA.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.BLCA.sampleMap/BLCA_clinicalMatrix.gz
# wustl* (n=197) TCGA hub
# TCGA acute myeloid leukemia (LAML) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Genome Institute at Washington University Sequencing Center using the WashU pipeline method.
wget -O TCGA.LAML.mutation_wustl.gz https://tcga.xenahubs.net/download/TCGA.LAML.sampleMap/mutation_wustl.gz
wget -O TCGA.LAML.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.LAML.sampleMap/LAML_clinicalMatrix.gz
# bcm* (n=217) TCGA hub
# TCGA colon adenocarcinoma (COAD) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Baylor College of Medicine Human Genome Sequencing Center using the Baylor pipeline method.
wget -O TCGA.COAD.mutation_bcm.gz https://tcga.xenahubs.net/download/TCGA.COAD.sampleMap/mutation_bcm.gz
wget -O TCGA.COAD.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.COAD.sampleMap/COAD_clinicalMatrix.gz
# wustl* (n=248) TCGA hub
# TCGA uterine corpus endometrioid carcinoma (UCEC) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Genome Institute at Washington University Sequencing Center using the WashU pipeline method.
wget -O TCGA.UCEC.mutation_wustl.gz https://tcga.xenahubs.net/download/TCGA.UCEC.sampleMap/mutation_wustl.gz
wget -O TCGA.UCEC.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.UCEC.sampleMap/UCEC_clinicalMatrix.gz
# bcm automated* (n=345) TCGA hub
# TCGA kidney renal clear cell carcinoma (KIRC) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Baylor College of Medicine Human Genome Sequencing Center using the Baylor pipeline method.
wget -O TCGA.KIRC.mutation_bcm.gz https://tcga.xenahubs.net/download/TCGA.KIRC.sampleMap/mutation_bcm.gz
wget -O TCGA.KIRC.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.KIRC.sampleMap/KIRC_clinicalMatrix.gz
# broad automated* (n=472) TCGA hub
# TCGA skin cutaneous melanoma (SKCM) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Broad Institute Genome Sequencing Center using the MuTect method. When variant allele frequency information is available, only calls with VAF >4.0% are kept, resulting in 0 calls are kept and 0 calls are removed.
wget -O TCGA.SKCM.mutation_broad.gz https://tcga.xenahubs.net/download/TCGA.SKCM.sampleMap/mutation_broad.gz
wget -O TCGA.SKCM.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.SKCM.sampleMap/SKCM_clinicalMatrix.gz
# wustl* (n=142) TCGA hub
# TCGA ovarian serous cystadenocarcinoma (OV) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Genome Institute at Washington University Sequencing Center using the WashU pipeline method.
wget -O TCGA.OV.mutation_wustl.gz https://tcga.xenahubs.net/download/TCGA.OV.sampleMap/mutation_wustl.gz
wget -O TCGA.OV.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.OV.sampleMap/OV_clinicalMatrix.gz
# broad automated* (n=185) TCGA hub
# TCGA pancreatic adenocarcinoma (PAAD) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Broad Institute
wget -O TCGA.PAAD.mutation_broad.gz https://tcga.xenahubs.net/download/TCGA.PAAD.sampleMap/mutation_broad.gz
wget -O TCGA.PAAD.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.PAAD.sampleMap/PAAD_clinicalMatrix.gz
# broad curated* (n=57) TCGA hub
# TCGA uterine carcinosarcoma (UCS) somatic mutation data. Sequencing data are generated on a IlluminaGA system. The calls are generated at Broad Institute Genome Sequencing Center using the MuTect method.
wget -O TCGA.UCS.mutation_curated_broad.gz https://tcga.xenahubs.net/download/TCGA.UCS.sampleMap/mutation_curated_broad.gz
wget -O TCGA.UCS.clinicalMatrix.gz https://tcga.xenahubs.net/download/TCGA.UCS.sampleMap/UCS_clinicalMatrix.gz

```

## Processing TCGA Database

```{bash engine=bash}
gunzip *.gz
```
