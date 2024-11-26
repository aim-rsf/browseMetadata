#' valid_comparison
#'
#' This function is called within the map_metadata_compare function. \cr \cr
#' It reads two inputs to see if they are equal. \cr \cr
#' If the test is 'warning' status and inputs are not equal it gives warning but continues. \cr \cr
#' If the test is 'danger' status and inputs are not equal it stops and exits, with error message. \cr \cr
#'
#' @param input_1 Input 1
#' @param input_2 Input 2
#' @param severity Level of severity. Only 'danger' or 'warning'
#' @param severity_text The text to print if inputs are not equal.
#' @return Returns nothing if inputs are equal. If inputs are not equal, returns variable text depending on level of severity.
#' @importFrom cli cli_alert_warning

valid_comparison <- function(input_1, input_2, severity, severity_text) {
  if (!severity %in% c("danger", "warning")) {
    stop("Invalid severity. Only 'danger' and 'warning' are allowed.")
  }

  if (severity == "danger") {
    if (input_1 != input_2) {
      cat("\n")
      stop(paste(severity_text, "-> Exiting!"))
    }
  } else if (severity == "warning") {
    if (input_1 != input_2) {
      cat("\n")
      cli_alert_warning(paste(severity_text, "-> Continuing but please check comparison is valid!"))
    }
  }
}

#' concensus_on_mismatch
#'
#' This function is called within the map_metadata_compare function. \cr \cr
#' For a specific data element, it compares the domain code categorisation between two sessions.
#' If the categorisation differs, it prompts the user for a new consensus decision by presenting the json metadata. \cr \cr
#'
#' @param ses_join The joined dataframes from the two sessions
#' @param table_df Metadata from the json file, for one table in the dataset
#' @param datavar Data Element n
#' @param domain_code_max The maximum allowable domain code integer
#' @return It returns a list of 2: the domain code and the note from the consensus decision
#' @importFrom cli cli_alert_info

concensus_on_mismatch <- function(ses_join, table_df, datavar, domain_code_max) {
  if (ses_join$domain_code_ses1[datavar] != ses_join$domain_code_ses2[datavar]) {
    cat("\n\n")
    cli_alert_info("Mismatch of DataElement {ses_join$DataElement[datavar]}")
    cat(paste(
      "\nDOMAIN CODE (note) for session 1 --> ", ses_join$domain_code_ses1[datavar], "(", ses_join$note_ses1[datavar], ")",
      "\nDOMAIN CODE (note) for session 2 --> ", ses_join$domain_code_ses2[datavar], "(", ses_join$note_ses2[datavar], ")"
    ))
    cat("\n\n")
    cli_alert_info("Provide concensus decision for this DataElement:")
    decision_output <- user_categorisation(table_df$label[datavar], table_df$description[datavar], table_df$type[datavar], domain_code_max)
    domain_code_join <- decision_output$decision
    note_join <- decision_output$decision_note
  } else {
    domain_code_join <- ses_join$domain_code_ses1[datavar]
    note_join <- "No mismatch!"
  }
  return(list(domain_code_join = domain_code_join, note_join = note_join))
}
