# demo

## About

demo is a Reproducible Analytical Pipeline (RAP) built following the [UK Government Analysis Function RAP methodology](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/).

This pipeline automates the production of [describe your statistical output here], replacing manual processes with reproducible, version-controlled code.

## How to Run

### Prerequisites

- [R](https://cran.r-project.org/) (version 4.0 or higher)
- [RStudio](https://posit.co/download/rstudio-desktop/) (recommended)
- [Git](https://git-scm.com/)

### Steps to Reproduce

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd demo
   ```

2. Restore the R package environment:
   ```r
   renv::restore()
   ```

3. Run the pipeline:
   ```r
   source("R/01_read_data.R")
   source("R/02_process_data.R")
   source("R/03_analyse_data.R")
   source("R/04_create_output.R")
   ```

   Or, if using {targets}:
   ```r
   targets::tar_make()
   ```

4. Outputs will be generated in the `output/` directory.

## Data Sources

| Dataset | Source | Format | Update Frequency |
|---------|--------|--------|-----------------|
| [Dataset 1] | [Source] | [CSV/Excel/API] | [Quarterly/Annual] |

For data access instructions, see `data/README.md`.

## Dependencies

All R package dependencies are managed with [{renv}](https://rstudio.github.io/renv/). The exact versions used are recorded in `renv.lock`.

To install all dependencies:
```r
renv::restore()
```

## RAP Compliance Level

**Current level**: Baseline

For details on RAP maturity levels, see the [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/introduction_to_RAP/levels_of_RAP/).

## Contributing / Peer Review

Contributions are welcome. Please follow these guidelines:

1. Create a feature branch from `main`
2. Make your changes with clear, descriptive commits
3. Ensure all code follows [tidyverse style](https://style.tidyverse.org/)
4. Open a pull request for peer review
5. At least one reviewer must approve before merging

Peer review is a [Baseline RAP requirement](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/) ensuring code quality and reproducibility.

## Licence

[Specify licence — e.g., MIT, OGL-UK-3.0]
