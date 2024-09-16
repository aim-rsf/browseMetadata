#' valid_comparison

#' This function is called within the mapMetadata_compare_outputs function. \cr \cr
#' It reads two inputs to see if they are equal. \cr \cr
#' If the test is 'warning' status and inputs are not equal it gives warning but continues. \cr \cr
#' If the test is 'danger' status and inputs are not equal it stops and exits, with error message. \cr \cr
#' @param input1 Input 1
#' @param input2 Input 2
#' @param severity Level of severity. Only 'danger' or 'warning'
#' @param severity_text The text to print if inputs are not equal.
#' @return Returns nothing if inputs are equal. If inputs are not equal, returns variable text depending on level of severity.

valid_comparison <- function(input1, input2, severity, severity_text) {

  if (!severity %in% c('danger', 'warning')) {
    stop("Invalid severity. Only 'danger' and 'warning' are allowed.")
  }

  if (severity == 'danger') {
    if (input1 != input2) {
      cat('\n')
      stop(paste(severity_text,"-> Exiting!"))
    }
  } else if (severity == 'warning') {
    if (input1 != input2) {
      cat('\n')
      cli::cli_alert_warning(paste(severity_text,"-> Continuing but please check comparison is valid!"))
    }
  }
  }

