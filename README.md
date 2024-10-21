# browseMetadata

<a href="https://aim-rsf.github.io/browseMetadata/"><img src="man/figures/logo.png" align="right" height="120" alt="browseMetadata website" /></a>

[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-)  
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)  
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10581500.svg)](https://doi.org/10.5281/zenodo.10581500)

# Table of Contents

1. [What is the `browseMetadata` package?](#what-is-the-browsemetadata-package)
   - [Browse metadata](#browse-metadata)
   - [Map metadata](#map-metadata)
2. [Getting started with `browseMetadata`](#getting-started-with-browsemetadata)
   - [Installation and set-up](#installation-and-set-up)
   - [Demo (using the `R Studio` IDE)](#demo-using-the-r-studio-ide)
     - [`browseMetadata()`](#browsemetadata)
     - [`mapMetadata()`](#mapmetadata)
3. [Using a custom JSON input](#using-a-custom-json-input-recommended)
4. [Customising the domain file](#customising-the-domain-file-recommended)
5. [Changing the lookup table](#changing-the-lookup-table-advanced)
6. [Tips and future steps](#tips-and-future-steps)
7. [License](#license)
8. [Citation](#citation)
9. [Contributing](#contributing)

## What is the `browseMetadata` package?

The `browseMetadata` package allows researchers to explore publicly available metadata from the [Health Data Research Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) and the connected [Metadata Catalogue](https://maurosandbox.com/hdruk/#/home)[^1]. This tool helps researchers plan projects by interacting with health dataset metadata prior to gaining full data access. Learn more about health metadata [here](https://aim-rsf.github.io/browseMetadata/articles/browseMetadata.html).

At the early stages of a project, researchers can use this tool to **browse** datasets and **categorise** variables.

### Browse metadata

*What datasets are available? Which datasets fit my research?*

The tool summarises datasets and their tables, and displays how many variables within each table have descriptions.  

### Map metadata

*Which variables align with my research domains?*  
(e.g. socioeconomic, childhood adverse events, diagnoses, culture and community)

After browsing, users can categorise each variable into predefined research domains. To speed up this manual process, the package automatically categorises frequently used variables (e.g. ID, Sex, Age). The tool also accounts for variables that appear across multiple tables and allows users to copy categorisations to ensure consistency. The categorisations are saved as output files, which can be used in later analysis to filter and visualise variables by category.

## Getting started with `browseMetadata`

### Installation and set-up

Run in the R console:

``` r
install.packages("devtools")
devtools::install_github("aim-rsf/browseMetadata")
```

Load the library:

``` r
library(browseMetadata)
```

Set your working directory to an empty folder:

```r         
setwd("/Users/your-username/test-browseMetadata")
```

### Demo (using the `R Studio` IDE)

There are four main functions you can interact with: `browseMetadata()`, `mapMetadata()`, `mapMetadata_compare_outputs()`, and `mapMetadata_convert_outputs()`.  
For more information on any function, type `?function_name`. For example: `?browseMetadata`.

#### `browseMetadata()`

This function is easy to run and doesn't require user interaction. Run it in demo mode using the demo JSON file located in the [inst/inputs](inst/inputs/) directory:

``` r
browseMetadata()
``` 

Upon success, you should see:

```
ℹ Three outputs have been saved to your output directory.
ℹ Open the two HTML files in your browser for full-screen viewing.
```

The output files are saved to your working directory. You can change the save location by adjusting the `output_dir` argument. Examples of outputs are available [here](https://github.com/aim-rsf/browseMetadata/blob/big-refactor/inst/outputs/).

#### `mapMetadata()`

To run the mapping function in demo mode, use:

``` r
mapMetadata()
``` 

In demo mode, the function processes only the first 20 variables from selected tables. Follow the on-screen instructions, and categorise variables into research domains. The demo will simplify domains for ease of use, but in a real scenario, you can define more specific domains.

Upon completion, your categorisations, session log, and a summary plot will be saved in your directory.

## Using a custom JSON input (recommended)

You can run `mapMetadata()` and `browseMetadata()` using a custom JSON file instead of the demo input:

```r
new_json_file <- "path/your_new_json.json"
demo_domains_file <- system.file("inputs/domain_list_demo.csv", package = "browseMetadata")

browseMetadata(json_file = new_json_file)
mapMetadata(json_file = new_json_file, domain_file = demo_domains_file)
```

## Customising the domain file (recommended)

- You can replace the default demo domains with research-specific domains.  
- Your custom domain file should still include codes 0, 1, 2, and 3, which are automatically appended to the domain list.

## Changing the lookup table (advanced)

The lookup table governs the automatic categorisations. If you modify the [default lookup file](inst/inputs/look_up.csv), ensure that all domain codes in the lookup file are also included in your domain file for valid outputs.

## Tips and future steps

- You can process a subset of variables in one session and complete the rest later.
- If you're processing multiple tables, save all outputs in the same directory to enable table copying. This feature will speed up categorisation and ensure consistency.
- You can compare categorisations across researchers using the `mapMetadata_compare_outputs()` function.
- Use the output file from the `mapMetadata()` function as input for subsequent analysis to filter and visualise variables by research domain.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.  
For more information, refer to [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Citation

To cite `browseMetadata` in publications:

> Stickland R (2024). browseMetadata: Browse and categorise metadata for datasets. R package version 1.2.1.

A BibTeX entry for LaTeX users:

```r         
  @Manual{,
    title = {browseMetadata: Browse and categorise metadata for datasets},
    author = {Rachael Stickland},
    year = {2024},
    note = {R package version 1.2.1},
    doi = {https://doi.org/10.5281/zenodo.10581499}, 
  }
```

## Contributing

We welcome contributions to `browseMetadata`. Please read our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md) for details on how to contribute.

-   **Report Issues**: Found a bug? Have a feature request? Report it on [GitHub Issues](https://github.com/aim-rsf/browseMetadata/issues).
-   **Submit Pull Requests**: Follow our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md) for pull requests.
-   **Feedback**: Share your thoughts by opening an issue.

### Contributors ✨

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification.

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <!-- Contributor table remains unchanged -->
  </tbody>
</table>
<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

### Acknowledgements ✨

Thanks to the [MELD-B research project](https://www.southampton.ac.uk/publicpolicy/support-for-policymakers/policy-projects/Current%20projects/meld-b.page), the [SAIL Databank](https://saildatabank.com/) team, and the [Health Data Research Innovation Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) for ideas, feedback, and hosting open metadata.

[^1]: This package is in early development and has only been tested on a limited number of metadata files.  
[^2]: In future we intend to use the HDRUK Gateway API to access the most up to date metadata, rather than relying on a manual file download. 
[^3]: The metadata catalogue uses *Data asset* to mean *Dataset* (a collection of data, can contain multiple tables). *Data class* refers to *Table*, and *Data Element* refers to each *Variable* name within a table. 
[^4]: It is important to note that this is only summarising *variable* level metadata i.e. a description of what the variable is. Some variables also require *value* level metadata i.e. what does each value correspond to, 1 = Yes, 2 = No, 3 = Unknown. This *value* level metadata can sometimes be found in lookup tables, if it is not provided within the *variable* level description. 

