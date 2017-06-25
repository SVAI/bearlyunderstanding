# bearlyunderstanding

This project was started at the AI Genomics Hackathon on June 23-25, 2017, hosted by Silicon Valley Artificial Intelligence in San Francisco. 

The goal of our project is to identify Neoantigen candidates for potential immunotherapy of Onno's NF2 condition. To do this, we use a combination of existing genomics tools and a novel protein structure-based machine learning setup to identify the most promising HLA (Human leukocyte antigen) restricted peptides. 

The immune system is an incredibly complex and robust orchestra of molecules, cells, and processes that works to protect the body against both pathogenic infections and native cell dysfunction. One of the processes that the immune system uses to keep mutated cells from propagating (that is, to prevent cancers) is to identify cells with non-native (mutated) proteins and eliminate them before the mutant cells that encode them can spread. Vastly simplify this processes for the purpose of explanation, there are proteins in every cell that cut other proteins into short (8-12 amino acid long) peptide fragments. Some of these fragments are then presented by MHC (Major histocompatibility complex) molecules on the surface of the cell as antigens for inspection by cytotoxic T-cells; if a T-cell identifies an antigen as non-native, it will kill the cell.

When a tumor grows, this natural process is not working successfully. Immunotherapy comes in by attempting to enhance the natural process at some point along the signaling pathway. One focal point for immunotherapy is the binding of the cut-up protein fragments with the HLA proteins because that is the most chemically selective step along the pathway. In this project, we identify the most viable candidate epitopes for Onno's NF2 based on existing epitope-HLA binding affinity data and structural data of his HLA protein.

# Step 1: Identifying all epitope candidates
The project integrates diverse biological data sources include whole genome sequencing data (tumor-normal) and multiple 3rd party software include RTGtools, snpEff, netchop3.1 and netMHCpan3.0 to predict the potential MiHAs by comparing the variants between Onno's tumor and normal tissue. It simulates the antigen processing and presenting on tumor cell surface via restricted HLA molecules.

# Step 2: Rank epitope candidates based on HLA protein

![Alt text](https://www.statnews.com/wp-content/uploads/2016/03/TumorAntigens_mcgranahan4HR-1024x576.jpg "T cell targets tumor tissue by recognizing neoantigens")

T cell targets tumor tissue by recognizing neoantigens
