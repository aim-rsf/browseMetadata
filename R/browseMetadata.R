#' browseMetadata
#'
#' This function will read in the metadata file for a chosen dataset, loop
#' through all the data elements, and ask the user to catergorise/label each
#' data element as belonging to one or more domains.\cr \cr
#' The domains will appear in the Plots tab and dataset information will be
#' printed to the R console, for the user's reference in making these
#' categorisations. \cr \cr
#' These categorisations will be saved to a csv file, alongside a log file which
#' summarises the session details.To speed up this process, some
#' auto-categorisations will be made by the function for commonly occurring data
#' elements and categorisations for the same data element can be copied from one
#' table to another. \cr \cr
#' Example inputs are provided within the package data, for the user to run this
#' function in a demo mode.
#' @param json_file The metadata file. This should be downloaded from the
#' metadata catalogue as a json file. See
#' 'data-raw/maternity_indicators_dataset_(mids)_20240105T132210.json' for an
#' example download.
#' @param domain_file The domain list file. This should be a csv file created by
#' the user, with each domain listed on a separate line. See
#' 'data-raw/domain_list_demo.csv' for a template.
#' @param look_up_file The look-up table file, with auto-categorisations. By
#' default, the code uses 'data/look-up.rda'. The user can provide their own
#' look-up table in the same format as 'data-raw/look-up.csv'.
#' @param output_dir The path to the directory where the two csv output files
#' will be saved. By default, the current working directory is used.
#' @param table_copy Turn on copying between tables (TRUE or FALSE, default
#' TRUE). If TRUE, categorisations you made for all other tables in this dataset
#' will be copied over (if 'OUTPUT_' files are found in output_dir).
#' @return The function will return two csv files: 'OUTPUT_' which contains the
#' mappings and 'LOG_' which contains details about the dataset and session.
#' @examples
#' # Run in demo mode by providing no inputs: browseMetadata()
#' # Demo mode will use the /data files provided in this package
#' # For more guidance, refer to the package README.md file.
#' @export
#' @import ggplot2
#' @importFrom graphics plot.new
#' @importFrom utils read.csv write.csv
#' @importFrom dplyr %>% arrange count group_by distinct
#' @importFrom tidyverse add_row

browseMetadata <- function(
    json_file = NULL,
    domain_file = NULL,
    look_up_file = NULL,
    output_dir = NULL,
    table_copy = TRUE) {

  timestamp_now <- format(Sys.time(), "%Y-%m-%d-%H-%M-%S")

  # DEFINE INPUTS AND OUTPUTS ----

  ## Set output_dir to current wd if user has not provided it
  if (is.null(output_dir)) {
    output_dir = getwd()
  }

  ## Use 'load_data.R' to collect inputs (defaults or user inputs)
  data <- load_data(json_file, domain_file, look_up_file)

  ## Extract Dataset from json_file
  Dataset <- data$meta_json$dataModel
  Dataset_Name <- Dataset$label

  ## Read in prepared output data frames
  log_Output <- get("log_Output")
  Output <- get("Output")

  ## Use 'ref_plot.R' to plot domains for the user's ref (save df for later use)
  df_plots <- ref_plot(data$domains)

  ## Use 'user_prompt.R' to get user initials for the log file
  User_Initials <- user_prompt(
    prompt_text = "Enter your initials: ", any_keys = TRUE)

  # DISPLAY DATASET ----

  ## Use 'user_prompt.R' to print info about dataset based on user input
  pre_prompt_text <- data.frame(Heading = logical(0), Text = character(0))
  pre_prompt_text <- pre_prompt_text %>% add_row(Heading = TRUE,
                                                 Text = 'Dataset Name')
  pre_prompt_text <- pre_prompt_text %>% add_row(
    Heading = FALSE,Text = paste(Dataset_Name))
  pre_prompt_text <- pre_prompt_text %>% add_row(
    Heading = TRUE,Text = 'Dataset File Exported By')
  pre_prompt_text <- pre_prompt_text %>% add_row(
    Heading = FALSE,
    Text = paste(data$meta_json$exportMetadata$exportedBy,
                 "at",data$meta_json$exportMetadata$exportedOn))
  prompt_text <- "Would you like to read a description of the dataset? (y/n): "
  post_yes_text <- data.frame(Heading = logical(0), Text = character(0))
  post_yes_text <- post_yes_text %>% add_row(
    Heading = TRUE, Text = 'Dataset Description')
  post_yes_text <- post_yes_text %>% add_row(
    Heading = FALSE,Text = paste(Dataset$description))

  user_prompt(
    pre_prompt_text = pre_prompt_text,
    prompt_text = prompt_text,
    any_keys = FALSE,
    post_yes_text = post_yes_text
  )

  # WHICH TABLES FROM THE DATASET? ----
  ## Use 'user_prompt_list.R' to ask user which tables to process
  nTables <- length(Dataset$childDataClasses)
  table_df <- data.frame(Table_Name = character(0), Table_Number = integer(0))
  for (dc in 1:nTables) {
    table_df <- table_df %>% add_row(
      Table_Number = dc,
      Table_Name = Dataset$childDataClasses[[dc]]$label)
    }

  nTables_Process <- user_prompt_list(
    pre_prompt_df = table_df,
    pre_prompt_df_rows = FALSE,
    prompt_text =
      paste('Found',nTables,'table(s) in this Dataset.','Enter table numbers',
            'you want to process (one table number on each line):'),
    list_allowed = seq(from = 1, to = nTables, by = 1)
  )

  # PROCESS EACH CHOSEN TABLE ----
  ## Extract each Table
  for (dc in unique(nTables_Process)) {
    cat("\n")
    cli_alert_info("Processing Table {dc} of {nTables}")
    cli_h1("Table Name")
    Table_name <- Dataset$childDataClasses[[dc]]$label
    cat(Table_name,"\n",fill = TRUE)

    ### Use 'copy_previous.R' to copy from previous output(s) if they exist ----
    if (table_copy == TRUE) {
      output <- copy_previous(Dataset_Name,output_dir)
      df_prev_exist <- output$df_prev_exist
      df_prev <- output$df_prev
    } else {
      df_prev_exist <- FALSE
    }

    ## Use 'user_prompt.R' to ask if user wants to read desc of table ----
    prompt_text = "Would you like to read a description of the table? (y/n): "
    post_yes_text <- data.frame(Heading = logical(0), Text = character(0))
    post_yes_text <- post_yes_text %>% add_row(
      Heading = TRUE, Text = 'Table Description')
    post_yes_text <- post_yes_text %>% add_row(
      Heading = FALSE,
      Text = paste(Dataset$childDataClasses[[dc]]$description)
    )

    user_prompt(
      prompt_text = prompt_text,
      any_keys = FALSE,
      post_yes_text = post_yes_text
    )

    table_note <- readline(paste('Optional free text note about this table',
                                 '(or press enter to continue): '))

    ## Extract data for this table into a data frame ----
    Table <- Dataset$childDataClasses[[dc]]$childDataElements #probably a better way of dealing with complex json files in R ...
    Table_df <- data.frame(do.call(rbind, Table)) # nested list to df
    dataType_df <- data.frame(do.call(rbind, Table_df$dataType)) # nested list to df

    selectTable_df <- data.frame(
      Label = unlist(Table_df$label),
      Description = unlist(Table_df$description),
      Type = unlist(dataType_df$label)
    )

    selectTable_df <- selectTable_df[order(selectTable_df$Label), ]

    ## Loop through each data element, request categorisation from user ----

    ### if it's the demo run, only loop through a max of 20 data elements ----
    if (data$demo_mode == TRUE) {
      start_v = 1
      end_v = min(20, nrow(selectTable_df))
    } else {
      cli_h1(paste(
        'There are',
        as.character(nrow(selectTable_df)),
        'data elements (variables) in this table.'
      ))
      cat("\n")
      start_v <- readline(prompt = "Start variable (write 1 to process all): ")
      cat("\n")
      end_v <- readline(prompt = paste(
        "End variable (write",
        nrow(selectTable_df),
        "to process all): "
      ))
    }

    for (data_v in start_v:end_v) {
      cat("\n \n")
      cli_alert_info(paste(length(data_v:end_v), 'left to process'))
      cli_alert_info("Processing data element {data_v}
                     of {nrow(selectTable_df)}")
      this_DataElement <- selectTable_df$Label[data_v]
      this_DataElement_N <- paste(as.character(data_v), 'of',
                                  as.character(nrow(selectTable_df)))
      data_v_index <- which(data$lookup$DataElement ==
                              selectTable_df$Label[data_v]) #we should code this to ignore the case
      lookup_subset <- data$lookup[data_v_index, ]
      #### search if data element matches any data elements from previous table
      if (df_prev_exist == TRUE) {
        data_v_index <- which(df_prev$DataElement ==
                                selectTable_df$Label[data_v])
        df_prev_subset <- df_prev[data_v_index, ]
      } else {
        df_prev_subset <- data.frame()
      }
      #### decide how to process the data element out of 3 options
      if (nrow(lookup_subset) == 1) {
        ##### 1 - auto categorisation
        Output <- Output %>% add_row(
          timestamp = timestamp_now,
          Table = Table_name,
          DataElement = this_DataElement,
          DataElement_N = this_DataElement_N,
          Domain_code = as.character(lookup_subset$DomainCode),
          Note = 'AUTO CATEGORISED'
        )
      } else if (df_prev_exist == TRUE &
                 nrow(df_prev_subset) == 1) {
        ##### 2 - copy from previous table
        Output <- Output %>% add_row(
          timestamp = timestamp_now,
          Table = Table_name,
          DataElement = this_DataElement,
          DataElement_N = this_DataElement_N,
          Domain_code = as.character(df_prev_subset$Domain_code),
          Note = paste0("COPIED FROM: ", df_prev_subset$Table)
        )
      } else {
        ##### 3 - collect user responses with 'user_categorisation.R'
        decision_output <- user_categorisation(
          selectTable_df$Label[data_v],
          selectTable_df$Description[data_v],
          selectTable_df$Type[data_v],
          max(df_plots$Code$Code)
        )
        Output <- Output %>% add_row(
          timestamp = timestamp_now,
          Table = Table_name,
          DataElement = this_DataElement,
          DataElement_N = this_DataElement_N,
          Domain_code = decision_output$decision,
          Note = decision_output$decision_note
        )
      }
    } ##### end of loop for DataElement

    ## Review auto categorized data elements ----
    ### Use 'user_prompt_list.R' to ask the user which rows to edit
    Output_auto <- subset(Output, Note == 'AUTO CATEGORISED')
    Output_auto <- Output_auto[, c("DataElement", "Domain_code", "Note")]

    auto_row <- user_prompt_list(
      pre_prompt_df = Output_auto,
      pre_prompt_df_rows = TRUE,
      prompt_text =paste('These are the auto categorised data elements.'
                         'Enter row numbers for those you want to edit: '),
      list_allowed = which(Output$Note == 'AUTO CATEGORISED')
    )

    if (length(auto_row) != 0) {
      for (data_v_auto in unique(auto_row)) {
        #### collect user responses with with 'user_categorisation.R'
        decision_output <- user_categorisation(
          selectTable_df$Label[data_v_auto],
          selectTable_df$Description[data_v_auto],
          selectTable_df$Type[data_v_auto],
          max(df_plots$Code$Code)
        )
        #### input user responses into output
        Output$Domain_code[data_v_auto] <- decision_output$decision
        Output$Note[data_v_auto] <- decision_output$decision_note
      }
    }

    ## Review user categorized data elements (optional) ----
    ### Use 'user_prompt.R' to ask the user if they want to review
    ### Use 'user_prompt_list.R' to ask the user which rows to edit
    review_cats <- user_prompt(
      prompt_text = "Would you like to review your categorisations? (y/n): ",
      any_keys = FALSE)
    if (review_cats == 'Y' | review_cats == 'y') {
      Output_not_auto <- subset(Output, Note != 'AUTO CATEGORISED')
      Output_not_auto['Note (first 12 chars)'] <-
        substring(Output_not_auto$Note, 1, 11)
      Output_not_auto <- Output_not_auto[,
                                         c("DataElement",
                                           "Domain_code",
                                           "Note (first 12 chars)")]

      not_auto_row <- user_prompt_list(
        pre_prompt_df = Output_not_auto,
        pre_prompt_df_rows = TRUE,
        prompt_text = paste('These are the data elements you categorised.',
                            'Enter row numbers for those you want to edit: '),
        list_allowed = which(Output$Note != 'AUTO CATEGORISED')
      )
      if (length(not_auto_row) != 0) {
        for (data_v_not_auto in unique(not_auto_row)) {
          # collect user responses with with 'user_categorisation.R'
          decision_output <- user_categorisation(
            selectTable_df$Label[data_v_not_auto],
            selectTable_df$Description[data_v_not_auto],
            selectTable_df$Type[data_v_not_auto],
            max(df_plots$Code$Code)
          )
          #### input user responses into output
          Output$Domain_code[data_v_not_auto] <- decision_output$decision
          Output$Note[data_v_not_auto] <- decision_output$decision_note
        }
      }
    }

    ## Fill in log output ----
    log_Output <- log_Output %>% add_row(
      timestamp = timestamp_now,
      browseMetadata = packageVersion("browseMetadata"),
      Initials = User_Initials,
      MetaDataVersion = Dataset$documentationVersion,
      MetaDataLastUpdated = Dataset$lastUpdated,
      DomainListDesc = data$DomainListDesc,
      Dataset = Dataset_Name,
      Table = Table_name,
      Table_note = table_note
    )

    ## Create output file names ----
    csv_fname <- paste0("OUTPUT_",gsub(" ", "", Dataset_Name),"_",
                        gsub(" ", "", Table_name),"_",timestamp_now,".csv")
    csv_log_fname <- paste0("LOG_",gsub(" ", "", Dataset_Name),"_",
                            gsub(" ", "", Table_name),"_",timestamp_now,".csv")
    png_fname <- paste0("PLOT_",gsub(" ", "", Dataset_Name),"_",
                        gsub(" ", "", Table_name),"_",timestamp_now,".png")

    ## Save final categorisations for this Table  ----
    utils::write.csv(Output,paste(output_dir, csv_fname, sep = '/'),
                     row.names = FALSE)
    utils::write.csv(log_Output,paste(output_dir, csv_log_fname, sep = '/'),
                     row.names = FALSE)
    cat("\n")
    cli_alert_success("Final categorisations saved in:\n{csv_fname}")
    cli_alert_success("Session log saved in:\n{csv_log_fname}")

    ## Create and save a summary plot
    counts <- Output %>% group_by(Domain_code) %>% count() %>% arrange(n)

    Domain_plot <- counts %>%
      ggplot(aes(x = reorder(Domain_code, -n), y = n)) +
      geom_col() +
      ggtitle(paste("Data Elements in",Table_name,"grouped by Domain code")) +
      theme_gray(base_size = 18) +
      theme(axis.text.x = element_text(
        angle = 90,
        vjust = 0.5,
        hjust = 1
      )) +
      xlab('Domain Code') +
      ylab('Count') +
      scale_y_continuous(breaks = seq(0, max(counts$n), 1))

    full_plot <- grid.arrange(Domain_plot,
                              Domain_table,
                              nrow = 1,
                              ncol = 2)
    ggsave(
      plot = full_plot,
      paste(output_dir, png_fname, sep = '/'),
      width = 14,
      height = 8,
      units = "in"
    )
    cli_alert_success("A summary plot has been saved:\n{png_fname}")

  } # end of loop for each table

} # end of function
