#' domain_mapping
#'
#' This function will read in the metadata file for a chosen dataset, loop through all the variables, and ask the user to catergorise/label each variable as belonging to one or more domains.\cr \cr
#' The domains will appear in the Plots tab and dataset information will be printed to the R console, for the user's reference in making these categorisations. \cr \cr
#' A log file will be saved with the catergorisations made.
#' To speed up this process, some auto-categorisations will be made by the function for commonly occurring variables;
#' these auto-categorisations should be verified by the user by checking the csv log file. \cr \cr
#' Example inputs are provided within the package data, for the user to run this function in a demo mode.
#' @param json_file The metadata file. This should be downloaded from the metadata catalogue as a json file. See 'data-raw/maternity_indicators_dataset_(mids)_20240105T132210.json' for an example download.
#' @param domain_file The domain list file. This should be a csv file created by the user, with each domain listed on a separate line. See 'data-raw/domain_list_demo.csv' for a template.
#' @return The function will return a log file with the mapping between dataset variables and domains, alongside details about the dataset.
#' @examples
#' # Run in demo mode by providing no inputs: domain_mapping()
#' # Demo mode will use the /data files provided in this package
#' # Respond with your initials when prompted.
#' # Respond 'Demo List ' for the description of domain list.
#' # Respond 'Y' if you want to see the descriptions printed out.
#' # Respond '1,10' to the RANGE OF VARIABLES prompt (or process the full 93 variables if you like!)
#' # Reference the plot tab and categorise each variable into a single ('1') domain
#' # or multiple ('1,2') domains.
#' # Write a note explaining your category choice (optional).
#' @export
#' @importFrom graphics plot.new
#' @importFrom utils read.csv write.csv

domain_mapping <- function(json_file = NULL, domain_file = NULL) {
  # Load data: Check if demo data should be used
  if (is.null(json_file) && is.null(domain_file)) {
    # If both json_file and domain_file are NULL, use demo data
    meta_json <- get("json_metadata")
    domains <- get("domain_list")
    DomainListDesc <- "DemoList"
    cat("\n")
    cli_alert_info("Running domain_mapping in demo mode using package data files")
  } else if (is.null(json_file) || is.null(domain_file)) {
    # If only one of json_file and domain_file is NULL, throw error
    cat("\n")
    cli_alert_danger("Please provide both json_file and domain_file (or neither file, to run in demo mode)")
    stop()
  } else {
    # Read in the json file containing the meta data
    meta_json <- rjson::fromJSON(file = json_file)
    # Read in the domain file containing the meta data
    domains <- read.csv(domain_file, header = FALSE)
    DomainListDesc <- tools::file_path_sans_ext(basename(domain_file))
  }

  # Present domains plots panel for user's reference ----
  graphics::plot.new()
  domains_extend <- rbind(c("*NO MATCH / UNSURE*"), c("*METADATA*"), c("*ALF ID*"), c("*OTHER ID*"), c("*DEMOGRAPHICS*"), domains)
  gridExtra::grid.table(domains_extend[1], cols = "Domain", rows = 0:(nrow(domains_extend) - 1))

  # temp - delete later
  cat("\n You are in the improve-auto branch \n")
  
  # Get user and demo list info for log file ----
  User_Initials <- ""
  while (User_Initials == "") {
    cat("\n \n")
    User_Initials <- readline(prompt = "Enter Initials: ")
  }

  # Print information about Data Asset ----
  cli_h1("Data Asset Name")
  cat(meta_json$dataModel$label, fill = TRUE)
  cli_h1("Data Asset Last Updated")
  cat(meta_json$dataModel$lastUpdated, fill = TRUE)
  cli_h1("Data Asset File Exported By")
  cat(meta_json$exportMetadata$exportedBy, "at", meta_json$exportMetadata$exportedOn, fill = TRUE)
  nDataClasses <- length(meta_json$dataModel$childDataClasses)
  cat("\n")
  cli_alert_info("Found {nDataClasses} Data Class{?es} ({nDataClasses} table{?s}) in this Data Asset")
  cat("\n")

  dataasset_desc <- ""
  while (dataasset_desc != "Y" & dataasset_desc != "N") {
    cat("\n \n")
    dataasset_desc <- readline(prompt = "Would you like to read a description of the Data Asset? (Y/N) ")
  }

  if (dataasset_desc == "Y") {
    cli_h1("Data Asset Description")
    cat(meta_json$dataModel$description, fill = TRUE)
    readline(prompt = "Press [enter] to proceed")
  }

  # Extract each DataClass (Table)
  for (dc in 1:nDataClasses) {
    cat("\n")
    cli_alert_info("Processing Data Class (Table) {dc} of {nDataClasses}")
    cli_h1("Data Class Name")
    cat(meta_json$dataModel$childDataClasses[[dc]]$label, fill = TRUE)
    cli_h1("Data Class Last Updated")
    cat(meta_json$dataModel$childDataClasses[[dc]]$lastUpdated, "\n", fill = TRUE)

    dataclass_desc <- ""
    while (dataclass_desc != "Y" & dataclass_desc != "N") {
      cat("\n \n")
      dataclass_desc <- readline(prompt = "Would you like to read a description of the Data Class (Table)? (Y/N) ")
    }

    if (dataclass_desc == "Y") {
      cli_h1("Data Class Description")
      cat(meta_json$dataModel$childDataClasses[[dc]]$description, fill = TRUE)
      readline(prompt = "Press [enter] to proceed")
    }

    thisDataClass <- meta_json$dataModel$childDataClasses[[dc]]$childDataElements #  probably a better way of dealing with complex json files in R ...
    thisDataClass_df <- data.frame(do.call(rbind, thisDataClass)) # nested list to dataframe
    dataType_df <- data.frame(do.call(rbind, thisDataClass_df$dataType)) # nested list to dataframe

    selectDataClass_df <- data.frame(
      Label = unlist(thisDataClass_df$label),
      Description = unlist(thisDataClass_df$description),
      Type = unlist(dataType_df$label)
    )

    selectDataClass_df <- selectDataClass_df[order(selectDataClass_df$Label), ]

    # Create unique output csv to log the results ----
    timestamp_now <- gsub(" ", "_", Sys.time())
    timestamp_now <- gsub(":", "-", timestamp_now)

    output_fname <- paste0("LOG_", gsub(" ", "", meta_json$dataModel$label), "_", gsub(" ", "", meta_json$dataModel$childDataClasses[[dc]]$label), "_", timestamp_now, ".csv")

    Output <- data.frame(
      Initials = c(""),
      MetaDataVersion = c(""),
      MetaDataLastUpdated = c(""),
      DomainListDesc = c(""),
      DataAsset = c(""),
      DataClass = c(""),
      DataElement = c(""),
      Domain_code = c(""),
      Note = c("")
    )

    # User inputs ----

    cat("\n \n")
    select_vars_n <- readline(prompt = "Enter the range of variables (data elements) to process. Press Enter to process all: ")
    if (select_vars_n == "") {
      start_var <- 1
      end_var <- length(thisDataClass)
    } else {
      seperate_vars <- unlist(strsplit(select_vars_n, ","))
      start_var <- as.numeric(seperate_vars[1])
      end_var <- as.numeric(seperate_vars[2])
    }

    # Loop through each variable, request response from the user to match to a domain ----
    for  (datavar in start_var:end_var) {
      # auto categorise (full string and partial string matches)
      if (selectDataClass_df$Label[datavar] == "NA") {
        Output[nrow(Output) + 1, ] <- NA
        Output$DataElement[datavar]
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- "0"
        Output$Note[datavar] <- "AUTO CATEGORISED"
      } else if (selectDataClass_df$Label[datavar] == "AVAIL_FROM_DT") {
        Output[nrow(Output) + 1, ] <- NA
        Output$DataElement[datavar]
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- "1"
        Output$Note[datavar] <- "AUTO CATEGORISED"
      } else if ((selectDataClass_df$Label[datavar] == "ALF_E") ||
        (selectDataClass_df$Label[datavar] == "RALF") ||
        (selectDataClass_df$Label[datavar] == "ALF_STS_CD") ||
        (selectDataClass_df$Label[datavar] == "ALF_MTCH_PCT") ||
        (grepl("_ALF_E", selectDataClass_df$Label[datavar], ignore.case = TRUE)) # grepl because of MOTHER_ALF_E and CHILD_ALF_E etc.
      || (grepl("_RALF", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("_ALF_STS_CD", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("_ALF_MTCH_PCT", selectDataClass_df$Label[datavar], ignore.case = TRUE))) {
        Output[nrow(Output) + 1, ] <- NA
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- "2"
        Output$Note[datavar] <- "AUTO CATEGORISED"
      } else if (grepl("_ID_", selectDataClass_df$Label[datavar], ignore.case = TRUE)) { # picking up generic IDs
        Output[nrow(Output) + 1, ] <- NA
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- "3"
        Output$Note[datavar] <- "AUTO CATEGORISED"
      } else if ((selectDataClass_df$Label[datavar] == "AGE") # likely to be a better way to code this section with fewer lines
      || (selectDataClass_df$Label[datavar] == "DOB") ||
        (selectDataClass_df$Label[datavar] == "WOB") ||
        (selectDataClass_df$Label[datavar] == "SEX") ||
        (selectDataClass_df$Label[datavar] == "GENDER") ||
        (selectDataClass_df$Label[datavar] == "GNDR") ||
        (grepl("_AGE", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("_DOB", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("_WOB", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("_SEX", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("_GENDER", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("_GNDR", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("AGE_", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("DOB_", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("WOB_", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("SEX_", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("GENDER_", selectDataClass_df$Label[datavar], ignore.case = TRUE)) ||
        (grepl("GNDR_", selectDataClass_df$Label[datavar], ignore.case = TRUE))) {
        Output[nrow(Output) + 1, ] <- NA
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- "4"
        Output$Note[datavar] <- "AUTO CATEGORISED"
      } else {

        # collect user responses
        decision_output <- user_categorisation(selectDataClass_df$Label[datavar],selectDataClass_df$Description[datavar],selectDataClass_df$Type[datavar])
        # input user responses into output
        Output[nrow(Output) + 1, ] <- NA
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- decision_output$decision
        Output$Note[datavar] <- decision_output$decision_note
      }

      # Fill in columns that have all rows identical
      Output$Initials <- User_Initials
      Output$MetaDataVersion <- meta_json$dataModel$documentationVersion
      Output$MetaDataLastUpdated <- meta_json$dataModel$lastUpdated
      Output$DomainListDesc <- DomainListDesc
      Output$DataAsset <- meta_json$dataModel$label
      Output$DataClass <- meta_json$dataModel$childDataClasses[[dc]]$label

      # Save as we go in case session terminates prematurely
      Output[Output == ""] <- NA
      utils::write.csv(Output, output_fname, row.names = FALSE) # save as we go in case session terminates prematurely
    } # end of loop for variable

    # Print the AUTO CATEGORISED responses for this DataClass - request review
    Output_auto <- subset(Output, Note == 'AUTO CATEGORISED')
    cat("\n \n")
    cli_alert_warning("Please check the auto categorised data elements are accurate:")
    cat("\n \n")
    print(Output_auto[, c("DataClass", "DataElement", "Domain_code")])
    cat("\n \n")
    auto_row_str <- readline(prompt = "Enter row numbers you'd like to edit or press enter to accept the auto categorisations: ")

    if (auto_row_str != "") {

      auto_row <- as.integer(unlist(strsplit(auto_row_str,","))) #probably sub-optimal coding

      for  (datavar_auto in auto_row) {

        # collect user responses
        decision_output <- user_categorisation(selectDataClass_df$Label[datavar_auto],selectDataClass_df$Description[datavar_auto],selectDataClass_df$Type[datavar_auto])
        # input user responses into output
        Output$Domain_code[datavar_auto] <- decision_output$decision
        Output$Note[datavar_auto] <- decision_output$decision_note
      }
    }

    # Ask if user wants to review their responses for this DataClass
    review_cats <- ""
    while (review_cats != "Y" & review_cats != "N") {
      cat("\n \n")
      review_cats <- readline(prompt = "Would you like to review your categorisations? (Y/N) ")
    }

    if (review_cats == 'Y') {

      Output_not_auto <- subset(Output, Note != 'AUTO CATEGORISED')
      cat("\n \n")
      print(Output_not_auto[, c("DataClass", "DataElement", "Domain_code")])
      cat("\n \n")
      not_auto_row_str <- readline(prompt = "Enter row numbers you'd like to edit or press enter to accept: ")

      if (not_auto_row_str != "") {

        not_auto_row <- as.integer(unlist(strsplit(not_auto_row_str,","))) #probably sub-optimal coding

        for  (datavar_not_auto in not_auto_row) {

          # collect user responses
          decision_output <- user_categorisation(selectDataClass_df$Label[datavar_not_auto],selectDataClass_df$Description[datavar_not_auto],selectDataClass_df$Type[datavar_not_auto])
          # input user responses into output
          Output$Domain_code[datavar_not_auto] <- decision_output$decision
          Output$Note[datavar_not_auto] <- decision_output$decision_note
        }
      }
    }

    # Save final categorisations for this DataClass
    Output[Output == ""] <- NA
    utils::write.csv(Output, output_fname, row.names = FALSE)
    cat("\n")
    cli_alert_info("Your final categorisations have been saved to {output_fname}")

  } # end of loop for each data class

} # end of function
