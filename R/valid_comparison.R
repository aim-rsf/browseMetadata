#use in browseMetadata_compare_outputs
#need to document this properly but the general idea is -
#reads in 2 inputs to see if they are equal
#if the test is 'warning' and inputs are not equal it just gives a warning to the user and continues
#if the test is 'danger' and the inputs are not equal it stops and exists out of the main function

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
      cli_alert_warning(paste(severity_text,"-> Continuing but please check comparison is valid!"))
    }
  }
  }

