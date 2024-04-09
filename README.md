
# browseMetadata
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10581500.svg)](https://doi.org/10.5281/zenodo.10581500)


This `R` package was created to help a researcher browse the health
datasets in [SAIL databank](https://saildatabank.com). It has scope
to be applied to other health datasets. It is intended to be useful 
in the earlier stages of a project. When a research team has not yet 
got access to the data they can still browse the metadata, and 
address such questions as:

:question: what datasets are available?

:question: what datasets do I need for my research question?

:question: which variables within these datasets map onto my research
domains of interest? (e.g. socioeconomic factors, childhood adverse
events, medical diagnoses, culture and community)

## What does the R package do?

This `R` package is a planning tool, designed to be used alongside other
tools and sources of information about health datasets for research.
For many health datasets, including SAIL, the metadata is publicly available. 
This `R` package uses the [Health Data Research Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets)
and the connected [Metadata Catalogue](https://modelcatalogue.cs.ox.ac.uk/hdruk_live/). 
This `R` package takes a metadata file as input and facilitates the process 
of browsing through each table within a chosen dataset. The user is asked to 
categorise each data element (variable) within a table into a domain related 
to their research question, and these categorisations get saved in a csv file 
for later reference. To speed up this process, the function automatically 
categorises some variables that regularly appear in health datasets 
(e.g. ID, Sex, Age).

🚧 :warning: This package is in early development, and has only been
tested on a limited number of metadata files. In theory, this package
should work for any dataset listed on the Health Data Research Gateway
(not just SAIL) as long as a json metadata file can be downloaded. In
practice, it has only been tested on a limited number of metadata files
for SAIL databank.

## Getting started with metadata

There are many existing tools that allow you to browse metadata for
health datasets. These are listed in the [RESOURCES.md](RESOURCES.md)
file in this repository. 

**:bulb: These tools may be sufficient for you to
address the example questions listed above.**

## Getting started with this `R` package `browseMetadata`

### Terminology 
- We use *Dataset* (collection of data, can contain multiple tables) - this is called *Data Asset* in the Metadata Catalogue
- We use *Table* - this is called *Data Class* in the Metadata Catalogue
- We use *Data Element* - the same as the Metadata Catalogue - which refers to each variable name within the table

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

Run the function in demo mode:
``` r
domain_mapping()
```

Take note of the **Plots** tab in R Studio which should show a table of domains with this info:

- [0] *NO MATCH / UNSURE*
- [1] *METADATA*
- [2] *ALF ID*
- [3] *OTHER ID*
- [4] *DEMOGRAPHICS*
- [5] Socioeconomic info 
- [6] Location info 
- [7] Education info
- [8] Health info

Reference this Plots tab throughout the demo run. You will be asked to label data elements with one (or more) of these numbers [0-8].

Here we have very simple domains [5-8] for the demo run. 

For a research study, your domains are likely to be much more specific e.g. 'Prenatal, antenatal, neonatal and birth' or 'Health behaviours and diet'.

The 5 default domains are always included [0-4], appended on to any domain list given.

``` 
✔ Running domain_mapping in demo mode using package data files
✔ Using the default look-up table in data/look-up.rda
 
Enter your initials: RS
```

Respond with your initials after the prompt and press enter.
It will then print the name of the dataset and where it was retrieved from:

```
── Dataset Name ──────────────────────────────────────────────────────────────────────────────────────────────────────
National Community Child Health Database (NCCHD)

── Dataset Last Updated ──────────────────────────────────────────────────────────────────────────────────────────────
2024-03-14T17:40:57.463Z

── Dataset File Exported By ──────────────────────────────────────────────────────────────────────────────────────────
Rachael Stickland at 2024-04-05T13:01:23.109Z

Would you like to read a description of the dataset? (Y/N): Y
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

Would you like to read a description of the table? (Y/N): Y
```

Enter Y after the prompt to read the description, for the purpose of the demo.

It will now start looping through the data elements. If it skips over one it means it was auto-categorised (more on that later).

```
✔ Processing data element 1 of 20

✔ Processing data element 2 of 20

✔ Processing data element 3 of 20

✔ Processing data element 4 of 20

DATA ELEMENT ----->  APGAR_1 

DESCRIPTION ----->  APGAR 1 score. This is a measure of a baby's physical state at birth with particular reference to asphyxia - taken at 1 minute. Scores 3 and below are generally regarded as critically low; 4-6 fairly low, and 7-10 generally normal. Field can contain high amount of unknowns/non-entries. 

DATA TYPE ----->  CHARACTER 

Categorise this data element into one or more domains, e.g. 5 or 5,8: 8
```
We chose to respond with '8' because that corresponds to the 'Health' domain in the table. More than one domain can be chosen. 

It will then ask us to write a note for this categorisation:

```
Write a note to go with this decision (or 'N'): N
```

After completing 20, it will then ask you to review the auto-categorisations it made. 

```
! Please check the auto categorised data elements are accurate for table CHILD:

     DataElement Domain_code
1          ALF_E           2
2   ALF_MTCH_PCT           2
3     ALF_STS_CD           2
6  AVAIL_FROM_DT           1
19       GNDR_CD           4

ℹ Press enter to accept the auto categorisations for table CHILD or enter each row you'd like to edit:

1: 
```

Press enter for now. It will then ask you if you want to review the categorisations you made. Respond Y to review:

```
Would you like to review your categorisations? (Y/N): Y

            DataElement Domain_code
4               APGAR_1           8
5               APGAR_2           8
7           BIRTH_ORDER           8
8              BIRTH_TM         1,8
9          BIRTH_WEIGHT           8
10     BIRTH_WEIGHT_DEC           8
11 BREASTFEED_8_WKS_FLG           8
12 BREASTFEED_BIRTH_FLG           8
13           CHILD_ID_E           3
14    CURR_LHB_CD_BIRTH         6,8
15               DEL_CD           8
16                  DOD         4,8
17        ETHNIC_GRP_CD           4
18             GEST_AGE         4,8
20  HEALTH_VISITOR_CD_E           3

ℹ Press enter to accept your categorisations for table CHILD, or enter each row number you'd like to edit:

1: 8
2: 14
3: 
```

If you want to change your categorisation, enter in the row number (e.g. 8 for BIRTH_TM and 14 for CURR_LHB_CD_BIRTH). 

It will then take you through the same process as before, and you can over-write your previous categorisation. 

```
✔ Your final categorisations have been saved to LOG_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-04-05_14-37-36.csv
```

All finished! Take a look at the csv output. 

#### Output

The output of your decisions will be saved to a csv file.
The csv file name includes the dataset, table, and date stamp.
This csv file, in addition to what is shown on the console, contains: 
- user initials (from user input)
- metadata version (from json)
- date time stamp the metadata was last updated (from json) 
- dataset name (from json)

The intended use case for this log file is to be loaded up, compared across
users, and used as an input in later analysis steps when working out
which variables can be used to represent which research domains.

### Using your own input files 

```r
domain_mapping(json_file, domain_file, look_up_file)
```

This code is in early development. To see known bugs or sub-optimal features refer to the [Issues](https://github.com/aim-rsf/browseMetadata/issues). 

Run the code the same as the demo, using your own input files. 

The json file:
- contains metadata about datasets of interest
- downloaded from the metadata catalogue 
- see [data-raw/national_community_child_health_database_(ncchd)_20240405T130125.json](data-raw/national_community_child_health_database_(ncchd)_20240405T130125.json) for an example download 

The domain_file:	
- a csv file created by the user, with each domain listed on a separate line
- see [data-raw/domain_list_demo.csv](data-raw/domain_list_demo.csv) for a template
- the first 5 domains will be auto populated (see demo above)

The lookup file:
- a [default lookup file](data-raw/look_up.csv) is used by the domain_mapping function
- optional: a csv can be created by the user (using the same format as the default) and provided as the input
- the lookup file makes auto-categorisations - intended for variables that come up regularly in health datasets (e.g. IDs and demographics)
- the lookup file only works for 1:1 mappings right now, i.e. the DataElement should only be listed once in the lookup file

## License

This project is licensed under the GNU General Public License v3.0 - see
the [LICENSE](LICENSE) file for details.

The GNU General Public License is a free, copyleft license for software
and other kinds of works. For more information, please refer to
<https://www.gnu.org/licenses/gpl-3.0.en.html>.

## Citation

To cite package ‘browseMetadata’ in publications use:

> Stickland R (2024). browseMetadata: Browses available metadata, to
> catergorise/label each variable in a dataset. R package version 0.1.0.

A BibTeX entry for LaTeX users is

```         
  @Manual{,
    title = {browseMetadata: Browses available metadata, to catergorise/label each variable in a dataset},
    author = {Rachael Stickland},
    year = {2024},
    note = {R package version 0.1.0},
    doi = {https://doi.org/10.5281/zenodo.10581500},
  }
```

## Contributing

We warmly welcome contributions to the browseMetadata project. Whether it's fixing bugs, adding new features, or improving documentation, we welcome your involvement. 

- **Report Issues**: If you find a bug or have a feature request, please report it via [GitHub Issues](https://github.com/aim-rsf/browseMetadata/issues).
- **Submit Pull Requests**: We welcome pull requests. Please read our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md) on how to make contributions.
- **Feedback and Suggestions**: We're always looking to improve, and we value feedback and suggestions. Feel free to open an issue to share your thoughts.

For more information on how to contribute, please refer to our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/blob/main/CONTRIBUTING.md).

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
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

### Acknowledgements ✨

Thank you to multiple members of the [MELD-B research project](https://www.southampton.ac.uk/publicpolicy/support-for-policymakers/policy-projects/Current%20projects/meld-b.page) and the [SAIL Databank](https://saildatabank.com/) team for providing use-cases of meta data browsing, ideas and feedback. Thank you to the [Health Data Research Innovation Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) for hosting openly available metadata for health datasets, and for data providers that have included their datasets on this gateway.
