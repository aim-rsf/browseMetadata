# browseMetadata

<a href="https://aim-rsf.github.io/browseMetadata/"><img src="man/figures/logo.png" align="right" height="120" alt="browseMetadata website" /></a>

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-) <!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10581500.svg)](https://doi.org/10.5281/zenodo.10581500)

## What is the `browseMetadata` package?

This `R` package helps a researcher browse health datasets in [SAIL databank](https://saildatabank.com). It has scope to be applied to other health datasets[^1].  This `R` package uses the publicly available metadata hosed on the [Health Data Research Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) and the connected [Metadata Catalogue](https://modelcatalogue.cs.ox.ac.uk/hdruk_live/). This `R` package is a planning tool, designed to be used alongside other tools and sources of information about health datasets for research. Read more [here](https://aim-rsf.github.io/browseMetadata/articles/browseMetadata.html).


In the earlier stages of a project, prior to data access, researchers can use the metadata to **browse** datasets and **categorise** variables:

### Browse metadata

*What datasets are available? ↔️ What datasets do I need for my research?*

The first part of the tool summarises the dataset, and all the tables within it. A plot displays how many variables within a dataset table have a description field that is not empty.  

### Map metadata

*Which variables within these datasets map onto my research domains of interest? (e.g. socioeconomic, childhood adverse events, diagnoses, culture and community)*

Beyond browsing, a user can then categorise each variable within a dataset table into a set of pre-defined research domains, with functionality to reach consensus between researchers. To speed up this manual process, the package automatically categorises some variables that regularly appear in health datasets (e.g. ID, Sex, Age). The package also accounts for the same data element appearing in multiple tables across a dataset, and allows the user to active a table copying function which copies categorisations they've done for previous tables, into the current table they are processing. The output file containing the categorisations can be used as input to later analyses on the real dataset, to filter and visualise variables based on category labels.


## Getting started with `browseMetadata`

### Terminology

-   We use *Dataset* (collection of data, can contain multiple tables) - this is called *Data Asset* in the Metadata Catalogue
-   We use *Table* - this is called *Data Class* in the Metadata Catalogue
-   We use *Data Element* - the same as the Metadata Catalogue - which refers to each variable name within the table

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

Set your working directory to be an empty folder you just created:

```         
setwd("/Users/your-username/test-browseMetadata")
```

### Demo (using the `R Studio` IDE)

There are 4 main functions you can interact with. In order to read their documentation:

``` r         
?browseMetadata
?mapMetadata
?mapMetadata_compare_outputs
?mapMetadata_convert_outputs
```

#### `browseMetadata.R`

This function is easy to run and does not require any user interaction. 

Simply provide a json file containing metadata, that was downloaded from the metadata catalogue. 

For now, use the example package file provided in [data-raw/in](data-raw/in). 
In future we intend to use the HDRUK Gateway API to access the metadata, rather than relying on a manual file download. 

``` r
browseMetadata(json_file = 'your-path/data-raw/national_community_child_health_database_(ncchd)_20240405T130125.json')
``` 

The second input to browseMetadata is `output_dir` - change this if you want to save your files somewhere other than your current working directory (which is the default).

After running this code successfully you should see:

```
ℹ Two outputs have been saved in your output directory. Open them in your browser to view.
ℹ Alternatively, on the Plots tab select the 'Show in new window' button.
```

PNG versions of these outputs are saved in [data-raw/out](data-raw/out) for you to reference, but for high resolution interactive versions, open up the html files that you just generated in your web browser. The table summarises the dataset and each table in the dataset - this will be a useful reference to have open when you run the `mapMetadata.R` function below. 

Let's look at the bar plot, pasted below for convenience. This plot is another simple way of summarising the dataset. We can see there are 13 tables in the dataset. The height of the bar indicates the number of variables in that table - the ones with lots of variables (e.g. CHILD_TRUST) will take you longer to process when running `mapMetadata.R`. Some tables (e.g. CHE_HEALTHYCHILDWALESPROGRAMME) has a lot of empty descriptions. An empty description means that this variable will only have a label and a data type. 

It is important to note that this is only summarising *variable* level metadata i.e. a description of what the variable is. Some variables also require *value* level metadata i.e. what does each value correspond to, 1 = Yes, 2 = No, 3 = Unknown. This *value* level metadata can sometimes be found in lookup tables, if it is not provided within the *variable* level description. 

![bar plot](data-raw/out/BROWSE_bar_NationalCommunityChildHealthDatabase(NCCHD)_Version16.0.0.png)

The numbers next to table names, (1), correspond to the order in which they appear in the table and the order they are shown to you in the `mapMetadata.R` function. 

#### `mapMetadata.R`

We can run the function in demo mode: 

``` r
mapMetadata()
``` 

Demo mode means it will use the demo package files and only process the first 20 variables (data elements) within the table(s) we select to process. 

Take note of the Plots tab in R Studio which should show a table of domains with this info below. Reference this Plots tab throughout the demo run. You will be asked to label data elements with one (or more) of these numbers [0-7]. Here we have very simple domains [4-7] for the demo run. For a research study, your domains are likely to be much more specific e.g. 'Prenatal, antenatal, neonatal and birth' or 'Health behaviours and diet'. The 4 default domains are always included [0-3], appended on to any domain list given.

<img src="data-raw/out/plots_tab_demo_domains.png" alt="plots" width="200"/>

```         
ℹ Running mapMetadata in demo mode using package data files
ℹ Using the default look-up table in data/look-up.rda
 
Enter your initials: RS
```

Respond with your initials after the prompt and press enter. It will then print the name of the dataset and where it was retrieved from:

```         
── Dataset Name ─────────────────────────────────────────────────────────────────────────────────────────────────
National Community Child Health Database (NCCHD)
── Dataset File Exported By ─────────────────────────────────────────────────────────────────────────────────────
Rachael Stickland at 2024-04-05T13:01:23.109Z

ℹ Reference outputs from browseMetadata for information about the dataset

Press any key to continue 
```

```         
ℹ Found 13 Tables in this Dataset

1 EXAM

2 CHILD

3 REFR_IMM_VAC

4 IMM

5 BREAST_FEEDING

6 PATH_BLOOD_TESTS

7 CHE_HEALTHYCHILDWALESPROGRAMME

8 BLOOD_TEST

9 CHILD_TRUST

10 PATH_SPCM_DETAIL

11 CHILD_MEASUREMENT_PROGRAM

12 CHILD_BIRTHS

13 SIG_COND

ℹ Enter each table number you want to process in this interactive session.

1: 2
2: 
```

For the purpose of this demo, type 2 to just process the CHILD table only. Leave the prompt on the second row blank and press enter.

To process multiple tables at once in the same session (e.g. CHILD, SIG_COND) include their numbers on multiple lines:

```         
ℹ Enter each table number you want to process in this interactive session.

1: 1
2: 13
3:
```

```         
ℹ Processing Table 2 of 13

── Table Name ───────────────────────────────────────────────────────────────────────────────────────────────────
CHILD 


ℹ Reference outputs from browseMetadata for information about the table

Optional free text note about this table (or press enter to continue): This table is important because ... 
```

It will now start looping through the data elements. If it skips over one it means it was auto-categorised or copied from a previous table already processed (more on that later). For this demo, it will only process 20 data elements (out of the 35 total).

```         
ℹ 20 left to process in this session
✔ Processing data element 1 of 35

ℹ 19 left to process in this session
✔ Processing data element 2 of 35

ℹ 18 left to process in this session
✔ Processing data element 3 of 35

ℹ 17 left to process in this session
✔ Processing data element 4 of 35

DATA ELEMENT ----->  APGAR_1 

DESCRIPTION ----->  APGAR 1 score. This is a measure of a baby's physical state at birth with particular reference to asphyxia - taken at 1 minute. Scores 3 and below are generally regarded as critically low; 4-6 fairly low, and 7-10 generally normal. Field can contain high amount of unknowns/non-entries. 

DATA TYPE ----->  CHARACTER 

Categorise data element into domain(s). E.g. 3 or 3,4: 7

Categorisation note (or press enter to continue): your note here 
```

We chose to respond with '7' because that corresponds to the 'Health info' domain in the table. More than one domain can be chosen. Do remember that this demo has over-simplified domain labels, and they will likely be more specific for a research study.

A note can be included to explain why a categorisation has been made. Or press enter for no note.

You have the option to re-do the categorisation you just made, by replying 'y' to the question:

```         
Response to be saved is '7'. Would you like to re-do? (y/n): y
```

After completing 20, it will then ask you to review the auto-categorisations it made.

These auto-categorisations are based on the mappings included in the [data-raw/look_up.csv](data-raw/look_up.csv). This look-up file can be changed (see the section 'Using your own input files' below). ALF refers to 'Anonymous Linking Field' - this field is used within datasets that have been anonymised and encrypted for inclusion within SAIL Databank.

```         
! Please check the auto categorised data elements are accurate for table CHILD:

     DataElement    Domain_code  Note
1    ALF_E          2            AUTO CATEGORISED
2    ALF_MTCH_PCT   2            AUTO CATEGORISED
3    ALF_STS_CD     2            AUTO CATEGORISED
6    AVAIL_FROM_DT  1            AUTO CATEGORISED  
19   GNDR_CD        3            AUTO CATEGORISED

ℹ Press enter to accept the auto categorisations for table CHILD or enter each row you'd like to edit:

1: 
```

Press enter for now. It will then ask you if you want to review the categorisations you made. Respond Y to review:

```         
Would you like to review your categorisations? (y/n): y

      DataElement             Domain_code   Note (first 12 chars)
4     APGAR_1                 7
5     APGAR_2                 7
7     BIRTH_ORDER             7             10% missingness
8     BIRTH_TM                1,7           20% missingness 
9     BIRTH_WEIGHT            7
10    BIRTH_WEIGHT_DEC        7
11    BREASTFEED_8_WKS_FLG    7
12    BREASTFEED_BIRTH_FLG    7
13    CHILD_ID_E              2
14    CURR_LHB_CD_BIRTH       5,7           Place of birth
15    DEL_CD                  7
16    DOD                     3,7
17    ETHNIC_GRP_CD           3
18    GEST_AGE                3,7
20    HEALTH_VISITOR_CD_E     2

ℹ Press enter to accept your categorisations for table CHILD, or enter each row number you'd like to edit:

1: 8
2: 14
3: 
```

If you want to change your categorisation, enter in the row number (e.g. 8 for BIRTH_TM and 14 for CURR_LHB_CD_BIRTH).

It will then take you through the same process as before, and you can over-write your previous categorisation.

All finished! Take a look at the outputs:

```         
✔ Your final categorisations have been saved:
OUTPUT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-04-05-14-37-36.csv
✔ Your session log has been saved:
LOG_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-04-05-14-37-36.csv
✔ A summary plot has been saved:
PLOT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-04-05-14-37-36.png
```

The OUTPUT csv contains the categorisations you made. The LOG csv contains information about the session as a whole, including various metadata. These two csv files contain the same timestamp column. If you do not like the formatting of the OUTPUT csv, see the function [R/mapMetadata_convert_outputs.R](R/mapMetadata_convert_outputs.R) for an alternative. 

The PLOT png file saves a simple plot displaying the count of domain codes for that table.

### Using your own input files

``` r
mapMetadata(json_file, domain_file, look_up_file, output_dir, table_copy)
```

This code is in early development. To see known bugs or sub-optimal features refer to the [Issues](https://github.com/aim-rsf/browseMetadata/issues).

First, change the json file and domain file inputs. Later, consider changing the other 3 inputs, depending on your use-case. For example:

``` r
mapMetadata(json_file = 'path/your-json.json', domain_file = 'path/your-domains.csv')
```

Unlike in demo mode, it will ask you to specify the range of variables you want to process (start variable:end variable), because you can choose to process a table across multiple sessions (particularly useful if the table has a large number of data elements).

For detailed information on each input argument, reference the manual by typing:

``` r
?mapMetadata
``` 

### Tips and potential next steps

- If you are processing multiple tables from one dataset, make sure the output files get saved to the same directory! If they do, the function will notice this, and it will copy over categorisations for repeated variables. This will save you time and ensure consistency of categorisations! 
- The csv output file containing the categorisation for each data element could be used as an input in later analysis steps to filter variables and visualise how each variable maps to research domains of interest.
- Categorisations across researchers can be compared by using the function [R/mapMetadata_compare_outputs.R](R/mapMetadata_compare_outputs.R). In brief, it compares csv outputs from two sessions, finds their differences, and asks for a consensus.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

The GNU General Public License is a free, copyleft license for software and other kinds of works. For more information, please refer to <https://www.gnu.org/licenses/gpl-3.0.en.html>.

## Citation

To cite package ‘browseMetadata’ in publications use:

> Stickland R (2024). browseMetadata: Browses available metadata, to catergorise/label each variable in a dataset. R package version 1.2.1

A BibTeX entry for LaTeX users is

```         
  @Manual{,
    title = {browseMetadata: Browses available metadata, to catergorise/label each variable in a dataset},
    author = {Rachael Stickland},
    year = {2024},
    note = {R package version 1.2.1},
    doi = {https://doi.org/10.5281/zenodo.10581499}, 
  }
```

## Contributing

We warmly welcome contributions to the browseMetadata project. Whether it's fixing bugs, adding new features, or improving documentation, we welcome your involvement. Please refer to our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md).

-   **Report Issues**: If you find a bug or have a feature request, please report it via [GitHub Issues](https://github.com/aim-rsf/browseMetadata/issues).
-   **Submit Pull Requests**: We welcome pull requests. Please read our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md) on how to make contributions.
-   **Feedback and Suggestions**: We're always looking to improve, and we value feedback and suggestions. Feel free to open an issue to share your thoughts.

### Contributors ✨

This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors)
specification, using the ([emoji
key](https://allcontributors.org/docs/en/emoji-key)). Contributions of
any kind welcome!

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://linkedin.com/in/rstickland-phd"><img src="https://avatars.githubusercontent.com/u/50215726?v=4?s=100" width="100px;" alt="Rachael Stickland"/><br /><sub><b>Rachael Stickland</b></sub></a><br /><a href="#content-RayStick" title="Content">🖋</a> <a href="https://github.com/aim-rsf/browseMetadata/commits?author=RayStick" title="Documentation">📖</a> <a href="#maintenance-RayStick" title="Maintenance">🚧</a> <a href="#ideas-RayStick" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://batool-almarzouq.netlify.app/"><img src="https://avatars.githubusercontent.com/u/53487593?v=4?s=100" width="100px;" alt="Batool Almarzouq"/><br /><sub><b>Batool Almarzouq</b></sub></a><br /><a href="#userTesting-BatoolMM" title="User Testing">📓</a> <a href="https://github.com/aim-rsf/browseMetadata/pulls?q=is%3Apr+reviewed-by%3ABatoolMM" title="Reviewed Pull Requests">👀</a> <a href="#ideas-BatoolMM" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Rainiefantasy"><img src="https://avatars.githubusercontent.com/u/43926907?v=4?s=100" width="100px;" alt="Mahwish Mohammad"/><br /><sub><b>Mahwish Mohammad</b></sub></a><br /><a href="#userTesting-Rainiefantasy" title="User Testing">📓</a> <a href="https://github.com/aim-rsf/browseMetadata/pulls?q=is%3Apr+reviewed-by%3ARainiefantasy" title="Reviewed Pull Requests">👀</a> <a href="#ideas-Rainiefantasy" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/DDelbarre"><img src="https://avatars.githubusercontent.com/u/108824056?v=4?s=100" width="100px;" alt="Daniel Delbarre"/><br /><sub><b>Daniel Delbarre</b></sub></a><br /><a href="#ideas-DDelbarre" title="Ideas, Planning, & Feedback">🤔</a> <a href="#userTesting-DDelbarre" title="User Testing">📓</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

### Acknowledgements ✨

Thank you to multiple members of the [MELD-B research project](https://www.southampton.ac.uk/publicpolicy/support-for-policymakers/policy-projects/Current%20projects/meld-b.page) and the [SAIL Databank](https://saildatabank.com/) team for providing use-cases of meta data browsing, ideas and feedback. Thank you to the [Health Data Research Innovation Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) for hosting openly available metadata for health datasets, and for data providers that have included their datasets on this gateway.

[^1]: This package is in early development, and has only been tested on a limited number of metadata files. In theory, this package should work for any dataset listed on the Health Data Research Gateway (not just SAIL) as long as a json metadata file can be downloaded. In practice, it has only been tested on a limited number of metadata files for SAIL databank.
