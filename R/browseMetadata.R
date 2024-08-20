#' browseMetadata
#'
#' This function will read in the metadata file for a chosen dataset, loop through all the data elements, and ask the user to catergorise/label each data element as belonging to one or more domains.\cr \cr
#' The domains will appear in the Plots tab and dataset information will be printed to the R console, for the user's reference in making these categorisations. \cr \cr
#' These categorisations will be saved to a csv file, alongside a log file which summarises the session details.
#' To speed up this process, some auto-categorisations will be made by the function for commonly occurring data elements and categorisations for the same data element can be copied from one table to another. \cr \cr
#' Example inputs are provided within the package data, for the user to run this function in a demo mode.
#' @param json_file The metadata file. This should be downloaded from the metadata catalogue as a json file. See 'data-raw/maternity_indicators_dataset_(mids)_20240105T132210.json' for an example download.
#' @param domain_file The domain list file. This should be a csv file created by the user, with each domain listed on a separate line. See 'data-raw/domain_list_demo.csv' for a template.
#' @param look_up_file The look-up table file, with auto-categorisations. By default, the code uses 'data/look-up.rda'. The user can provide their own look-up table in the same format as 'data-raw/look-up.csv'.
#' @param output_dir The path to the directory where the two csv output files will be saved. By default, the current working directory is used.
#' @param table_copy Turn on copying between tables (TRUE or FALSE, default TRUE). If TRUE, categorisations you made for all other tables in this dataset will be copied over (if 'OUTPUT_' files are found in output_dir).
#' @return The function will return two csv files: 'OUTPUT_' which contains the mappings and 'LOG_' which contains details about the dataset and session.
#' @examples
#' # Run in demo mode by providing no inputs: browseMetadata()
#' # Demo mode will use the /data files provided in this package
#' # For more guidance, refer to the package README.md file and the R manual files.
#' @export
#' @import ggplot2
#' @importFrom graphics plot.new
#' @importFrom utils read.csv write.csv
#' @importFrom dplyr %>% arrange count group_by distinct
#' @importFrom tidyverse add_row

browseMetadata <- function(json_file = NULL, domain_file = NULL, look_up_file = NULL, output_dir = NULL, table_copy = TRUE) {

  timestamp_now <- format(Sys.time(),"%Y-%m-%d-%H-%M-%S")

  # Set output_dir to current wd if user has not provided it
  if (is.null(output_dir)) {
    output_dir = getwd() }

  # Collect inputs needed for this function (defaults or user inputs)
  data <- browseMetadata_load_data(json_file, domain_file,look_up_file)

  # Present domains as a plot for the user's reference (and save as df for later use)
  df_plots <- browseMetadata_ref_plot(data$domains)

  # Get user initials for the log file
  User_Initials <- browseMetadata_user_prompt(prompt_text = "Enter your initials: ",any_keys = TRUE)

  # Print info about dataset and ask if user wants to read desc of dataset ----
  pre_prompt_text <- data.frame(Heading = logical(0),Text = character(0))
  pre_prompt_text <- pre_prompt_text %>% add_row(Heading = TRUE, Text = 'Dataset Name')
  pre_prompt_text <- pre_prompt_text %>% add_row(Heading = FALSE, Text = paste(data$meta_json$dataModel$label))
  pre_prompt_text <- pre_prompt_text %>% add_row(Heading = TRUE, Text = 'Dataset File Exported By')
  pre_prompt_text <- pre_prompt_text %>% add_row(Heading = FALSE, Text = paste(data$meta_json$exportMetadata$exportedBy, "at", data$meta_json$exportMetadata$exportedOn))
  prompt_text <- "Would you like to read a description of the dataset? (y/n): "
  post_yes_text <- data.frame(Heading = logical(0),Text = character(0))
  post_yes_text <- post_yes_text %>% add_row(Heading = TRUE, Text = 'Dataset Description')
  post_yes_text <- post_yes_text %>% add_row(Heading = FALSE, Text = paste(data$meta_json$dataModel$description))

  browseMetadata_user_prompt(pre_prompt_text = pre_prompt_text, prompt_text = prompt_text, any_keys = FALSE, post_yes_text = post_yes_text)

  # Ask user which tables to process  ----
  nTables <- length(data$meta_json$dataModel$childDataClasses)
  table_df <- data.frame(Table_Name = character(0),Table_Number = integer(0))
  for (dc in 1:nTables) {
    table_df <- table_df %>% add_row(Table_Number = dc, Table_Name = data$meta_json$dataModel$childDataClasses[[dc]]$label)
  }

  nTables_Process <- browseMetadata_user_prompt_from_list(pre_prompt_df = table_df,
                                                          pre_prompt_df_rows = FALSE,
                                                          prompt_text = paste('Found',nTables,'table(s) in this Dataset. Enter table numbers you want to process (one table number on each line):'),
                                                          list_allowed = seq(from = 1, to = nTables, by = 1))
  # Extract each Table  ----
  for (dc in unique(nTables_Process)) {
    cat("\n")
    cli_alert_info("Processing Table {dc} of {nTables}")
    cli_h1("Table Name")
    thisTable_name <- data$meta_json$dataModel$childDataClasses[[dc]]$label
    cat(thisTable_name, fill = TRUE)
    cli_h1("Table Last Updated")
    cat(data$meta_json$dataModel$childDataClasses[[dc]]$lastUpdated, "\n", fill = TRUE)

    # Check if previous table output(s) exists in this output_dir (for table copying) ----
    if (table_copy == TRUE){
      dataset_search = paste0("^OUTPUT_",gsub(" ", "", data$meta_json$dataModel$label),'*')
      csv_list <- data.frame(file = list.files(output_dir,pattern = dataset_search))
      if (nrow(csv_list) != 0){
        df_list <- lapply(paste0(output_dir,'/',csv_list$file), read.csv)
        df_combined <- do.call("rbind", df_list) #combine all df
        df_combined$timestamp2 <- as.POSIXct(df_combined$timestamp, format="%Y-%m-%d-%H-%M-%S") #create new date column
        df_combined <- df_combined[order(df_combined$timestamp2),] #order by earliest datetime
        df_combined <- df_combined %>% distinct(DataElement, .keep_all = TRUE) #remove duplicates, keep earliest categorisation
        df_combined <- df_combined[-(which(df_combined$Note %in% "AUTO CATEGORISED")),] #remove auto categorised
        df_combined_exist <- TRUE
        cat("\n")
        cli_alert_info(paste0("Copying from previous session(s): "))
        cat("\n")
        print(csv_list$file)
      } else {df_combined_exist <- FALSE}
    } else {df_combined_exist <- FALSE}

    # Ask if user wants to read desc of table ----
    prompt_text = "Would you like to read a description of the table? (y/n): "
    post_yes_text <- data.frame(Heading = logical(0),Text = character(0))
    post_yes_text <- post_yes_text %>% add_row(Heading = TRUE, Text = 'Table Description')
    post_yes_text <- post_yes_text %>% add_row(Heading = FALSE, Text = paste(data$meta_json$dataModel$childDataClasses[[dc]]$description))

    browseMetadata_user_prompt(prompt_text = prompt_text, any_keys = FALSE, post_yes_text = post_yes_text)

    table_note <- readline("Optional free text note about this table (or press enter to continue): ")

    # Extract data for this table into a data frame ----
    thisTable <- data$meta_json$dataModel$childDataClasses[[dc]]$childDataElements #  probably a better way of dealing with complex json files in R ...
    thisTable_df <- data.frame(do.call(rbind, thisTable)) # nested list to dataframe
    dataType_df <- data.frame(do.call(rbind, thisTable_df$dataType)) # nested list to dataframe

    selectTable_df <- data.frame(
      Label = unlist(thisTable_df$label),
      Description = unlist(thisTable_df$description),
      Type = unlist(dataType_df$label)
    )

    selectTable_df <- selectTable_df[order(selectTable_df$Label), ]

    # Loop through each data element, request response from the user to match to a domain ----

    log_Output <- get("log_Output")
    Output <- get("Output")

    # if it's the demo run, only loop through a max of 20 data elements ----
    if (data$demo_mode == TRUE) {
      start_var = 1
      end_var = min(20,nrow(selectTable_df))
    } else {
      cli_h1(paste('There are',as.character(nrow(selectTable_df)),'data elements (variables) in this table.'))
      cat("\n")
      start_var <- readline(prompt = "Start variable (write 1 to process all): ")
      cat("\n")
      end_var <- readline(prompt = paste("End variable (write", nrow(selectTable_df), "to process all): "))
      }

    for (datavar in start_var:end_var) {
      cat("\n \n")
      cli_alert_info(paste(length(datavar:end_var),'left to process in this session'))
      cli_alert_info("Processing data element {datavar} of {nrow(selectTable_df)}")
      this_DataElement <- selectTable_df$Label[datavar]
      this_DataElement_N <- paste(as.character(datavar),'of',as.character(nrow(selectTable_df)))
      datavar_index <- which(data$lookup$DataElement == selectTable_df$Label[datavar]) #we should code this to ignore the case
      lookup_subset <- data$lookup[datavar_index,]
      # search if this data element matches with any data elements processed in previous table
      if (df_combined_exist == TRUE) {
        datavar_index <- which(df_combined$DataElement == selectTable_df$Label[datavar])
        df_combined_subset <- df_combined[datavar_index,]
        } else {df_combined_subset <- data.frame()}
      # decide how to process the data element out of 3 options
      if (nrow(lookup_subset) == 1) { # 1 - auto categorisation
        Output <- Output %>% add_row(timestamp = timestamp_now, Table = thisTable_name, DataElement = this_DataElement, DataElement_N = this_DataElement_N,
                                     Domain_code = as.character(lookup_subset$DomainCode), Note = 'AUTO CATEGORISED')
        #Output <- rbind(Output,this_Output)
        } else if (df_combined_exist == TRUE & nrow(df_combined_subset) == 1){ # 2 - copy from previous table
          Output <- Output %>% add_row(timestamp = timestamp_now, Table = thisTable_name, DataElement = this_DataElement, DataElement_N = this_DataElement_N,
                                       Domain_code = as.character(df_combined_subset$Domain_code), Note = paste0("COPIED FROM: ",df_combined_subset$Table))
        } else { # 3 - collect user responses
          decision_output <- browseMetadata_user_categorisation(selectTable_df$Label[datavar],selectTable_df$Description[datavar],selectTable_df$Type[datavar],max(df_plots$Code$Code))
          Output <- Output %>% add_row(timestamp = timestamp_now, Table = thisTable_name, DataElement = this_DataElement, DataElement_N = this_DataElement_N,
                                       Domain_code = decision_output$decision, Note = decision_output$decision_note)
          }
      } # end of loop for DataElement


    # Review auto categorized data elements ----
    Output_auto <- subset(Output, Note == 'AUTO CATEGORISED')
    Output_auto <- Output_auto[, c("DataElement", "Domain_code","Note")]

    auto_row <- browseMetadata_user_prompt_from_list(pre_prompt_df = Output_auto,
                                                     pre_prompt_df_rows = TRUE,
                                                     prompt_text = 'These are the auto categorised data elements. Enter row numbers for the ones you want to edit: ',
                                                     list_allowed = which(Output$Note == 'AUTO CATEGORISED'))

    if (length(auto_row) != 0) {
      for  (datavar_auto in unique(auto_row)) {
        # collect user responses
        decision_output <- browseMetadata_user_categorisation(selectTable_df$Label[datavar_auto],selectTable_df$Description[datavar_auto],selectTable_df$Type[datavar_auto],max(df_plots$Code$Code))
        # input user responses into output
        Output$Domain_code[datavar_auto] <- decision_output$decision
        Output$Note[datavar_auto] <- decision_output$decision_note
      }
    }

    # Review user categorized data elements (optional) ----
    review_cats <- browseMetadata_user_prompt(prompt_text = "Would you like to review your categorisations? (y/n): ",any_keys = FALSE)
    if (review_cats == 'Y' | review_cats == 'y') {
      Output_not_auto <- subset(Output, Note != 'AUTO CATEGORISED')
      Output_not_auto['Note (first 12 chars)'] <- substring(Output_not_auto$Note,1,11)
      Output_not_auto <- Output_not_auto[, c("DataElement", "Domain_code","Note (first 12 chars)")]

      not_auto_row <- browseMetadata_user_prompt_from_list(pre_prompt_df = Output_not_auto,
                                                       pre_prompt_df_rows = TRUE,
                                                       prompt_text = 'These are the data elements you categorised. Enter row numbers for the ones you want to edit: ',
                                                       list_allowed = which(Output$Note != 'AUTO CATEGORISED'))
      if (length(not_auto_row) != 0) {

        for  (datavar_not_auto in unique(not_auto_row)) {

          # collect user responses
          decision_output <- browseMetadata_user_categorisation(selectTable_df$Label[datavar_not_auto],selectTable_df$Description[datavar_not_auto],selectTable_df$Type[datavar_not_auto],max(df_plots$Code$Code))
          # input user responses into output
          Output$Domain_code[datavar_not_auto] <- decision_output$decision
          Output$Note[datavar_not_auto] <- decision_output$decision_note
        }
      }
    }

    # Fill in log output ----
    log_Output <- log_Output %>% add_row(
      timestamp = timestamp_now,
      browseMetadata = packageVersion("browseMetadata"),
      Initials = User_Initials,
      MetaDataVersion = data$meta_json$dataModel$documentationVersion,
      MetaDataLastUpdated = data$meta_json$dataModel$lastUpdated,
      DomainListDesc = DomainListDesc,
      Dataset = data$meta_json$dataModel$label,
      Table = data$meta_json$dataModel$childDataClasses[[dc]]$label,
      Table_note = table_note)

    # Create output file names ----
    output_fname_csv <- paste0("OUTPUT_", gsub(" ", "", data$meta_json$dataModel$label), "_", gsub(" ", "", data$meta_json$dataModel$childDataClasses[[dc]]$label), "_", timestamp_now, ".csv")
    output_fname_log_csv <- paste0("LOG_", gsub(" ", "", data$meta_json$dataModel$label), "_", gsub(" ", "", data$meta_json$dataModel$childDataClasses[[dc]]$label), "_", timestamp_now, ".csv")
    output_fname_png <- paste0("PLOT_", gsub(" ", "", data$meta_json$dataModel$label), "_", gsub(" ", "", data$meta_json$dataModel$childDataClasses[[dc]]$label), "_", timestamp_now, ".png")

    # Save final categorisations for this Table  ----
    utils::write.csv(Output, paste(output_dir,output_fname_csv,sep='/'), row.names = FALSE)
    utils::write.csv(log_Output, paste(output_dir,output_fname_log_csv,sep='/'), row.names = FALSE)
    cat("\n")
    cli_alert_success("Your final categorisations have been saved:\n{output_fname_csv}")
    cli_alert_success("Your session log has been saved:\n{output_fname_log_csv}")

    # Create and save a summary plot
    counts <- Output %>% group_by(Domain_code) %>% count() %>% arrange(n)

    Domain_plot <- counts %>%
      ggplot(aes(x=reorder(Domain_code, -n), y=n)) +
      geom_col() +
      ggtitle(paste("Data Elements in", data$meta_json$dataModel$childDataClasses[[dc]]$label, "grouped by Domain code")) +
      theme_gray(base_size = 18) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
      xlab('Domain Code') +
      ylab('Count') +
      scale_y_continuous(breaks=seq(0,max(counts$n),1))

    full_plot <- grid.arrange(Domain_plot, Domain_table,nrow=1,ncol=2)
    ggsave(plot = full_plot,paste(output_dir,output_fname_png,sep='/'),width = 14, height = 8, units = "in")
    cli_alert_success("A summary plot has been saved:\n{output_fname_png}")

  } # end of loop for each table

} # end of function
