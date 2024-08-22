
valid_comparison <- function(input1, input2,severity,text){

  # use in browseMetadata_compare_outputs
  #severity: warning or danger

  if (severity == 'danger'){
    if (input1 != input2){
      cat("\n\n")
      cli_alert_danger(paste('Exiting! ',text))
      stop()}
  } else if (severity == 'warning'){
    if (input1 != input2){
      cat("\n\n")
      cli_alert_warning(paste(text,'\n Valid comparison may not be possible - please check!'))
      continue <- readline("Press enter to continue or Esc to cancel: ")}
  }

}

