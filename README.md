
# browseMetadata
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All
Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

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

![](vignettes/images/example-log-file.png)

The idea would be that this log file could be loaded up, compared across
users, and used as an input in later analysis steps when working out
which variables can be used to represent which domains.

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
  }
```

## Contributing

We warmly welcome contributions to the browseMetadata project. Whether it's fixing bugs, adding new features, or improving documentation, we welcome your involvement. 

- **Report Issues**: If you find a bug or have a feature request, please report it via [GitHub Issues](https://github.com/aim-rsf/browseMetadata/issues).
- **Submit Pull Requests**: We welcome pull requests. Please read our [CONTRIBUTING.md](https://github.com/aim-rsf/browseMetadata/issues/CONTRIBUTING.md) for guidelines on how to make contributions.
- **Feedback and Suggestions**: We're always looking to improve, and we value feedback and suggestions. Feel free to open an issue to share your thoughts.

For more information on how to contribute, please refer to our [Contribution Guidelines](https://github.com/aim-rsf/browseMetadata/CONTRIBUTING.md).

### Contributors ✨

This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors)
specification, using the ([emoji
key](https://allcontributors.org/docs/en/emoji-key)). Contributions of
any kind welcome!

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://linkedin.com/in/rstickland-phd"><img src="https://avatars.githubusercontent.com/u/50215726?v=4?s=100" width="100px;" alt="Rachael Stickland"/><br /><sub><b>Rachael Stickland</b></sub></a><br /><a href="#content-RayStick" title="Content">🖋</a> <a href="https://github.com/aim-rsf/browse-metadata/commits?author=RayStick" title="Documentation">📖</a> <a href="#maintenance-RayStick" title="Maintenance">🚧</a> <a href="#ideas-RayStick" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://batool-almarzouq.netlify.app/"><img src="https://avatars.githubusercontent.com/u/53487593?v=4?s=100" width="100px;" alt="Batool Almarzouq"/><br /><sub><b>Batool Almarzouq</b></sub></a><br /><a href="#userTesting-BatoolMM" title="User Testing">📓</a> <a href="https://github.com/aim-rsf/browse-metadata/pulls?q=is%3Apr+reviewed-by%3ABatoolMM" title="Reviewed Pull Requests">👀</a> <a href="#ideas-BatoolMM" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Rainiefantasy"><img src="https://avatars.githubusercontent.com/u/43926907?v=4?s=100" width="100px;" alt="Mahwish Mohammad"/><br /><sub><b>Mahwish Mohammad</b></sub></a><br /><a href="#userTesting-Rainiefantasy" title="User Testing">📓</a></td>
    </tr>
  </tbody>
</table>


<!-- ALL-CONTRIBUTORS-LIST:END -->
