# AI Use and Employment Change Across Industries in Denmark

This project uses OECD data and base R to describe how business AI use and employment changed across nine industries in Denmark from 2023 to 2025.

Denmark is used as the representative country for this midterm analysis. The broader research may later include other countries with comparable data.

## Research Questions

- How did the share of businesses using AI change across industries in Denmark from 2023 to 2025?
- How did employment change in each industry from 2023–2024 and 2024–2025?
- Do industries with larger increases in AI use also show larger employment changes?

This is a descriptive comparison. The analysis does not establish that AI caused employment to increase or decrease.

## Data Sources

### Business AI Use

Source: [OECD Data Explorer — ICT Access and Usage by Businesses](https://data-explorer.oecd.org/vis?df%5Bag%5D=OECD.STI.DEP&df%5Bds%5D=dsDisseminateFinalDMZ&df%5Bid%5D=DSD_ICT_B%40DF_BUSINESSES&df%5Bvs%5D=1.0)

- OECD dataflow: `OECD.STI.DEP:DSD_ICT_B@DF_BUSINESSES (1.0)`
- Country filter: Denmark (`DNK`)
- Measure: Businesses using artificial intelligence (`G14_B`)
- Unit: Percentage of enterprises (`PT_ENT`)
- Employment-size filter: Enterprises with 10 or more employees (`S_GE10`)
- Years used: 2023, 2024, and 2025
- Local file: `data/ai_business_use.csv`

### Employment

Source: [OECD Data Explorer — Annual employment by detailed economic activity, domestic concept](https://data-explorer.oecd.org/vis?df%5Bag%5D=OECD.SDD.NAD&df%5Bds%5D=DisseminateFinalDMZ&df%5Bid%5D=DSD_NAMAIN10%40DF_TABLE7&df%5Bvs%5D=2.0)

- OECD dataflow: `OECD.SDD.NAD:DSD_NAMAIN10@DF_TABLE7 (2.0)`
- Country filter: Denmark (`DNK`)
- Measure: Total employment (`EMP`)
- Unit: Thousands of persons (`PS`, with multiplier `10^3`)
- Concept: Domestic concept
- Years used: 2023, 2024, and 2025
- Local file: `data/industry_employment.csv`

The data files are filtered OECD CSV exports. The analysis script selects Denmark and uses the industry, year, and observation-value fields.

## Industries Included

The analysis compares nine industries:

| OECD activity code | Industry |
|---|---|
| `C` | Manufacturing |
| `F` | Construction |
| `G46` | Wholesale |
| `G47` | Retail |
| `H` | Transport |
| `I` | Accommodation and food |
| `J` | Information and communication |
| `M` | Professional and scientific |
| `N` | Administrative and support |

## Measures and Calculations

- **AI use (%)**: the percentage of businesses using AI in an industry and year.
- **AI-use change (percentage points)**: 2025 AI-use percentage minus 2023 AI-use percentage.
- **Employment change (%)**: `(later-year employment - earlier-year employment) / earlier-year employment × 100`.
- Employment changes are calculated separately for 2023–2024 and 2024–2025, as well as across the full 2023–2025 period for the scatter plot.

A percentage-point change is a subtraction between two percentages. It is different from a percentage change.

## Visualizations

The R script creates three charts:

1. **AI Use by Industry in Denmark** — grouped horizontal bars compare AI-use rates in 2023, 2024, and 2025.
2. **Employment Change by Industry in Denmark** — grouped horizontal bars compare employment changes in 2023–2024 and 2024–2025. A zero line distinguishes increases from decreases.
3. **AI Use and Employment Change by Industry** — a scatter plot compares the 2023–2025 change in AI use with the 2023–2025 employment change. Each point represents one industry.

## Preliminary Findings

- AI use increased in all nine industries between 2023 and 2025.
- Professional and scientific activities had the largest increase in AI use, at about 40.13 percentage points.
- Information and communication had the highest AI-use rate in 2025, at about 79.08%.
- Employment changes differed across industries. Employment declined in information and communication, while most of the other included industries showed increases.
- The scatter plot suggests that the relationship between AI-use change and employment change is not the same across all industries.

These results describe the patterns in this dataset. They do not show that AI use directly caused the employment changes.

## Repository Structure

    denmark-ai-employment/
    ├── data/
    │   ├── ai_business_use.csv
    │   └── industry_employment.csv
    ├── figures/
    ├── Denmark_AI_Employment_Analysis.R
    └── README.md

## Requirements

- R
- No additional R packages are required; the analysis uses base R.

## Setup and Rerun

1. Download or clone this repository.
2. Confirm that both CSV files are in the `data/` folder.
3. Open `Denmark_AI_Employment_Analysis.R` in RStudio.
4. Update the `setwd()` line near the beginning of the script so it points to this project's local `data/` folder. The current script contains a path from the original computer, which will not work on another computer.
5. Run the script. It reads the two CSV files, filters the data to Denmark, calculates changes, and creates the three charts.
6. Save the charts from the RStudio plotting window into the `figures/` folder if you want to include image files in the repository.

## Limitations

- This midterm analysis covers one country and nine industries.
- The analysis is descriptive and does not control for other factors that may affect employment.
- Industry-level patterns cannot explain what happened to individual workers or businesses.
- AI adoption and employment may be influenced by many factors, so the charts should not be interpreted as evidence of causation.
- The results depend on the OECD data definitions, coverage, and revisions available in the exported files.

## Future Work

The final project may extend the analysis to additional countries where comparable AI-use and employment data are available. Denmark provides the starting case for this broader comparison.
