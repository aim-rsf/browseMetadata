# Contributing to browseMetadata

We warmly welcome contributions to the browseMetadata project! 
This document provides guidelines for contributing to this repository.

## How to Contribute

### Reporting Issues

- **Bug Reports**: If you find a bug, please open an issue with a clear description of the problem and steps to reproduce it.
- **Feature Requests**: Suggestions for new features or improvements are always welcome. Please open an issue to discuss your ideas.

### Making Changes

1. **Fork the Repository**: Start by forking the repository to your GitHub account.
2. **Create a Feature Branch**: Create a new branch for your feature or fix.
3. **Make Your Changes**: Implement your changes, adhering to the coding standards and practices outlined below.
4. **Test Your Changes**: Ensure your changes do not break any existing functionality.
5. **Submit a Pull Request**: Open a pull request from your feature branch to the main branch of the original repository.

### Coding Standards

- Follow the [tidyverse style guide](https://style.tidyverse.org) for R code.
- Write clear, readable, and maintainable code.
- Include comments and documentation as needed.

### Documentation

- Update the README or other documentation if necessary.
- Clearly describe the changes you've made and their benefits.

## Contributing to the R Package

If your contribution involves changes to the R package itself, here are some specific guidelines to follow:

### Working with Package Data

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

### Building Documentation

- **Generating Documentation Files**: To build the documentation files for the package, use the `roxygen2` package:
  ```R
  library(roxygen2)
  roxygenise()
  ```
  This will generate the necessary documentation based on your roxygen comments in the R code.

### Testing Your Changes

- Ensure that your changes do not break any existing functionality. Run any existing tests, and consider adding new tests to cover your changes.

### Submitting Changes

- After making your changes, test them thoroughly.
- Update the documentation to reflect your changes, if applicable.
- Submit a pull request with a clear description of your changes and the benefits they bring to the package.

## Questions or Need Help?

If you have questions or need help, feel free to open an issue for discussion or reach out to the maintainers directly.

Thank you for contributing to browseMetadata!
