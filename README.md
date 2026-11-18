# Rat Growth Mixed-Design Repeated Measures ANOVA

## Project Title
**BIO2105 - Biostatistics Formative Assessment 11: Mixed-Design Repeated Measures ANOVA Using R**

**Authors:** Chavez, Ishi Santi V. | Lagaña, Alyssa Kaye L. | Quillope, Arabela Renee Florence M. (Section 4)

## Research Objectives
The primary objective of this study is to evaluate whether rat body weight differs significantly across three experimental treatment groups (**Control**, **Thiouracil**, and **Thyroxin**) and across five weekly measurement occasions (**Week 0 to Week 4**)[cite: 1, 2]. Specifically, this analysis investigates whether the pattern of body weight change over time depends on the treatment administered (**Treatment × Time Interaction**)[cite: 1, 15].

## Dataset Description
The dataset (`rats`) is sourced from the `nlmm` R package and originates from the classic growth curve experiment by Box (1950)[cite: 1]. 
* **Sample Size:** 27 rats (10 Control, 10 Thiouracil, 7 Thyroxin—three rats were removed from the Thyroxin group following an accident) totaling 135 observations[cite: 1, 2].
* **Variables:**
  * `id`: Individual rat identifier (Nominal / Subject ID)[cite: 2]
  * `trt`: Between-subjects factor (`Control`, `Thiouracil`, `Thyroxin`)[cite: 2]
  * `time`: Within-subjects factor (`Week 0` through `Week 4`)[cite: 2]
  * `y`: Dependent variable representing body weight in grams (Continuous)[cite: 2]

## Repository Structure
* `README.md`: Project overview, dataset details, and reproduction guide[cite: 11].
* `Rat_Growth_Mixed_ANOVA.R`: Standalone, documented R script executing all statistical tests[cite: 11].
* `Rat_Growth_Mixed_ANOVA.Rmd`: R Markdown source document integrating code, outputs, visualizations, and APA interpretations[cite: 11, 17].
* `Rat_Growth_Mixed_ANOVA.html`: Rendered HTML report generated from the R Markdown source[cite: 11, 12].
* `data/Rat_Growth_Dataset.csv`: Local CSV copy of the processed dataset[cite: 11, 13].

## How to Reproduce the Analysis
1. Clone or download this repository to your local machine.
2. Open R or RStudio (version 4.0 or higher recommended).
3. Install the required R packages by running:
   ```r
   install.packages(c("nlmm", "tidyverse", "rstatix", "ggpubr"))

## View Online Report
You can view the fully rendered HTML report hosted on RPubs here:
[View Rat Growth Mixed-Design ANOVA Report on RPubs]((https://rpubs.com/lykaes/1477254))
