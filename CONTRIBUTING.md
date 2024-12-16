# Contributing to browseMetadata

We warmly welcome contributions to the browseMetadata project! 
This document provides guidelines for contributing to this repository.

## How to contribute

### Reporting issues

- **Bug Reports**: If you find a bug, please open an issue with a clear description of the problem and steps to reproduce it.
- **Feature Requests**: Suggestions for new features or improvements are always welcome. Please open an issue to discuss your ideas.

### Making changes

1. **Fork the Repository**: Start by forking the repository to your GitHub account.
2. **Create a Feature Branch**: Create a new branch for your feature or fix.
3. **Make Your Changes**: Implement your changes, adhering to the coding standards and practices outlined below.
4. **Test Your Changes**: Ensure your changes do not break any existing functionality.
5. **Submit a Pull Request**: Open a pull request from your feature branch to the main branch of the original repository.

### Coding standards

- Follow the [tidyverse style guide](https://style.tidyverse.org) for R code.
- Write clear, readable, and maintainable code.
- Include comments and documentation as needed.

### Documentation

- Update the README or other documentation if necessary.
- Clearly describe the changes you've made and their benefits.

## Contributing to the R Package - as an author or reviewer of a PR

If your contribution involves changes to the R package itself (as an author or reviewer of a PR), here are some specific guidelines, assuming you are using RStudio as your editor:

1. Clone this GitHub repository locally and ensure all branches you need are up to date with remote. 
> In R Studio, you can clone it by clicking on `File` > `New Project...`, then select `Version Control`, and choose `Git`. Enter the repository URL (e.g., `https://github.com/aim-rsf/browseMetadata`), select the directory to clone the repository into, and click `Create Project`.
2. You should have a **Git** tab in your workspace.
3. In this **Git** tab, move to the branch you want to make changes in (or review and test the changes of someone else).
4. Ensure that your current working directory is the R package directory you cloned (`getwd()` to check and `setwd()` to change).
5. Run `devtools::load_all()` in the R console. You should see `ℹ Loading browseMetadata` returned.
6. Make your changes (or review changes made by others), and commit these changes in the way you choose to interact with git locally!

If you run into issues with branches not seeming to be up to date in the R Studio workspace, consider running `remove.packages("browseMetadata")` and trying the above steps again, in case a previously installed package library is getting in the way somehow. 
   
### Working with package data

- **Creating .rda Files**: To create `.rda` files in the data directory of the package, use the following command in R:
  ```R
  usethis::use_data(dataname)
  ```
  Replace `dataname` with the actual name of your data.

- **Viewing Package Data**: To view the data included in the `browseMetadata` package, execute:
  ```R
  data(package='browseMetadata')
  ```

- **Loading Package Data**: To load specific data from the package, use:
  ```R
  data(dataname)
  ```
  Again, replace `dataname` with the name of the data you wish to load.

### Building documentation

- **Generating Documentation Files**: To build the documentation files for the package, use the `roxygen2` package:
  ```R
  devtools::document() 
  ```
  This will generates the .Rd files from any updated roxygen comments.

### Testing your changes and check your style :sunglasses:

Ensure that your changes do not break any existing functionality. Run any existing tests, and consider adding new tests to cover your changes. Here are some helpful functions to consider:

- `codemetar::write_codemeta()` ensures the metadata file is up to date.
- `lintr::lint_package(path = ".")` checks for adherence to a given style, identifying syntax errors and possible semantic issues
- `desc::desc_normalize()` to ensure DESCRIPTION file follows a standard structure and style
- `styler::style_pkg()` ensures consistent code styling that match the guidelines.
- `devtools::check()` runs a comprehensive package check. 
- https://docs.ropensci.org/pkgcheck/ (but there is also GitHub Action that runs this)

### Submitting Changes

- After making your changes, test them thoroughly.
- Update the documentation to reflect your changes, if applicable.
- Submit a pull request with a clear description of your changes and the benefits they bring to the package.

## Questions or Need Help?

If you have questions or need help, feel free to open an issue for discussion or reach out to the maintainers directly.

Thank you for contributing to browseMetadata!
