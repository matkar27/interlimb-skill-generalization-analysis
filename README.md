
# Interlimb Skill Generalization and Working Memory: Data Analysis

## Project Overview

This project demonstrates reproducible data processing, statistical summarisation, and visualisation workflows in R using synthetic behavioural data.

The project is organised into two analysis modules:

1. **Motor Error Analysis:** Demonstrates the processing and visualisation of simulated motor performance data across learning and transfer sessions. It includes temporal, spatial, and total error measures, trial binning, and participant- and group-level summaries.

2. **Working Memory Analysis:** Demonstrates the calculation and visualisation of simulated working memory accuracy using trial-level binary responses. It includes participant-level accuracy calculations, group-level descriptive summaries, and individual and group visualisations.

The project is intended to demonstrate practical skills in:
- Data manipulation and organisation using `tidyverse`.
- Reshaping and summarising behavioural datasets.
- Calculating descriptive statistics, including means, standard deviations, and standard errors.
- Processing trial-level data into participant- and group-level summaries.
- Creating reproducible visualisations using `ggplot2`.
- Organising analysis scripts and outputs into a structured R project.

## Data Availability and Scope

**All datasets in this repository are synthetic and artificially generated for demonstration and learning purposes.**

They do not contain original participant-level observations and should not be interpreted as reproducing the findings of any published study.

The analysis workflows are independently constructed demonstrations inspired by general behavioural research data-processing approaches.



## Analysis Workflow

### 1. Motor Error Analysis

The motor error module follows this sequence:

1. Generate synthetic trial-level motor performance data.
2. Reshape the dataset into long format.
3. Divide consecutive trials into five-trial bins.
4. Calculate participant-level mean error, standard deviation, and standard error.
5. Calculate group-level descriptive summaries.
6. Visualise group-level performance and individual participant trajectories.

### 2. Working Memory Analysis

The working memory module follows this sequence:

1. Generate synthetic trial-level binary responses.
2. Calculate the number of correct responses for each participant.
3. Calculate participant-level accuracy as a percentage.
4. Calculate group-level mean accuracy, standard deviation, and standard error.
5. Visualise group-level accuracy, individual participant accuracy, and accuracy distributions.

## Scope and Limitations

This repository is an independent demonstration of behavioural data processing and visualisation using artificially generated datasets.

The project demonstrates:
- Trial-level behavioural data organisation and processing.
- Trial binning and participant-level summarisation.
- Calculation of descriptive statistics.
- Group-level descriptive comparisons.
- Visualisation of individual and group-level patterns.

The project does not:
- Use original participant-level data from the referenced research projects.
- Reproduce the statistical results or findings of any published study.
- Perform inferential statistical analyses or establish statistically significant group differences.

All simulated effects and patterns are illustrative and should not be interpreted as empirical findings.