#' domain_mapping
#'
#' This function will read in the metadata file for a chosen dataset, loop through all the data elements, and ask the user to catergorise/label each data element as belonging to one or more domains.\cr \cr
#' The domains will appear in the Plots tab and dataset information will be printed to the R console, for the user's reference in making these categorisations. \cr \cr
#' A log file will be saved with the catergorisations made.
#' To speed up this process, some auto-categorisations will be made by the function for commonly occurring data elements. \cr \cr
#' Example inputs are provided within the package data, for the user to run this function in a demo mode.
#' @param json_file The metadata file. This should be downloaded from the metadata catalogue as a json file. See 'data-raw/maternity_indicators_dataset_(mids)_20240105T132210.json' for an example download.
#' @param domain_file The domain list file. This should be a csv file created by the user, with each domain listed on a separate line. See 'data-raw/domain_list_demo.csv' for a template.
#' @param look_up_file The look-up table file, with auto-categorisations. By default, the code uses 'data/look-up.rda'. The user can provide their own look-up table in the same format as 'data-raw/look-up.csv'.
#' @param output_dir The path to the directory where the csv output log will be saved. By default, the current working directory is used.
#' @return The function will return a log file with the mapping between data elements and domains, alongside details about the dataset.
#' @examples
#' # Run in demo mode by providing no inputs: domain_mapping()
#' # Demo mode will use the /data files provided in this package
#' # For more guidance, refer to the package README.md file and the R manual files.
#' @export
#' @import ggplot2
#' @importFrom graphics plot.new
#' @importFrom utils read.csv write.csv
#' @importFrom dplyr %>% arrange count group_by

domain_mapping <- function(json_file = NULL, domain_file = NULL, look_up_file = NULL, output_dir = NULL) {

  ## Load data: Check if demo data should be used ----

  if (is.null(json_file) && is.null(domain_file)) {
    # If both json_file and domain_file are NULL, use demo data
    meta_json <- get("json_metadata")
    domains <- get("domain_list")
    DomainListDesc <- "DemoList"
    cat("\n")
    cli_alert_success("Running domain_mapping in demo mode using package data files")
    demo_mode = TRUE
  } else if (is.null(json_file) || is.null(domain_file)) {
    # If only one of json_file and domain_file is NULL, throw error
    cat("\n")
    cli_alert_danger("Please provide both json_file and domain_file (or neither file, to run in demo mode)")
    stop()
  } else {
    demo_mode = FALSE
    # Read in the json file containing the meta data
    meta_json <- rjson::fromJSON(file = json_file)
    # Read in the domain file containing the meta data
    domains <- read.csv(domain_file, header = FALSE)
    DomainListDesc <- tools::file_path_sans_ext(basename(domain_file))
  }

  # Check if user has provided a look-up table
  if (is.null(look_up_file)) {
    cli_alert_success("Using the default look-up table in data/look-up.rda")
    lookup <- get("look_up")
    }
  else {
    lookup <- read.csv(look_up_file)
    cli_alert_success("Using look up file inputted by user")
    print(lookup)
    }

  ## Present domains plots panel for user's reference ----
  colnames(domains)[1] = "Domain Name"
  graphics::plot.new()
  domains_extend <- rbind(c("*NO MATCH / UNSURE*"), c("*METADATA*"), c("*ID*"), c("*DEMOGRAPHICS*"), domains)
  Code <- data.frame(Code = 0:(nrow(domains_extend) - 1))
  Domain_table <- tableGrob(cbind(Code,domains_extend),rows = NULL,theme = ttheme_default())
  grid.arrange(Domain_table,nrow=1,ncol=1)

  ## Get user and demo list info for log file ----
  User_Initials <- ""
  cat("\n \n")
  while (User_Initials == "") {
    User_Initials <- readline("Enter your initials: ")
  }

  ## Print information about Dataset ----
  cli_h1("Dataset Name")
  cat(meta_json$dataModel$label, fill = TRUE)
  cli_h1("Dataset Last Updated")
  cat(meta_json$dataModel$lastUpdated, fill = TRUE)
  cli_h1("Dataset File Exported By")
  cat(meta_json$exportMetadata$exportedBy, "at", meta_json$exportMetadata$exportedOn, fill = TRUE)

  Dataset_desc <- ""
  while (Dataset_desc != "Y" & Dataset_desc != "y" & Dataset_desc != "N" & Dataset_desc != "n") {
    cat("\n \n")
    Dataset_desc <- readline(prompt = "Would you like to read a description of the dataset? (y/n): ")
  }

  if (Dataset_desc == 'Y' | Dataset_desc == 'y') {
    cli_h1("Dataset Description")
    cat(meta_json$dataModel$description, fill = TRUE)
    readline(prompt = "Press any key to proceed")
  }

  ## Ask user which tables to process  ----

  nTables <- length(meta_json$dataModel$childDataClasses)
  cat("\n")
  cli_alert_info("Found {nTables} Table{?s} in this Dataset")
  for (dc in 1:nTables) {
    cat("\n")
    cat(dc,meta_json$dataModel$childDataClasses[[dc]]$label, fill = TRUE)
  }

  nTables_Process <- numeric(0)
  nTables_Process_Error <- TRUE
  nTables_Process_OutOfRange <- FALSE
  while (length(nTables_Process) == 0 | nTables_Process_Error==TRUE | nTables_Process_OutOfRange == TRUE) {
    if (nTables_Process_OutOfRange == TRUE) {
      cli_alert_danger('That table number is not within the range displayed, please try again.')}
    tryCatch({
      cat("\n \n");
      cli_alert_info("Enter each table number you want to process in this session (one number on each line):");
      cat("\n");
      nTables_Process <- scan(file="",what=0);
      nTables_Process_Error <- FALSE;
      nTables_Process_OutOfRange = any(nTables_Process > nTables)},
      error=function(e) {nTables_Process_Error <- TRUE; print(e); cat("\n"); cli_alert_danger('Your input is in the wrong format, reference the table numbers and try again')})
  }

  # Extract each Table  ----
  for (dc in unique(nTables_Process)) {
    cat("\n")
    cli_alert_info("Processing Table {dc} of {nTables}")
    cli_h1("Table Name")
    cat(meta_json$dataModel$childDataClasses[[dc]]$label, fill = TRUE)
    cli_h1("Table Last Updated")
    cat(meta_json$dataModel$childDataClasses[[dc]]$lastUpdated, "\n", fill = TRUE)

    table_desc <- ""
    while (table_desc != "Y" & table_desc != "y" & table_desc != "N" & table_desc != "n") {
      cat("\n \n")
      table_desc <- readline(prompt = "Would you like to read a description of the table? (y/n): ")
    }

    if (table_desc == 'Y' | table_desc == 'y') {
      cli_h1("Table Description")
      cat(meta_json$dataModel$childDataClasses[[dc]]$description, fill = TRUE)
      readline(prompt = "Press any key to proceed")
    }

    thisTable <- meta_json$dataModel$childDataClasses[[dc]]$childDataElements #  probably a better way of dealing with complex json files in R ...
    thisTable_df <- data.frame(do.call(rbind, thisTable)) # nested list to dataframe
    dataType_df <- data.frame(do.call(rbind, thisTable_df$dataType)) # nested list to dataframe

    selectTable_df <- data.frame(
      Label = unlist(thisTable_df$label),
      Description = unlist(thisTable_df$description),
      Type = unlist(dataType_df$label)
    )

    selectTable_df <- selectTable_df[order(selectTable_df$Label), ]

    # Create unique output csv to log the results ----
    timestamp_now <- gsub(" ", "_", Sys.time())
    timestamp_now <- gsub(":", "-", timestamp_now)

    output_fname_csv <- paste0("LOG_", gsub(" ", "", meta_json$dataModel$label), "_", gsub(" ", "", meta_json$dataModel$childDataClasses[[dc]]$label), "_", timestamp_now, ".csv")
    output_fname_png <- paste0("PLOT_", gsub(" ", "", meta_json$dataModel$label), "_", gsub(" ", "", meta_json$dataModel$childDataClasses[[dc]]$label), "_", timestamp_now, ".png")

    row_Output <- data.frame(
      Initials = character(0),
      MetaDataVersion = character(0),
      MetaDataLastUpdated = character(0),
      DomainListDesc = character(0),
      Dataset = character(0),
      Table = character(0),
      DataElement_N = character(0),
      DataElement = character(0),
      Domain_code = character(0),
      Note = character(0)
    )

    # Loop through each data element, request response from the user to match to a domain ----

    # if it's the demo run, only loop through a max of 20 data elements
    if (demo_mode == TRUE) {
      start_var = 1
      end_var = min(20,nrow(selectTable_df))
    } else {
      cli_h1(paste('There are',as.character(nrow(selectTable_df)),'data elements (variables) in this table.'))
      cat("\n")
      start_var <- readline(prompt = "Start variable (write 1 to process all): ")
      cat("\n")
      end_var <- readline(prompt = paste("End variable (write", nrow(selectTable_df), "to process all): "))
      }

    Output <- row_Output
    for (datavar in start_var:end_var) {
      cat("\n \n")
      cli_alert_info(paste(length(datavar:end_var),'left to process in this session'))
      cli_alert_success("Processing data element {datavar} of {nrow(selectTable_df)}")
      datavar_index <- which(lookup$DataElement == selectTable_df$Label[datavar]) #we should code this to ignore the case
      lookup_subset <- lookup[datavar_index,]
      if (nrow(lookup_subset) == 1) {
        # auto categorisations
        this_Output <- row_Output
        this_Output[nrow(this_Output) + 1 , ] <- NA
        this_Output$DataElement[1] <- selectTable_df$Label[datavar]
        this_Output$DataElement_N[1] <- paste(as.character(datavar),'of',as.character(nrow(selectTable_df)))
        this_Output$Domain_code[1] <- lookup_subset$DomainCode
        this_Output$Note[1] <- "AUTO CATEGORISED"
        Output <- rbind(Output,this_Output)
        } else {
        # collect user responses
        decision_output <- user_categorisation(selectTable_df$Label[datavar],selectTable_df$Description[datavar],selectTable_df$Type[datavar])
        # input user responses into output
        this_Output <- row_Output
        this_Output[nrow(this_Output) + 1 , ] <- NA
        this_Output$DataElement[1] <- selectTable_df$Label[datavar]
        this_Output$DataElement_N[1] <- paste(as.character(datavar),'of',as.character(nrow(selectTable_df)))
        this_Output$Domain_code[1] <- decision_output$decision
        this_Output$Note[1] <- decision_output$decision_note
        Output <- rbind(Output,this_Output)
        }
    } # end of loop for DataElement

    ## Print the AUTO CATEGORISED responses for this Table and request review  ----
    Output_auto <- subset(Output, Note == 'AUTO CATEGORISED')
    cat("\n \n")
    cli_alert_warning("Please check the auto categorised data elements are accurate for table {meta_json$dataModel$childDataClasses[[dc]]$label}:")
    cat("\n \n")
    print(Output_auto[, c("DataElement", "Domain_code","Note")])

    # extract the rows to edit
    auto_row_Error <- TRUE
    auto_row_InRange <- TRUE
    while (auto_row_Error==TRUE | auto_row_InRange == FALSE) {
      if (auto_row_InRange == FALSE) {
        cli_alert_danger('The row numbers you provided are not in range. Reference the auto categorised row numbers on the screen and try again')}
      tryCatch({
        cat("\n \n");
        cli_alert_info("Press enter to accept the auto categorisations for table {meta_json$dataModel$childDataClasses[[dc]]$label} or enter each row you'd like to edit:");
        cat("\n");
        auto_row <- scan(file="",what=0);
        auto_row_Error <- FALSE;
        auto_row_InRange <- all(auto_row %in% which(Output$Note == 'AUTO CATEGORISED'))},
        error=function(e) {auto_row_Error <- TRUE; print(e); cat("\n"); cli_alert_danger('Your input is in the wrong format, try again')})
    }

    if (length(auto_row) != 0) {

      for  (datavar_auto in unique(auto_row)) {

        # collect user responses
        decision_output <- user_categorisation(selectTable_df$Label[datavar_auto],selectTable_df$Description[datavar_auto],selectTable_df$Type[datavar_auto])
        # input user responses into output
        Output$Domain_code[datavar_auto] <- decision_output$decision
        Output$Note[datavar_auto] <- decision_output$decision_note
      }
    }

    ## Ask if user wants to review their responses for this Table ----
    review_cats <- ""
    while (review_cats != "Y" & review_cats != "y" & review_cats != "N" & review_cats != "n") {
      cat("\n \n")
      review_cats <- readline(prompt = "Would you like to review your categorisations? (y/n): ")
    }

    if (review_cats == 'Y' | review_cats == 'y') {
      Output_not_auto <- subset(Output, Note != 'AUTO CATEGORISED')
      cat("\n \n")
      print(Output_not_auto[, c("DataElement", "Domain_code","Note")])
      cat("\n \n")

      # extract the rows to edit
      not_auto_row_Error <- TRUE
      not_auto_row_InRange <- TRUE
      while (not_auto_row_Error==TRUE | not_auto_row_InRange == FALSE) {
        if (not_auto_row_InRange == FALSE) {
          cli_alert_danger('The row numbers you provided are not in range. Reference the row numbers on the screen and try again')}
        tryCatch({
          cat("\n \n");
          cli_alert_info("Press enter to accept your categorisations for table {meta_json$dataModel$childDataClasses[[dc]]$label} or enter each row you'd like to edit:");
          cat("\n");
          not_auto_row <- scan(file="",what=0);
          not_auto_row_Error <- FALSE;
          not_auto_row_InRange <- all(not_auto_row %in% which(Output$Note != 'AUTO CATEGORISED'))},
          error=function(e) {not_auto_row_Error <- TRUE; print(e); cat("\n"); cli_alert_danger('Your input is in the wrong format, reference the row numbers and try again')})
      }

      if (length(not_auto_row) != 0) {

        for  (datavar_not_auto in unique(not_auto_row)) {

          # collect user responses
          decision_output <- user_categorisation(selectTable_df$Label[datavar_not_auto],selectTable_df$Description[datavar_not_auto],selectTable_df$Type[datavar_not_auto])
          # input user responses into output
          Output$Domain_code[datavar_not_auto] <- decision_output$decision
          Output$Note[datavar_not_auto] <- decision_output$decision_note
        }
      }
    }

    ## Fill in columns that have all rows identical ----
    Output$Initials <- User_Initials
    Output$MetaDataVersion <- meta_json$dataModel$documentationVersion
    Output$MetaDataLastUpdated <- meta_json$dataModel$lastUpdated
    Output$DomainListDesc <- DomainListDesc
    Output$Dataset <- meta_json$dataModel$label
    Output$Table <- meta_json$dataModel$childDataClasses[[dc]]$label

    ## Save final categorisations for this Table  ----
    if (is.null(output_dir)) {
      output_dir = getwd() }

    utils::write.csv(Output, paste(output_dir,output_fname_csv,sep='/'), row.names = FALSE)
    cat("\n")
    cli_alert_success("Your final categorisations have been saved to {output_fname_csv}")

    ## Create and save a summary plot
    counts <- Output %>% group_by(Domain_code) %>% count() %>% arrange(n)

    Domain_plot <- counts %>%
      ggplot(aes(x=reorder(Domain_code, -n), y=n)) +
      geom_col() +
      ggtitle(paste("Data Elements in", meta_json$dataModel$childDataClasses[[dc]]$label, "grouped by Domain code")) +
      theme_gray(base_size = 18) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
      xlab('Domain Code') +
      ylab('Count') +
      scale_y_continuous(breaks=seq(0,max(counts$n),1))

    full_plot <- grid.arrange(Domain_plot, Domain_table,nrow=1,ncol=2)
    ggsave(plot = full_plot,paste(output_dir,output_fname_png,sep='/'),width = 14, height = 8, units = "in")
    cat("\n")
    cli_alert_success("A summary plot has been saved to {output_fname_png}")


  } # end of loop for each table

} # end of function
