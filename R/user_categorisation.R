#' user_categorisation
#'
#' This function is used within the domain_mapping function \cr \cr
#' It displays data properties to the user and requests a categorisation into a domain \cr \cr
#' An optional note can be included with the categorisation
#'
#' @param data_element Name of the variable
#' @param data_desc Description of the variable
#' @param data_type Data type of the variable
#' @return A list containing the decision and decision note
#' @export

user_categorisation <- function(data_element,data_desc,data_type) {

  # print text to R console
  cat(paste(
    "\nDATA ELEMENT -----> ", data_element,
    "\n\nDESCRIPTION -----> ", data_desc,
    "\n\nDATA TYPE -----> ", data_type, "\n"
  ))

  state <- "redo"
  while (state == "redo") {

    # ask user for categorisation
    decision <- ""
    while (decision == "") {
      cat("\n \n")
      decision <- readline(prompt = "CATEGORISE THIS VARIABLE (input a comma separated list of domain numbers): ")
      }

    # ask user for note on categorisation
    decision_note <- ""
    while (decision_note == "") {
      cat("\n \n")
      decision_note <- readline(prompt = "NOTES (write 'N' if no notes): ")
    }

    # check if user wants to continue or redo
    cat("\n \n")
    state <- readline(prompt = "Press enter to continue or write 'redo' to correct previous answer: ")

  }

return(list(decision = decision,decision_note = decision_note))

}
