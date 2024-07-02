#' user_categorisation
#'
#' This function is used within the domain_mapping function. \cr \cr
#' It displays data properties to the user and requests a categorisation into a domain. \cr \cr
#' An optional note can be included with the categorisation.
#'
#' @param data_element Name of the variable
#' @param data_desc Description of the variable
#' @param data_type Data type of the variable
#' @return It returns a list containing the decision and decision note
#' @export

user_categorisation <- function(data_element,data_desc,data_type) {

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

    # ask user for categorisation

    decision <- ""
    cat("\n \n")
    while (decision == "") {
      decision <- readline("Categorise data element into domain(s). E.g. 3 or 3,4: ")
    }

    # ask user for note on categorisation
    cat("\n \n")
    decision_note <- readline("Categorisation note (or press enter to continue): ")

    while (go_back != "Y" & go_back != "y" & go_back != "N" & go_back != "n") {
      cat("\n \n")
      go_back <- readline(prompt = "Re-do last categorisation? (y/n): ")
    }

    first_run = FALSE
  }

  return(list(decision = decision,decision_note = decision_note))

}
