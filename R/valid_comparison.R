#use in browseMetadata_compare_outputs
#severity: warning or danger

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

