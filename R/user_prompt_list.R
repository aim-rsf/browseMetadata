#' user_prompt_list
#'
#' This function is called within the mapMetadata function. \cr \cr
#' It prompts a response from the user, in the form of a list. \cr \cr
#' It checks if the user has given the an input within the allowed range - if not, it re-sends prompt. \cr \cr
#'
#' @param prompt_text Text to display to the user, to prompt their response.
#' @param list_allowed A list of allowable integer responses.
#' @param empty_allowed A boolean specifying if no response is allowed.
#' @return It returns a list of integers to process, that match the prompt options.
#'

user_prompt_list <- function(prompt_text,list_allowed,empty_allowed) {

  list_to_process_Error <- TRUE
  list_to_process_InRange <- TRUE
  while (list_to_process_Error==TRUE | list_to_process_InRange==FALSE) {
    tryCatch({
      cat("\n \n");
      cli::cli_alert_info(prompt_text);
      cat("\n");
      list_to_process <- scan(file="",what=0);
      list_to_process_InRange_1 = (all(list_to_process %in% list_allowed))
      if (empty_allowed == FALSE){
        list_to_process_InRange_2 = (all(length(list_to_process) != 0))
      } else {list_to_process_InRange_2 = TRUE}
      list_to_process_InRange = all(list_to_process_InRange_1,list_to_process_InRange_2)
      if (list_to_process_InRange == FALSE){cli::cli_alert_danger('One of your inputs is out of range! Reference the allowable list of integers and try again.')};
      list_to_process_Error <- FALSE},
      error=function(e) {list_to_process_Error <- TRUE; print(e); cat("\n"); cli::cli_alert_danger('Your input is in the wrong format. Reference the allowable list of integers and try again.')})
    }
  list_to_process
}

