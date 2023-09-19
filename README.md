# About 

This R package is written to help the initial process of mapping domains of interest (latent concepts) used in research, onto variables found in SAIL databank. 

For instance, if a researcher wants to access datasets within SAIL databank, how do they know which variables will be represent the concepts they care about for their research question? There is a lot of meta data already publicly available on the [Health Data Research Gateway](https://web.www.healthdatagateway.org/search?search=&datasetSort=latest&tab=Datasets) and the connected [Metadata Catalogue](https://modelcatalogue.cs.ox.ac.uk/hdruk_live/). This demo package uses this meta data.

⚠️ More discussion is needed with researchers to work out how to make this package useful. It is currently just a demo and has only been tested on a limited number of metadata files. 

:bulb: In theory, this package should work for any dataset listed on the Health Data Research Gateway, as long as a json metadata file can be downloaded. In practice, it has only been tested on SAIL databank files. 

## Install 

Download/clone this repository to your computer.

Install required packages: `devtools`, `gridExtra`, `grid`, `insight`, `rjson`

Then in the R console run:

`library(devtools)`

`load_all("/path-to-repo/browse-SAIL/browseSAIL")`

`library(browseSAIL)`

## Example run through 
Run `?domain_mapping` in the R console to find the documentation.

Follow the example in the documentation. You don't need to provide any input data!

Remember to reference the Plots tab in R. The domains will appear in the Plot tab and give you the necessary context for the categorisations. 

When using your own inputs, take note that these domain categories will be added to your domain list:
- NO MATCH / UNSURE
- METADATA
- ALF ID
- OTHER ID
- DEMOGRAPHICS

## The log file output

Running the function will output a log file with your decisions. An example log file output is shown below (left) with the demo domain list that was used to create it (right). The name of the log file will contain the date and time stamp, as well as Data Class and Data Asset. The log file will contain initials of the person making the catergorisations, as well as metadata about the dataset. For each Data Element (variable) in the DataClass, the log file will contain a 'Domain_code' which labels this variable as mapping onto one or more of the domains of interest. Notice that some have been auto categorised - double check them for accuracy. More than one domain is allowed to map onto each variable. 

<img width="1864" alt="logfile-ex" src="https://github.com/aim-rsf/browse-SAIL/assets/50215726/4e2ded4f-f425-418c-b0bc-9a9cec7c6fe7">

The idea would be that this log file could be loaded up, compared across users, and used as an input in later analysis steps when working out which variables can be used to represent which domains. 

## Contributing changes 

You can contribute changes via submitting an Issue to request a change, or create a PR with your direct changes. 

To create the .rda files in the data directory of the package:
`usethis::use_data(dataname)`

To view the package data:
`data(package='browseSAIL')`

To load the package data:
`data(dataname)`

To build the documentation files:
`library(roxygen2)`
`roxygenise()`
