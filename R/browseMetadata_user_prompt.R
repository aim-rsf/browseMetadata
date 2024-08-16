#' DOCUMENT!

browseMetadata_user_prompt <- function(pre_prompt_text = NULL, prompt_text,any_keys) {

  cat("\n \n")

  if (!is.null(pre_prompt_text)){
    cat("\n")
    cat(pre_prompt_text) #won't always be cat
  }

  if (any_keys == TRUE){
    response <- ""
    while (response == "") {
      cat("\n")
      response <- readline(prompt = prompt_text)
    }
  } else {
    response <- ""
    while (!response %in% c("Y", "y", "N", "n")) {
      cat("\n \n")
      response <- readline(prompt = prompt_text)
    }
  }
  response
}
