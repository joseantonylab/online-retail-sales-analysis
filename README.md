# Online Retail Sales Performance Analysis

**Status:** 🚧 In progress

## Business Question
How are sales performing across markets, products and customer cohorts,
and where are the biggest opportunities to grow revenue and customer retention?

## Tools
Python (pandas) · MySQL · SQL · Power BI · Git/GitHub

## Progress
- [x] Data cleaning in Python – duplicates, cancellations, invalid prices,
      non-product codes and erroneous outlier orders ([notebook](notebooks/01_data_cleaning.ipynb))
- [x] Clean data loaded into MySQL
- [ ] SQL analysis – revenue trends, market share, top products, cohort retention
- [ ] Power BI dashboard
- [ ] Key findings and recommendations

## Data Source
Chen, D. (2012). *Online Retail II* [Dataset]. UCI Machine Learning Repository.
https://doi.org/10.24432/C5CG6D — licensed under CC BY 4.0.
About 1 million transactions from a UK-based online retailer, December 2009 – December 2011.
The raw file is not included in this repository; download it from the link above
and place it in `data/raw/`.