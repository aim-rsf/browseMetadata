---
editor_options: 
  markdown: 
    wrap: 72
---

# About `browse-SAIL`

As the name suggests, this repository was created to help a researcher
browse the datasets in the [SAIL databank](https://saildatabank.com). It
is intended to be useful in the *earlier* stages of a project, where
datasets are being scoped out. When a research team has not yet got
access to the data they can still browse the meta data, and start to
address such questions as:

:question: what datasets are available?

:question: what datasets do I need for my research question?

:question: which variables within these datasets map onto my domains of
interest (latent concepts)?

## What does the R package do?

This R package is a planning tool, designed to be used alongside other
tools and sources of information about health datasets for research.

If a researcher wants to access datasets within SAIL databank, how do
they know which variables will represent the concepts they care about
for their research question? There is a lot of meta data already
publicly available on the [Health Data Research
Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets)
and the connected [Metadata
Catalogue](https://modelcatalogue.cs.ox.ac.uk/hdruk_live/). This demo
package uses this meta data, loads it up into R, and gets the user to
browse through each dataset and variable. The user is asked to
categorise each variable into a domain related to their research
question, and these categorisations get saved in a csv file for later
reference.

🚧 It is still in demo form and has only been tested on a limited number
of metadata files.

## Beyond SAIL Databank

In theory, this package should work for any dataset listed on the Health
Data Research Gateway (not just SAIL) as long as a json metadata file
can be downloaded. In practice, it has only been tested on a limited
number of metadata files for SAIL databank.

## Getting started with meta data (and related resources)

There are many existing tools that allow you to browse meta data for
health datasets.

:bulb: These tools may be sufficient for you to address the questions
listed above.

📢 There are more tools out there. If you know of a tool that has wide
scope for health meta data, please request we add it here!

### [Health Data Research Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) and the connected [Metadata Catalogue](https://modelcatalogue.cs.ox.ac.uk/hdruk_live/)

> "a search-engine or 'portal' to help you find health datasets that
> exist in the UK"

> "The datasets that are discoverable through the Gateway are from
> organisations in the NHS, research institutes and charities, which are
> part of the UK Health Data Research Alliance."

The is the source of metadata for the R package in this repo
`browse-SAIL`

### [BHF DSC Dashboard](https://bhf-dsc-hds.shinyapps.io/cvd-covid-tre-dashboard)

> "an overview and interactive summaries of the datasets currently
> available through CVD-COVID-UK/COVID-IMPACT within the secure Trusted
> Research Environments (TREs) provided by NHS England for England, the
> National Data Safe Haven for Scotland and the SAIL databank for Wales"

This dashboard allows you to explore data dictionaries, data coverage
and data completeness.

### [HDRUK Phenotype Library](https://phenotypes.healthdatagateway.org)

> "The HDR UK Phenotype Library is a comprehensive, open access resource
> providing the research community with information, tools and
> phenotyping algorithms for UK electronic health records."

Also see the Concept Library -
[website](https://conceptlibrary.saildatabank.com) and
[GitHub](https://github.com/SwanseaUniversityMedical/concept-library) -
developed by the SAIL databank team and collaborating organisations.

## Getting started with this R package `browse-SAIL`

### Install

Download/clone this repository to your computer.

Install required packages: `devtools`, `gridExtra`, `grid`, `insight`,
`rjson`

Then in the R console run:

`library(devtools)`

`load_all("/path-to-repo/browse-SAIL/browseSAIL")`

`library(browseSAIL)`

### Example run through

Run `?domain_mapping` in the R console to find the documentation.

Follow the example in the documentation. You don't need to provide any
input data!

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

<img src="https://github.com/aim-rsf/browse-SAIL/assets/50215726/4e2ded4f-f425-418c-b0bc-9a9cec7c6fe7" alt="logfile-ex" width="1864"/>

The idea would be that this log file could be loaded up, compared across
users, and used as an input in later analysis steps when working out
which variables can be used to represent which domains.

## Contributing changes

You can contribute changes to this repository via submitting an Issue to
request a change, or create a Pull Request with your direct changes.

If you are working on changes to the R package:

To create the .rda files in the data directory of the package:
`usethis::use_data(dataname)`

To view the package data: `data(package='browseSAIL')`

To load the package data: `data(dataname)`

To build the documentation files: `library(roxygen2)` `roxygenise()`

## Citation

To cite package 'browseSAIL' in publications use:

> Stickland R (2023). *browseSAIL: Maps domains to varaibles within a
dataset (SAIL databank)*. R package version 0.1.0, <https://aim-rsf.github.io/browse-SAIL/>.

A BibTeX entry for LaTeX users is

```         
  @Manual{,
    title = {browseSAIL: Maps domains to varaibles within a dataset (SAIL databank)},
    author = {Rachael Stickland},
    year = {2023},
    note = {R package version 0.1.0},
    url = {https://aim-rsf.github.io/browse-SAIL/},
  }
```
