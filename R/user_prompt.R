#' user_prompt
#'
#' This function is called within the mapMetadata function. \cr \cr
#' It prompts a response from the user. \cr \cr
#'
#' @param prompt_text Text to display to the user, to prompt their response.
#' @param any_keys Boolean to determine if any key responses are allowable.
#' If FALSE, only these are allowed: Y, y, N and n.
#' @return It returns variable text, depending on any_keys.
#'

user_prompt <- function(prompt_text, any_keys) {

  # prompt text is not
  # any_keys, when TRUE it allows any input, when FALSE it only allows y/n/Y/N
  # post_yes_text, when any_keys is FALSE and response is y/Y then print the post text

  # prompt text
  if (any_keys == TRUE){
    response <- ""
    while (response == "") {
      response <- readline(prompt = prompt_text)
    }
  } else if (any_keys == FALSE) {
    response <- ""
    while (!response %in% c("Y", "y", "N", "n")) {
      response <- readline(prompt = prompt_text)
      }
    } else {
    stop("Invalid input given for 'any_keys'. Only TRUE or FALSE are allowed.")
  }

  response

}
