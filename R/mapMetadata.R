#' mapMetadata
#'
#' This function will read in the metadata file for a chosen dataset, loop
#' through all the data elements, and ask the user to catergorise/label each
#' data element as belonging to one or more domains. The domains will appear
#' in the Plots tab for the user's reference. \cr \cr
#' These categorisations will be saved to a csv file, alongside a log file which
#' summarises the session details. To speed up this process, some
#' auto-categorisations will be made by the function for commonly occurring data
#' elements and categorisations for the same data element can be copied from one
#' table to another. \cr \cr
#' Example inputs are provided within the package data, for the user to run this
#' function in a demo mode.
#' @param json_file The metadata file. This should be a json download from the
#' metadata catalogue. By default, 'data/json_metadata.rda' is used - run
#' '?json_metadata' to see how it was created.
#' @param domain_file The domain list file. This should be a csv file created by
#' the user, with each domain listed on a separate line, no header. By default,
#' 'data/domain_list.rda' is used - run '?domain_list' to see how it was created.
#' Note that 4 domains will be added automatically (NO MATCH/UNSURE, METADATA,
#' ID, DEMOGRAPHICS) and therefore should not be included in the domain_file.
#' @param look_up_file The look-up table file. By default, 'data/look-up.rda'
#' is used - run '?look_up' to see how it was created. The lookup file makes
#' auto-categorisations intended for variables that appear regularly in health
#' datasets. It only works for for 1:1. mappings right now, i.e. DataElement
#' should only be listed once in the file.
#' @param output_dir The path to the directory where the two csv output files
#' will be saved. By default, the current working directory is used.
#' @param table_copy Turn on copying between tables (TRUE or FALSE, default
#' TRUE). If TRUE, categorisations you made for all other tables in this dataset
#' will be copied over (if 'OUTPUT_' files are found in output_dir). This can be
#'  useful when the same data elements (variables) appear across multiple
#'  tables within one dataset; copying from one table to the next will save the
#'  user time, and ensure consistency of categorisations across tables.
#' @return The function will return two csv files: 'OUTPUT_' which contains the
#' mappings and 'LOG_' which contains details about the dataset and session.
#' @export
#' @importFrom dplyr %>% add_row
#' @importFrom cli cli_h1 cli_alert_info cli_alert_success
#' @importFrom utils packageVersion write.csv
#' @importFrom ggplot2 ggsave

mapMetadata <- function(
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

  cli_h1('Dataset Name')
  cat(Dataset_Name)
  cli_h1('Dataset File Exported By')
  cat(paste(data$meta_json$exportMetadata$exportedBy,
            "at",data$meta_json$exportMetadata$exportedOn))
  cat("\n\n")
  cli_alert_info("Reference outputs from browseMetadata for information about the dataset")
  cat("\nPress any key to continue ")
  readline()

  # WHICH TABLES FROM THE DATASET? ----
  ## Use 'user_prompt_list.R' to ask user which tables to process
  nTables <- length(Dataset$childDataClasses)
  table_list_df <- data.frame(Table_Name = character(0), Table_Number = integer(0))
  for (dc in 1:nTables) {
    table_list_df <- table_list_df %>% add_row(
      Table_Number = dc,
      Table_Name = Dataset$childDataClasses[[dc]]$label)
    }

  print(table_list_df,row.names = FALSE)
    nTables_Process <- user_prompt_list(
    prompt_text =
      paste('Found',nTables,'table(s) in this Dataset.','Enter table numbers',
            'you want to process (one table number on each line):'),
    list_allowed = seq(from = 1, to = nTables, by = 1),
    empty_allowed = FALSE
  )

  # PROCESS EACH CHOSEN TABLE ----
  ## Extract each Table
  for (dc in unique(nTables_Process)) {
    cat("\n")
    cli_alert_info("Processing Table {dc} of {nTables}")
    cli_h1("Table Name")
    Table_name <- Dataset$childDataClasses[[dc]]$label
    cat(Table_name,"\n",fill = TRUE)
    cat("\n")
    cli_alert_info("Reference outputs from browseMetadata for information about the table")
    cat("\n")

    ### Use 'copy_previous.R' to copy from previous output(s) if they exist
    if (table_copy == TRUE) {
      output <- copy_previous(Dataset_Name,output_dir)
      df_prev_exist <- output$df_prev_exist
      df_prev <- output$df_prev
    } else {
      df_prev_exist <- FALSE
    }

    table_note <- readline(paste('Optional free text note about this table',
                                 '(or press enter to continue): '))

    ###  Use 'json_table_to_df.R' to extract table from meta_json into a df
    Table_df <- json_table_to_df(Dataset = Dataset,n = dc)

    ### Ask user which data elements to process

    cli_alert_info(paste('There are', as.character(nrow(Table_df)),
                 'data elements (variables) in this table.'))

    if (data$demo_mode == TRUE) {
      start_v = 1
      end_v = min(20, nrow(Table_df))
    } else {
      #### Use 'user_prompt_list.R' to ask user which data elements
      start_v <- user_prompt_list(
        prompt_text = 'Start variable (write 1 to process all): ',
        list_allowed = seq(from = 1, to = nrow(Table_df), by = 1),
        empty_allowed = FALSE)
      end_v <- user_prompt_list(
        prompt_text = paste('End variable (write',
                            as.character(nrow(Table_df)),
                            'to process all):'),
        list_allowed = seq(from = start_v, to = nrow(Table_df), by = 1),
        empty_allowed = FALSE)
    }

    ### Use 'user_categorisation_loop.R' to copy or request from user

    Output <- user_categorisation_loop(start_v,
                             end_v,
                             Table_df,
                             df_prev_exist,
                             df_prev,
                             lookup = data$lookup,
                             df_plots,
                             Output)

    Output$timestamp <- timestamp_now
    Output$Table <- Table_name

    ### Review auto categorized data elements
    #### Use 'user_prompt_list.R' to ask the user which rows to edit
    cat('\n')
    Output_auto <- subset(Output, Note == 'AUTO CATEGORISED')
    Output_auto <- Output_auto[, c("DataElement", "Domain_code", "Note")]
    print(Output_auto)

    auto_row <- user_prompt_list(
      prompt_text = paste('These are the auto categorised data elements.',
                          'Enter row numbers for those you want to edit: '),
      list_allowed = which(Output$Note == 'AUTO CATEGORISED'),
      empty_allowed = TRUE
    )

    if (length(auto_row) != 0) {
      for (data_v_auto in unique(auto_row)) {
        ##### collect user responses with with 'user_categorisation.R'
        decision_output <- user_categorisation(
          Table_df$Label[data_v_auto],
          Table_df$Description[data_v_auto],
          Table_df$Type[data_v_auto],
          max(df_plots$Code$Code)
        )
        ##### input user responses into output
        Output$Domain_code[data_v_auto] <- decision_output$decision
        Output$Note[data_v_auto] <- decision_output$decision_note
      }
    }

    ### Review user categorized data elements (optional)
    #### Use 'user_prompt.R' to ask the user if they want to review
    #### Use 'user_prompt_list.R' to ask the user which rows to edit
    review_cats <- user_prompt(
      prompt_text = "Would you like to review your categorisations? (y/n): ",
      any_keys = FALSE)
    if (review_cats == 'Y' | review_cats == 'y') {
      Output_not_auto <- subset(Output, Note != 'AUTO CATEGORISED')
      Output_not_auto['Note (first 12 chars)'] <-
        substring(Output_not_auto$Note, 1, 11)
      print(Output_not_auto[,
                            c("DataElement",
                              "Domain_code",
                              "Note (first 12 chars)")])
      not_auto_row <- user_prompt_list(
        prompt_text = paste('These are the data elements you categorised.',
                            'Enter row numbers for those you want to edit: '),
        list_allowed = which(Output$Note != 'AUTO CATEGORISED'),
        empty_allowed = TRUE
      )
      if (length(not_auto_row) != 0) {
        for (data_v_not_auto in unique(not_auto_row)) {
          #####  collect user responses with with 'user_categorisation.R'
          decision_output <- user_categorisation(
            Table_df$Label[data_v_not_auto],
            Table_df$Description[data_v_not_auto],
            Table_df$Type[data_v_not_auto],
            max(df_plots$Code$Code)
          )
          ##### input user responses into output
          Output$Domain_code[data_v_not_auto] <- decision_output$decision
          Output$Note[data_v_not_auto] <- decision_output$decision_note
        }
      }
    }

    ### Fill in log output
    log_Output$timestamp = timestamp_now
    log_Output$browseMetadata = packageVersion("browseMetadata")
    log_Output$Initials = User_Initials
    log_Output$MetaDataVersion = Dataset$documentationVersion
    log_Output$MetaDataLastUpdated = Dataset$lastUpdated
    log_Output$DomainListDesc = data$DomainListDesc
    log_Output$Dataset = Dataset_Name
    log_Output$Table = Table_name
    log_Output$Table_note = table_note

    ### Create output file names
    csv_fname <- paste0("OUTPUT_",gsub(" ", "", Dataset_Name),"_",
                        gsub(" ", "", Table_name),"_",timestamp_now,".csv")
    csv_log_fname <- paste0("LOG_",gsub(" ", "", Dataset_Name),"_",
                            gsub(" ", "", Table_name),"_",timestamp_now,".csv")
    png_fname <- paste0("PLOT_",gsub(" ", "", Dataset_Name),"_",
                        gsub(" ", "", Table_name),"_",timestamp_now,".png")

    ### Save final categorisations for this Table
    write.csv(Output,paste(output_dir, csv_fname, sep = '/'),
                     row.names = FALSE)
    write.csv(log_Output,paste(output_dir, csv_log_fname, sep = '/'),
                     row.names = FALSE)
    cat("\n")
    cli_alert_success("Final categorisations saved in:\n{csv_fname}")
    cli_alert_success("Session log saved in:\n{csv_log_fname}")

    ### Create and save a summary plot
    end_plot_save <- end_plot(df = Output,Table_name,
                              ref_table = df_plots$Domain_table)
    ggsave(
      plot = end_plot_save$full_plot,
      paste(output_dir, png_fname, sep = '/'),
      width = 14,
      height = 8,
      units = "in"
    )
    cli_alert_success("A summary plot has been saved:\n{png_fname}")

  } # end of loop for each table

} # end of function
