#' DOCUMENT!

browseMetadata_load_data <- function(json_file, domain_file,look_up_file, output_dir){

  # Collect meta_json and domains
  if (is.null(json_file) && is.null(domain_file)) { # if both json_file and domain_file are NULL, use demo data
    meta_json <- get("json_metadata")
    domains <- get("domain_list")
    DomainListDesc <- "DemoList"
    cat("\n")
    cli_alert_info("Running domain_mapping in demo mode using package data files")
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
    lookup <- get("look_up")
  }
  else {
    lookup <- read.csv(look_up_file)
    cli_alert_info("Using look up file inputted by user")
    print(lookup)
  }

  list(meta_json = meta_json,domains = domains,DomainListDesc = DomainListDesc, demo_mode = demo_mode,lookup = lookup)
}
