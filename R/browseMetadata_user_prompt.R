#' DOCUMENT!

browseMetadata_user_prompt <- function(pre_prompt_text = NULL, prompt_text, any_keys, post_yes_text = NULL) {

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
  } else {
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
      browseMetadata_user_prompt(prompt_text = "Press any key to continue ",any_keys = TRUE)
      cat("\n ")
    }
  }

  response

}
