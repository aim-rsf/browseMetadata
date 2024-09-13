#' load_data
#'
#' This function is called within the mapMetadata function. \cr \cr
#' It collects the inputs needed for the mapMetadata function (defaults or user inputs)
#' If some inputs are NULL, it loads the default inputs. If defaults not available, it prints error for the user.
#' If inputs are not NULL, it loads the user-specified inputs.
#' @param json_file As defined in mapMetadata
#' @param domain_file As defined in mapMetadata
#' @param look_up_file As defined in mapMetadata
#' @return A list of 5: all inputs needed for the mapMetadata function to run.
#' @importFrom CHECK LATER
#'
#'
load_data <- function(json_file, domain_file,look_up_file){

  # Collect meta_json and domains
  if (is.null(json_file) && is.null(domain_file)) { # if both json_file and domain_file are NULL, use demo data
    meta_json <- get("json_metadata")
    domains <- get("domain_list")
    DomainListDesc <- "DemoList"
    cat("\n")
    cli_alert_info("Running mapMetadata in demo mode using package data files")
    cat("\n ")
    demo_mode = TRUE
  } else if (is.null(json_file) || is.null(domain_file)) { # if only one of json_file and domain_file is NULL, throw error
    cat("\n")
    cli_alert_danger("Please provide both json_file and domain_file (or neither file, to run in demo mode)")
    stop()
  } else { # read in user specified files
    demo_mode = FALSE
    meta_json <- rjson::fromJSON(file = json_file) # read in the json file containing the meta data
    domains <- read.csv(domain_file, header = FALSE) # read in the domain file containing the list of research domains
    DomainListDesc <- tools::file_path_sans_ext(basename(domain_file))
  }

  # Collect look up table
  if (is.null(look_up_file)) {
    cli_alert_info("Using the default look-up table in data/look-up.rda")
    cat("\n ")
    lookup <- get("look_up")
  }
  else {
    lookup <- read.csv(look_up_file)
    cli_alert_info("Using look up file inputted by user")
    cat("\n ")
    print(lookup)
  }

  list(meta_json = meta_json,domains = domains,DomainListDesc = DomainListDesc, demo_mode = demo_mode,lookup = lookup)
}
