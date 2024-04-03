
# browseMetadata
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10581500.svg)](https://doi.org/10.5281/zenodo.10581500)


This `R` package was created to help a researcher browse the health
datasets in the [SAIL databank](https://saildatabank.com). It is
intended to be useful in the earlier stages of a project, where
datasets are being scoped out. When a research team has not yet got
access to the data they can still browse the metadata, and start to
address such questions as:

:question: what datasets are available?

:question: what datasets do I need for my research question?

:question: which variables within these datasets map onto my research
domains of interest? (e.g. socioeconomic factors, childhood adverse
events, medical diagnoses, culture and community)

## What does the R package do?

This `R` package is a planning tool, designed to be used alongside other
tools and sources of information about health datasets for research.

If a researcher wants to access datasets within SAIL databank, how do
they know which variables will represent the concepts they care about
for their research question? For many health datasets, including SAIL,
the metadata is publicly available. This `R` package uses the [Health
Data Research
Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets)
and the connected [Metadata
Catalogue](https://modelcatalogue.cs.ox.ac.uk/hdruk_live/). This `R`
package has a function which takes a metadata file as input and
facilitates the process of browsing through each dataset and variable.
The user is asked to categorise each variable into a domain related to
their research question, and these categorisations get saved in a csv
file for later reference. To speed up this process, the function
automatically categorises some variables that regularly appear in health
datasets (e.g. ID, Sex, Age).

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

### Demo

``` r
library(browseMetadata)
```

Read the documentation, then run the function in demo mode:
``` r
?domain_mapping

domain_mapping()
```

The R console will show:

``` 
ℹ Running domain_mapping in demo mode using package data files

Enter Initials: RS
```

Respond with your initials and press enter.
It will ask you if you want to read the description of Datasets and Tables:


```
── Dataset Name ────────────────────────────────────────────────────────────────────
Maternity Indicators Dataset (MIDS)

── Dataset Last Updated ────────────────────────────────────────────────────────────
2023-12-04T14:13:49.131Z

── Dataset File Exported By ────────────────────────────────────────────────────────
Rachael Stickland at 2024-01-05T13:22:09.774Z

ℹ Found 2 Tables in this Dataset

Would you like to read a description of the Dataset? (Y/N) Y
```
Enter Y to read these descriptions, for the purpose of the demo.

For this example, the Dataset is called MIDS and the tables inside this Dataset are BIRTH and INITIAL_ASSESSMENT.   

For each table, it will ask which data elements to process:

```
Enter the range of Data Elements to process. Press Enter to process all: 1,10
```

If you press enter it will process all the data elements, so use a smaller range like 1 to 10 the first time you run this demo.

For each data element you will be shown this structure:

```
DATA ELEMENT ----->  SERVICE_USER_HAS_MENTAL_HEALTH_CONDITION_CD 

DESCRIPTION ----->  Code indicating whether or not the woman has an existing mental health condition. 

DATA TYPE ----->  CHARACTER 
```

By referencing the plots tab, and other info you may have, categorise this data element with a number(s).
A  data element can map to more than one domain so a comma separated list of numbers can be given (7,8).

There is an (optional) note field to explain your choice. 

```
Categorise this data element: 8

Notes (write 'N' if no notes): N
```

If you make a mistake, the next prompt allows you to redo. Or press enter if you are happy to continue.

```
Press enter to continue or write 'redo' to correct previous answer: 
```

When you get to the end of your requested number of data elements it will show you data elements that have been auto categorised. 

If you want to change these auto categorisations, and do them manually, include the row number (1,9) in the list.

```
! Please check the auto categorised data elements are accurate:

 Table      DataElement        Domain_code
1      BIRTH    AVAIL_FROM_DT      1
9      BIRTH    CHILD_ALF_E        2
10     BIRTH    CHILD_ALF_STS_CD   2

Enter row numbers you'd like to edit or press enter to accept the auto categorisations:
```

Finally, it will ask you if you want to review the categorisations you previously made. 

```
Would you like to review your categorisations? (Y/N) 
```

If you say yes (with Y) it will take you through the same review process you just did for auto categorisations.

At the end of processing that table it will show:

```
ℹ Your final categorisations have been saved to LOG_MaternityIndicatorsDataset(MIDS)_BIRTH_2024-01-30_10-42-15.csv
```

The function will then repeat the same steps for the next table in the dataset (if there is more than one). 

#### Understanding the domain list 

For this demo, a simple list of domains are provided, see [data-raw/domain_list_demo.csv](data-raw/domain_list_demo.csv).

This list shows up in the R plot tab:

- [0] *NO MATCH / UNSURE*
- [1] *METADATA*
- [2] *ALF ID*
- [3] *OTHER ID*
- [4] *DEMOGRAPHICS*
- [5] Socioeconomic factors 
- [6] Location
- [7] Education
- [8] Health

There are 5 default domains always included [0-4], appended on to any domain list given.

For a research study, your domains are likely to be much more specific e.g. 'Prenatal, antenatal, neonatal and birth' or 'Health behaviours and diet'.

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

A subset of columns from the csv outputs are shown below, running with '1,10' data elements:

```
   Table         DataElement Domain_code                   Note
1      BIRTH       AVAIL_FROM_DT           1       AUTO CATEGORISED
2      BIRTH       BABY_BIRTH_DT           4                      N
3      BIRTH   BIRTH_APGAR_SCORE           8                      N
4      BIRTH       BIRTH_MODE_CD           8                      N
5      BIRTH         BIRTH_ORDER           8                      N
6      BIRTH    BIRTH_OUTCOME_CD           8                      N
7      BIRTH      BIRTH_TREAT_CD           0   No description given
8      BIRTH BIRTH_TREAT_SITE_CD           6                      N
9      BIRTH         CHILD_ALF_E           2       AUTO CATEGORISED
10     BIRTH    CHILD_ALF_STS_CD           2       AUTO CATEGORISED
```

```
            Table                                 DataElement Domain_code                           Note
1  INITIAL_ASSESSMENT                               AVAIL_FROM_DT           1               AUTO CATEGORISED
2  INITIAL_ASSESSMENT                                  GEST_WEEKS           8                              N
3  INITIAL_ASSESSMENT                              INITIAL_ASS_DT           8           Date of health visit
4  INITIAL_ASSESSMENT                              MAT_AGE_AT_ASS           4               AUTO CATEGORISED
5  INITIAL_ASSESSMENT                                MOTHER_ALF_E           2               AUTO CATEGORISED
6  INITIAL_ASSESSMENT                           MOTHER_ALF_STS_CD           2               AUTO CATEGORISED
7  INITIAL_ASSESSMENT                                     PROV_CD         6,8   Org code for health provider
8  INITIAL_ASSESSMENT                     SERVICE_USER_GRAVIDA_CD           8                              N
9  INITIAL_ASSESSMENT SERVICE_USER_HAS_MENTAL_HEALTH_CARE_PLAN_CD           8                              N
10 INITIAL_ASSESSMENT SERVICE_USER_HAS_MENTAL_HEALTH_CONDITION_CD           8                              N
 ```

### Using your own input files 

```r
domain_mapping(json_file, domain_file, look_up_file)
```

This code is in early development. To see known bugs or sub-optimal features refer to the [Issues](https://github.com/aim-rsf/browseMetadata/issues). 

Run the code the same as the demo, using your own input files. 

The json file:
- contains metadata about datasets of interest
- downloaded from the metadata catalogue 
- see [data-raw/maternity_indicators_dataset_(mids)_20240105T132210.json](data-raw/maternity_indicators_dataset_(mids)_20240105T132210.json) for an example download
- the metadata catalogue refers to datasets as 'data assets' and tables within these as 'data classes' 

The domain_file:	
- a csv file created by the user, with each domain listed on a separate line
- see [data-raw/domain_list_demo.csv](data-raw/domain_list_demo.csv) for a template
- the first 5 domains will be auto populated (see demo above)

The lookup file:
- a csv created by the user, mapping data elements (variables) to domains
- these auto-categorisations are meant for variables that come up regularly in health datasets (e.g. IDs and demographics)
- instead of using the default, the user can provide their own look-up table in the same format as [data-raw/look-up.csv](data-raw/look-up.csv)

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
