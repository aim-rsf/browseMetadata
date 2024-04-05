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

  # print text to R console
  cat(paste(
    "\nDATA ELEMENT -----> ", data_element,
    "\n\nDESCRIPTION -----> ", data_desc,
    "\n\nDATA TYPE -----> ", data_type, "\n"
  ))

    # ask user for categorisation
    decision <- numeric(0)
    cat("\n \n")
    cli_alert_info("Categorise this data element (one or multiple domains):")
    cat("\n")
    while (length(decision) == 0) {
      decision <- scan(file="",what=0)
    }

    # ask user for note on categorisation
    decision_note <- character(0)
    cat("\n \n")
    cli_alert_info("Write a note to go with this decision (or 'None'):")
    cat("\n")
    while (length(decision_note) == 0) {
      decision_note <- scan(file="",what="",n=1)
      }

return(list(decision = decision,decision_note = decision_note))

}
