**Reproducible Analysis Pipeline for Spatial dynamics and hidden spread of banana bunchy top disease in Benin**

📖 Associated Publication

This repository accompanies the following publication:

Spatial dynamics and hidden spread of banana bunchy top disease in Benin
Frontiers in Agronomy (2026)
DOI: https://doi.org/10.3389/fagro.2026.1754220

This repository contains all scripts and workflows required to reproduce the analyses, figures, and results presented in the manuscript.

🎯 Objectives

The purpose of this repository is to:

* Ensure full reproducibility of the study
* Provide transparent access to data processing and statistical analysis
* Enable reuse and adaptation of the pipeline for similar studies
* Facilitate peer verification and extension of the work

📂 Repository Structure

```bash
.
├── data/                  # Raw and processed datasets (if shareable)
├── scripts/               # Modular R scripts used across the analysis
├── outputs/               # Generated results (tables, figures)
├── figures/               # Final figures used in manuscript
├── BBTV_P.Rmd             # Main R Markdown analysis workflow
├── README.md              # Project documentation
└── environment.yml / renv.lock  # Dependency management (if applicable)
```

⚙️ Workflow Overview

The analysis is organized around a central R Markdown document:

Main Pipeline

BBTV_P.Rmd orchestrates the entire workflow:

* Loads and preprocesses data
* Sources helper scripts
* Compiles and runs Stan models
* Extracts posterior distributions
* Generates figures and tables

🧠 Bayesian Modeling (Stan Integration)
 * 📌 Stan Files*

 All Bayesian models are defined in:
 
```bash
/stan/*.stan
```

These files contain:

* Model structure (likelihood + priors)
* Parameter definitions
* Generated quantities (if applicable)

⚙️ R Interface

Stan models are called from R using one of:

* rstan
* cmdstanr (recommended if used in your code)

Example workflow:

```R
library(cmdstanr)

model <- cmdstan_model("stan/model_name.stan")

fit <- model$sample(
  data = stan_data,
  chains = 4,
  iter_warmup = 1000,
  iter_sampling = 2000,
  seed = 123
)
```

🛠️ Installation

1️⃣ Clone repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```
