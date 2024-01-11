
# About `browseMetadata`

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All
Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END --> [![Lifecycle:


This `R` package was created to help a researcher browse the health
datasets in the [SAIL databank](https://saildatabank.com). It is
intended to be useful in the *earlier* stages of a project, where
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
should work for **any dataset listed on the Health Data Research Gateway
(not just SAIL)** as long as a json metadata file can be downloaded. In
practice, it has only been tested on a limited number of metadata files
for SAIL databank.

## Getting started with metadata

There are many existing tools that allow you to browse metadata for
health datasets. These are listed in the [RESOURCES.md](RESOURCES.md)
file in this repository. :bulb: These tools may be sufficient for you to
address the example questions listed above.

## Getting started with this `R` package `browseMetadata`

### Install

Run in the R console:

``` r
install.packages("devtools")
devtools::install_github("aim-rsf/browseMetadata")
```

### Example run through

Execute `?domain_mapping` in the R console to read the documentation.

Execute `domain_mapping()` in the R console to run this function in demo
mode. Follow the example in the documentation.

For demo mode, you do not need to provide your own input files. It will
use the package data.

Remember to reference the Plots tab in R. The domains will appear in the
Plot tab and give you the necessary context for the categorisations.

When using your own inputs, take note that these domain categories will
be added to your domain list by default: - NO MATCH / UNSURE -
METADATA - ALF ID - OTHER ID - DEMOGRAPHICS

### The log file output

Running the function will output a log file with your decisions. An
example log file output is shown below (left) with the demo domain list
that was used to create it (right). The name of the log file will
contain the date and time stamp, as well as Data Class and Data Asset.
The log file will contain initials of the person making the
catergorisations, as well as metadata about the dataset. For each Data
Element (variable) in the DataClass, the log file will contain a
'Domain_code' which labels this variable as mapping onto one or more of
the domains of interest. Notice that some have been auto categorised -
double check them for accuracy. More than one domain is allowed to map
onto each variable.

![](https://github-production-user-asset-6210df.s3.amazonaws.com/50215726/268979307-4e2ded4f-f425-418c-b0bc-9a9cec7c6fe7.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20240110%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240110T150116Z&X-Amz-Expires=300&X-Amz-Signature=e3f02943c068a130dbb6a58e5e17d22afc5425c9235055e73fc9b688ea670c52&X-Amz-SignedHeaders=host&actor_id=53487593&key_id=0&repo_id=675673962)

The idea would be that this log file could be loaded up, compared across
users, and used as an input in later analysis steps when working out
which variables can be used to represent which domains.

## License

This project is licensed under the GNU General Public License v3.0 - see
the [LICENSE](LICENSE) file for details.

The GNU General Public License is a free, copyleft license for software
and other kinds of works. For more information, please refer to
<https://www.gnu.org/licenses/gpl-3.0.en.html>.

## Contributing changes

You can contribute changes to this repository via submitting an Issue to
request a change, or create a Pull Request with your direct changes.

If you are working on changes to the R package:

To create the .rda files in the data directory of the package:
`usethis::use_data(dataname)`

To view the package data: `data(package='browseMetadata')`

To load the package data: `data(dataname)`

To build the documentation files: `library(roxygen2)` `roxygenise()`

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
  }
```

### Contributors ✨

This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors)
specification, using the ([emoji
key](https://allcontributors.org/docs/en/emoji-key)). Contributions of
any kind welcome!

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

+----------------------+----------------------+----------------------+
| [![Rachael           | [![Batool            | [![Mahwish           |
| Stickland](https     | Almarzouq](http      | Mohammad](http       |
| ://avatars.githubuse | s://avatars.githubus | s://avatars.githubus |
| rcontent.com/u/50215 | ercontent.com/u/5348 | ercontent.com/u/4392 |
| 726?v=4?s=100){alt=" | 7593?v=4?s=100){alt= | 6907?v=4?s=100){alt= |
| Rachael Stickland"}\ | "Batool Almarzouq"}\ | "Mahwish Mohammad"}\ |
| ~**Ra                | ~**B                 | ~**Mahwish\ Mohamma  |
| chael\ Stickland**~] | atool\ Almarzouq**~] | d**~](https://github |
| (http://linkedin.com | (https://batool-alma | .com/Rainiefantasy)\ |
| /in/rstickland-phd)\ | rzouq.netlify.app/)\ | [📓](#u              |
| [🖋](#content         | [📓                  | serTesting-Rainiefan |
| -RayStick "Content") | ](#userTesting-Bato  | tasy "User Testing") |
| [📖](htt             | olMM "User Testing") |                      |
| ps://github.com/aim- | [👀](https:/         |                      |
| rsf/browse-metadata/ | /github.com/aim-rsf/ |                      |
| commits?author=RaySt | browse-metadata/pull |                      |
| ick "Documentation") | s?q=is%3Apr+reviewed |                      |
| [                    | -by%3ABatoolMM "Revi |                      |
| 🚧](#maintenance-Ray | ewed Pull Requests") |                      |
| Stick "Maintenance") | [🤔](#ideas          |                      |
| [🤔](#ideas          | -BatoolMM "Ideas, Pl |                      |
| -RayStick "Ideas, Pl | anning, & Feedback") |                      |
| anning, & Feedback") |                      |                      |
+----------------------+----------------------+----------------------+

<!-- markdownlint-restore -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
