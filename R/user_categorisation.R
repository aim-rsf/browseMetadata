#' user_categorisation
#'
#' This function is called within the browseMetadata function. \cr \cr
#' It displays data properties to the user and requests a categorisation into a domain. \cr \cr
#' An optional note can be included with the categorisation.
#'
#' @param data_element Name of the variable
#' @param data_desc Description of the variable
#' @param data_type Data type of the variable
#' @param domain_code_max Max code in the domain list (0-3 auto included, then N included via domain_file)
#' @return It returns a list containing the decision and decision note

user_categorisation <- function(data_element,data_desc,data_type,domain_code_max) {

  first_run = TRUE
  go_back = ''

  while (go_back == "Y" | go_back == "y" | first_run == TRUE) {

    go_back = ''
    # print text to R console
    cat(paste(
      "\nDATA ELEMENT -----> ", data_element,
      "\n\nDESCRIPTION -----> ", data_desc,
      "\n\nDATA TYPE -----> ", data_type, "\n"
    ))

    # ask user for categorisation:

    decision <- ""
    validated = FALSE
    cat("\n \n")

    while (decision == "" | validated == FALSE) {
      decision <- readline("Categorise data element into domain(s). E.g. 3 or 3,4: ")

      # validate input given by user
      decision_int <- as.integer(unlist(strsplit(decision,",")))
      decision_int_NA <- any(is.na((decision_int)))
      suppressWarnings(decision_int_max <- max(decision_int,na.rm=TRUE))
      suppressWarnings(decision_int_min <- min(decision_int,na.rm=TRUE))
      if (decision_int_NA == TRUE | decision_int_max > domain_code_max | decision_int_min < 0){
        cli_alert_warning("Formatting is invalid or integer out of range. Provide one integer or a comma seperated list of integers.")
        validated = FALSE}
      else {
        validated = TRUE
        # standardize output
        decision_int <- sort(decision_int)
        decision <- paste(decision_int, collapse = ',')
      }

    }

    # ask user for note on categorisation:

    cat("\n \n")
    decision_note <- readline("Categorisation note (or press enter to continue): ")

    while (go_back != "Y" & go_back != "y" & go_back != "N" & go_back != "n") {
      cat("\n \n")
      go_back <- readline(prompt = paste0("Response to be saved is '",decision,"'. Would you like to re-do? (y/n): "))
    }

    first_run = FALSE
  }

  return(list(decision = decision,decision_note = decision_note))

}
