# browseMetadata

<a href="https://aim-rsf.github.io/browseMetadata/"><img src="man/figures/logo.png" align="right" height="120" alt="browseMetadata website" /></a>

[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-)  
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)  
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10581500.svg)](https://doi.org/10.5281/zenodo.10581500)

# Table of Contents

1. [What is the `browseMetadata` package?](#what-is-the-browsemetadata-package)
   - [Browse metadata](#browse-metadata)
   - [Map metadata](#map-metadata)
2. [Getting started with `browseMetadata`](#getting-started-with-browsemetadata)
   - [Installation and set-up](#installation-and-set-up)
   - [Demo (using the `R Studio` IDE)](#demo-using-the-r-studio-ide)
     - [`browseMetadata()`](#browsemetadata-1)
     - [`mapMetadata()`](#mapmetadata)
3. [Using a custom metadata input](#using-a-custom-metadata-input-recommended)
4. [Using a custom domain list input](#using-a-custom-domain-list-input-recommended)
5. [Using a custom lookup table input](#using-a-custom-lookup-table-input-advanced)
6. [Tips and future steps](#tips-and-future-steps)
7. [License](#license)
8. [Citation](#citation)
9. [Contributing](#contributing)
10. [Acknowledgements](#acknowledgements-)

## What is the `browseMetadata` package?

The `browseMetadata` package allows researchers to explore publicly available metadata from the [Health Data Research Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) and the connected [Metadata Catalogue](https://maurosandbox.com/hdruk/#/home). This tool helps researchers plan projects by interacting with metadata prior to gaining full access to health datasets. Learn more about health metadata [here](https://aim-rsf.github.io/browseMetadata/articles/HealthMetadata.html).

At the early stages of a project, researchers can use this tool to **browse** datasets and **categorise** variables.

### Browse metadata

*What datasets are available? Which datasets fit my research?*

The tool summarises datasets and their tables, and displays how many variables within each table have descriptions. 

<img src="https://raw.githubusercontent.com/aim-rsf/browseMetadata/main/inst/outputs/BROWSE_bar_NationalCommunityChildHealthDatabase_(NCCHD)_V16.0.0.png" alt="example bar plot showing number of variables for each table alongside counts of whether variables have missing descriptions">

### Map metadata

*Which variables align with my research domains?*  
(e.g. socioeconomic, childhood adverse events, diagnoses, culture and community)

After browsing, users can categorise each variable into predefined research domains. To speed up this manual process, the function automatically categorises frequently used variables (e.g. ID, Sex, Age). The function also accounts for variables that appear across multiple tables and allows users to copy their categorisations to ensure consistency. The output files can be used in later analyses to filter and visualise variables by category.

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

Fo a longer more detailed demo, see the [Getting Started](https://aim-rsf.github.io/browseMetadata/articles/browseMetadata.html) page on the package website. 

There are four main functions you can interact with: `browseMetadata()`, `mapMetadata()`, `mapMetadata_compare_outputs()`, and `mapMetadata_convert_outputs()`. For more information on any function, type `?function_name`. For example: `?browseMetadata`.

#### `browseMetadata()`

This function is easy to run and doesn't require user interaction. Run it in demo mode using the demo JSON file located in the [inst/inputs](https://github.com/aim-rsf/browseMetadata/tree/main/inst/inputs) directory:

``` r
browseMetadata()
``` 

Upon success, you should see:

```
ℹ Three outputs have been saved to your output directory.
ℹ Open the two HTML files in your browser for full-screen viewing.
```

The output files are saved to your working directory. You can change the save location by adjusting the `output_dir` argument. Examples of outputs are available in [inst/outputs](https://github.com/aim-rsf/browseMetadata/tree/main/inst/outputs).

#### `mapMetadata()`

Use the outputs from `browseMetadata()` as a reference when running `mapMetadata()`. 

To run the mapping function in demo mode, use:

``` r
mapMetadata()
``` 

In demo mode, the function processes only the first 20 variables from selected tables. Follow the on-screen instructions, and categorise variables into research domains, using the Plot tab as your reference. The demo will simplify domains for ease of use; in a real scenario, you can define more specific domains.

Upon completion, your categorisations, session log, and a summary plot will be saved in your output directory.

## Using a custom metadata input (recommended)

You can run `mapMetadata()` and `browseMetadata()` using a custom JSON file instead of the demo input:

```r
new_json_file <- "path/your_new_json.json"
demo_domains_file <- system.file("inputs/domain_list_demo.csv", package = "browseMetadata")

browseMetadata(json_file = new_json_file)
mapMetadata(json_file = new_json_file, domain_file = demo_domains_file)
```

## Using a custom domain list input (recommended)

You can replace the default demo domains with research-specific domains. Remember any domain file input will have Codes 0,1,2 and 3 automatically appended to the start of the domain list, so do not include these in your domain list. 

## Using a custom lookup table input (advanced)

The lookup table governs the automatic categorisations. If you modify the [default lookup file](https://github.com/aim-rsf/browseMetadata/tree/main/inst/inputs/look_up.csv), ensure that all domain codes in the lookup file are also included in your domain file for valid outputs.

## Tips and future steps

- You can process a subset of variables in one session and complete the rest later.
- If you're processing multiple tables, save all outputs in the same directory to enable table copying. This feature will speed up categorisation and ensure consistency.
- You can compare categorisations across researchers using the `mapMetadata_compare_outputs()` function.
- Use the output file from the `mapMetadata()` function as input for subsequent analysis to filter and visualise variables by research domain.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](https://github.com/aim-rsf/browseMetadata/blob/main/LICENSE.md) file for details.  
For more information, refer to [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Citation

To cite `browseMetadata` in publications:

> Stickland R (2024). browseMetadata: Browse and categorise metadata for datasets. R package version 1.2.2.

A BibTeX entry for LaTeX users:

```r         
  @Manual{,
    title = {browseMetadata: Browse and categorise health metadata},
    author = {Rachael Stickland},
    year = {2024},
    note = {R package version 1.2.2},
    doi = {https://doi.org/10.5281/zenodo.10581499}, 
  }
```

## Contributing

We welcome contributions to `browseMetadata`. Please read our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md) for details on how to contribute.

-   **Report Issues**: Found a bug? Have a feature request? Report it on [GitHub Issues](https://github.com/aim-rsf/browseMetadata/issues).
-   **Submit Pull Requests**: Follow our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md) for pull requests.
-   **Feedback**: Share your thoughts by opening an issue.

### Contributors ✨

Thanks go to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://linkedin.com/in/rstickland-phd"><img src="https://avatars.githubusercontent.com/u/50215726?v=4?s=100" width="100px;" alt="Rachael Stickland"/><br /><sub><b>Rachael Stickland</b></sub></a><br /><a href="#content-RayStick" title="Content">🖋</a> <a href="https://github.com/aim-rsf/browseMetadata/commits?author=RayStick" title="Documentation">📖</a> <a href="#maintenance-RayStick" title="Maintenance">🚧</a> <a href="#ideas-RayStick" title="Ideas, Planning, & Feedback">🤔</a> <a href="#projectManagement-RayStick" title="Project Management">📆</a> <a href="https://github.com/aim-rsf/browseMetadata/pulls?q=is%3Apr+reviewed-by%3ARayStick" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://batool-almarzouq.netlify.app/"><img src="https://avatars.githubusercontent.com/u/53487593?v=4?s=100" width="100px;" alt="Batool Almarzouq"/><br /><sub><b>Batool Almarzouq</b></sub></a><br /><a href="#userTesting-BatoolMM" title="User Testing">📓</a> <a href="https://github.com/aim-rsf/browseMetadata/pulls?q=is%3Apr+reviewed-by%3ABatoolMM" title="Reviewed Pull Requests">👀</a> <a href="#ideas-BatoolMM" title="Ideas, Planning, & Feedback">🤔</a> <a href="#projectManagement-BatoolMM" title="Project Management">📆</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Rainiefantasy"><img src="https://avatars.githubusercontent.com/u/43926907?v=4?s=100" width="100px;" alt="Mahwish Mohammad"/><br /><sub><b>Mahwish Mohammad</b></sub></a><br /><a href="#userTesting-Rainiefantasy" title="User Testing">📓</a> <a href="https://github.com/aim-rsf/browseMetadata/pulls?q=is%3Apr+reviewed-by%3ARainiefantasy" title="Reviewed Pull Requests">👀</a> <a href="#ideas-Rainiefantasy" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/DDelbarre"><img src="https://avatars.githubusercontent.com/u/108824056?v=4?s=100" width="100px;" alt="Daniel Delbarre"/><br /><sub><b>Daniel Delbarre</b></sub></a><br /><a href="#ideas-DDelbarre" title="Ideas, Planning, & Feedback">🤔</a> <a href="#userTesting-DDelbarre" title="User Testing">📓</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/NidaZiaS"><img src="https://avatars.githubusercontent.com/u/142920412?v=4?s=100" width="100px;" alt="NidaZiaS"/><br /><sub><b>NidaZiaS</b></sub></a><br /><a href="#ideas-NidaZiaS" title="Ideas, Planning, & Feedback">🤔</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://allcontributors.org/) specification. Contributions of any kind are welcome!

## Acknowledgements ✨

Thanks to the [MELD-B research project](https://www.southampton.ac.uk/publicpolicy/support-for-policymakers/policy-projects/Current%20projects/meld-b.page), the [SAIL Databank](https://saildatabank.com/) team, and the [Health Data Research Innovation Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) for ideas, feedback, and hosting open metadata.

This project is funded by the NIHR [Artificial Intelligence for Multiple Long-Term Conditions (AIM) programme (NIHR202647). The views expressed are those of the author(s) and not necessarily those of the NIHR or the Department of Health and Social Care.

