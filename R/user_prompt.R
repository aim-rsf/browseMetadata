#' user_prompt
#'
#' This function is called within the browseMetadata function. \cr \cr
#' It prompts a response from the user. \cr \cr
#'
#' @param pre_prompt_text Optional text to display to the user, prior to prompt.
#' This should be a data frame:
#' data.frame(Heading = logical(0), Text = character(0))
#' Each row of the dataframe specifies Heading TRUE/FALSE and text to display.
#' @param prompt_text Text to display to the user, to prompt their response.
#' @param any_keys Boolean to determine if any key responses are allowable.
#' If FALSE, only these are allowed: Y, y, N and n.
#' @param post_yes_text Optional text to post after receiving a 'Y' or 'y'
#' response from user. Same dataframe format as pre_prompt_text.
#' @return It returns variable text, depending on any_keys.
#' @importFrom CHECK LATER

user_prompt <- function(pre_prompt_text = NULL, prompt_text, any_keys, post_yes_text = NULL) {

  # pre prompt text is optional
  # prompt text is not
  # any_keys, when TRUE it allows any input, when FALSE it only allows y/n/Y/N
  # post_yes_text, when any_keys is FALSE and response is y/Y then print the post text

  # pre prompt text
  if (!is.null(pre_prompt_text)){
    for (line in 1:nrow(pre_prompt_text)){
      if (pre_prompt_text$Heading[line] == TRUE){
        cli_h1(pre_prompt_text$Text[line])
        }else{
          cat(pre_prompt_text$Text[line])
        }
    }
    cat("\n ")
    }

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
    # post yes text
    if (response %in% list('Y','y') & !is.null(post_yes_text)) {
      for (line in 1:nrow(post_yes_text)){
        if (post_yes_text$Heading[line] == TRUE){
          cli_h1(post_yes_text$Text[line])
        }else{
          cat(post_yes_text$Text[line])
        }
      }
      cat("\nPress any key to continue ")
      readline()
    }
  } else {
    stop("Invalid input given for 'any_keys'. Only TRUE or FALSE are allowed.")
  }

  response

}
