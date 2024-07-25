# browseMetadata

<a href="https://aim-rsf.github.io/browseMetadata/"><img src="man/figures/logo.png" align="right" height="120" alt="browseMetadata website" /></a>

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-) <!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10581500.svg)](https://doi.org/10.5281/zenodo.10581500)

This `R` package was created to help a researcher browse the health datasets in [SAIL databank](https://saildatabank.com). It has scope to be applied to other health datasets. It is intended to be useful in the earlier stages of a project. When a research team has not yet got access to the data they can still browse the metadata, and address such questions as:

:question: what datasets are available?

:question: what datasets do I need for my research question?

:question: which variables within these datasets map onto my research domains of interest? (e.g. socioeconomic factors, childhood adverse events, medical diagnoses, culture and community)

There are many existing tools that allow you to browse metadata for health datasets, read more [here](https://aim-rsf.github.io/browseMetadata/articles/browseMetadata.html).

## What is the `browseMetadata` package?


This `R` package is a planning tool, designed to be used alongside other tools and sources of information about health datasets for research. For many health datasets, including SAIL, the metadata is publicly available. This `R` package uses the [Health Data Research Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) and the connected [Metadata Catalogue](https://modelcatalogue.cs.ox.ac.uk/hdruk_live/). This `R` package takes a metadata file as input and facilitates the process of browsing through each table within a chosen dataset. The user is asked to categorise each data element (variable) within a table into a domain related to their research question, and these categorisations get saved in a csv file for later reference.

To speed up this process, the function automatically categorises some variables that regularly appear in health datasets (e.g. ID, Sex, Age). The function also accounts for the same data element appearing in multiple tables across a dataset, and allows the user to active a table copying function which copies categorisations they've done for previous tables, into the current table they are processing.

🚧 :warning: This package is in early development, and has only been tested on a limited number of metadata files. In theory, this package should work for any dataset listed on the Health Data Research Gateway (not just SAIL) as long as a json metadata file can be downloaded. In practice, it has only been tested on a limited number of metadata files for SAIL databank.


## Getting started with `browseMetadata`

### Terminology

-   We use *Dataset* (collection of data, can contain multiple tables) - this is called *Data Asset* in the Metadata Catalogue
-   We use *Table* - this is called *Data Class* in the Metadata Catalogue
-   We use *Data Element* - the same as the Metadata Catalogue - which refers to each variable name within the table

### Install

Run in the R console:

``` r
install.packages("devtools")
devtools::install_github("aim-rsf/browseMetadata")
```

### Demo (use R Studio)

Load the library:

``` r
library(browseMetadata)
```

Read the documentation:

```         
?domain_mapping
```

Set your working directory to be an empty folder you just created:

```         
setwd("/Users/your-username/test-browseMetadata")
```

Run the function in demo mode:

``` r
domain_mapping()
```

Take note of the **Plots** tab in R Studio which should show a table of domains with this info:

-   [0] *NO MATCH / UNSURE*
-   [1] *METADATA*
-   [2] *ID*
-   [3] *DEMOGRAPHICS*
-   [4] Socioeconomic info
-   [5] Location info
-   [6] Education info
-   [7] Health info

Reference this Plots tab throughout the demo run. You will be asked to label data elements with one (or more) of these numbers [0-7].

Here we have very simple domains [4-7] for the demo run.

For a research study, your domains are likely to be much more specific e.g. 'Prenatal, antenatal, neonatal and birth' or 'Health behaviours and diet'.

The 4 default domains are always included [0-3], appended on to any domain list given.

```         
ℹ Running domain_mapping in demo mode using package data files
ℹ Using the default look-up table in data/look-up.rda
 
Enter your initials: RS
```

Respond with your initials after the prompt and press enter. It will then print the name of the dataset and where it was retrieved from:

```         
── Dataset Name ──────────────────────────────────────────────────────────────────────────────────────────────────────
National Community Child Health Database (NCCHD)

── Dataset Last Updated ──────────────────────────────────────────────────────────────────────────────────────────────
2024-03-14T17:40:57.463Z

── Dataset File Exported By ──────────────────────────────────────────────────────────────────────────────────────────
Rachael Stickland at 2024-04-05T13:01:23.109Z

Would you like to read a description of the dataset? (y/n): y
```

Enter Y after the prompt to read the description, for the purpose of the demo.

After reading the description of this dataset it will show:

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

To process multiple tables at once (e.g. CHILD, SIG_COND) include their numbers on multiple lines:

```         
ℹ Enter each table number you want to process in this interactive session.

1: 1
2: 13
3:
```

It will then ask if you want to read a description of this table:

```         
ℹ Processing Table 2 of 13

── Table Name ────────────────────────────────────────────────────────────────────────────────────────────────────────
CHILD

── Table Last Updated ────────────────────────────────────────────────────────────────────────────────────────────────
2024-03-14T17:40:46.509Z 

Would you like to read a description of the table? (y/n): y
```

Enter Y after the prompt to read the description, for the purpose of the demo.

You can provide an optional free text note about this table, this will be saved in the log file.

It will now start looping through the data elements. If it skips over one it means it was auto-categorised or copied from a previous table already processed (more on that later).

For this demo, it will only process 20 data elements (out of the 35 total).

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

We chose to respond with '7' because that corresponds to the 'Health info' domain in the table. More than one domain can be chosen.

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

The OUTPUT csv contains the categorisations you made. The LOG csv contains information about the session as a whole, including various metadata. These two csv files contain the same timestamp column. If you do not like the formatting of the OUTPUT csv, see the function [R/convert_output.R](R/convert_output.R) for an alternative. 

The PLOT png file saves a simple plot displaying the count of domain codes for that table.

### Using your own input files

``` r
domain_mapping(json_file, domain_file, look_up_file, output_dir, table_copy)
```

This code is in early development. To see known bugs or sub-optimal features refer to the [Issues](https://github.com/aim-rsf/browseMetadata/issues).

First, change the json file and domain file inputs. Later, consider changing the other 3 inputs, depending on your use-case. For example:

``` r
domain_mapping(json_file = 'path/your-json.json', domain_file = 'path/your-domains.csv')
```

Unlike in demo mode, it will ask you to specify the range of variables you want to process (start variable:end variable), because you can choose to process a table across multiple sessions (particularly useful if the table has a large number of data elements).

#### json file:

-   contains metadata about datasets of interest
-   downloaded from the metadata catalogue
-   see [data-raw/national_community_child_health_database\_(ncchd)\_20240405T130125.json](data-raw/national_community_child_health_database_(ncchd)_20240405T130125.json) for an example download

#### domain_file:

-   a csv file created by the user, with each domain listed on a separate line, no header
-   see [data-raw/domain_list_demo.csv](data-raw/domain_list_demo.csv) for a template
-   the first 4 domains will be auto populated (see demo above)

#### lookup file:

-   a [default lookup file](dataraw/look_up.csv) is used by the domain_mapping function
-   optional: a csv can be created by the user (using the same format as the default) and provided as the input
-   the lookup file makes auto-categorisations intended for variables that come up regularly in health datasets (e.g. IDs and demographics)
-   the lookup file only works for 1:1 mappings right now, i.e. the DataElement should only be listed once in the lookup file

#### output dir: 

- the path to the directory where the two csv output files will be saved. By default, the current working directory is used

#### table_copy:

-   default is TRUE, so set this to FALSE if you want to deactivate table copying
- table copying means that the categorisations you made for previous tables will be carried over to this table, as long as the csv files share an output_dir
-   this can be useful because the same data elements (variables) appear across multiple tables within one dataset
-   copying from one table to the next will save the user time, and ensure consistency of categorisations across tables
-   the 'Note' column in the output csv file will indicate that the categorisation has been copied and where from
-   a typical session could look like this:

*Run 1, select table 'CHILD'*

```         
ℹ Processing Table 6 of 13

── Table Name ──

CHILD

── Table Last Updated ──

[datetime]
```

*Run 2, select table 'CHILD_BIRTHS' (the function notices we have already run the table 'CHILD')*

```
ℹ Processing Table 7 of 13

── Table Name ──

CHILD_BIRTHS

── Table Last Updated ──

[datetime]
...
ℹ Copying from previous session(s): 

[1] "OUTPUT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_[datetime].csv"

```

*Run 3, select table 'PATH_BLOOD_TESTS' (the function notices we have already run the table 'CHILD' and 'CHILD_BIRTHS')*

```
ℹ Processing Table 8 of 13

── Table Name ──

PATH_BLOOD_TESTS

── Table Last Updated ──

[datetime]
...
ℹ Copying from previous session(s): 

[1] "OUTPUT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_[datetime].csv"
[2] "OUTPUT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_BIRTHS_[datetime].csv"

```

*And so on ...* Each run where you process a table has the potential to be shorter for the user to complete because if there are the same data elements that appear across tables, the user will not be asked to categorise them twice.

### Potential use-cases for the output files

The csv output file containing the categorisation for each data element could be used as an input in later analysis steps to filter variables and visualise how each variable maps to research domains of interest.

Categorisations across researchers can be compared by using the function [R/compare_sessions.R](R/compare_sessions.R). Type `?compare_sessions` to read the manual on how to run this function. In brief, it compares csv outputs from two sessions, finds their differences, and asks for a consensus.

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

We warmly welcome contributions to the browseMetadata project. Whether it's fixing bugs, adding new features, or improving documentation, we welcome your involvement.

-   **Report Issues**: If you find a bug or have a feature request, please report it via [GitHub Issues](https://github.com/aim-rsf/browseMetadata/issues).
-   **Submit Pull Requests**: We welcome pull requests. Please read our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md) on how to make contributions.
-   **Feedback and Suggestions**: We're always looking to improve, and we value feedback and suggestions. Feel free to open an issue to share your thoughts.

For more information on how to contribute, please refer to our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md).

### Contributors ✨

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification, using the ([emoji key](https://allcontributors.org/docs/en/emoji-key)). Contributions of any kind welcome!

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| [![Rachael Stickland](h%20ttps://avatars%20.githubusercon%20tent.com/u/502%2015726?v=4?s=10%200){alt="Rachae l Stickland"}\                                                                                                                          | [![Batool Almarzouq](https://avatar%20s.githubuserco%20ntent.com/u/53%20487593?v=4?s=1%2000){alt="Batoo l Almarzouq"}\                                                                                                                   | [![Mahwish Mohammad](https://avatar%20s.githubuserco%20ntent.com/u/43%20926907?v=4?s=1%2000){alt="Mahwi sh Mohammad"}\                                                                                                                          | [![Daniel Delbarre](https://avatar%20s.githubuserco%20ntent.com/u/10%208824056?v=4?s=%20100){alt="Dani el Delbarre"}\ |
| \~**Rachae l Stickland** \~](http://link%20edin.com/in/rs%20tickland-phd)\                                                                                                                                                                           | \~**Batoo l Almarzouq** \~](https://bat%20ool-almarzouq.%20netlify.app/)\                                                                                                                                                                | ~**Mahwish Moham\ mad**~](https:%20//github.com/R%20ainiefantasy)\                                                                                                                                                                              | ~**Daniel D\ elbarre**~](ht%20tps://github.c%20om/DDelbarre)\                                                         |
| [🖋](#content-RaySt%20ick "Content") [📖](https://gith%20ub.com/aim-rsf%20/browseMetadat%20a/commits?auth%20or=RayStick "D ocumentation") [🚧](#mainten%20ance-RayStick%20%22Maintenance%22) [🤔](#ide%20as-RayStick "I deas, Planning , & Feedback") | [📓](#userTest ing-BatoolMM " User Testing") [👀](https://%20github.com/aim%20-rsf/browseMet%20adata/pulls?q=%20is%3Apr+review%20ed-by%3ABatool%20MM "Reviewed P ull Requests") [🤔](#ide%20as-BatoolMM "I deas, Planning , & Feedback") | [📓]( #userTesting-R ainiefantasy " User Testing") [👀] (<https://githu> b.com/aim-rsf/ browseMetadata /pulls?q=is%3A pr+reviewed-by %3ARainiefanta sy "Reviewed P ull Requests") [🤔](#ideas-Ra%20iniefantasy "I deas, Planning , & Feedback") | [🤔](#idea%20s-DDelbarre "I deas, Planning , & Feedback") [ 📓](#userTesti ng-DDelbarre " User Testing")              |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+

<!-- markdownlint-restore -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

### Acknowledgements ✨

Thank you to multiple members of the [MELD-B research project](https://www.southampton.ac.uk/publicpolicy/support-for-policymakers/policy-projects/Current%20projects/meld-b.page) and the [SAIL Databank](https://saildatabank.com/) team for providing use-cases of meta data browsing, ideas and feedback. Thank you to the [Health Data Research Innovation Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) for hosting openly available metadata for health datasets, and for data providers that have included their datasets on this gateway.
