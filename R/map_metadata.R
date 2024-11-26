#' map_metadata
#'
#' This function will read in the metadata file for a chosen dataset, loop
#' through all the data elements, and ask the user to catergorise/label each
#' data element as belonging to one or more domains. The domains will appear
#' in the Plots tab for the user's reference. \cr \cr
#' These categorisations will be saved to a csv file, alongside a log file which
#' summarises the session details. To speed up this process, some
#' auto-categorisations will be made by the function for commonly occurring data
#' elements, and categorisations for the same data element can be copied from one
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
#' datasets. It only works for 1:1. mappings right now, i.e. DataElement
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
#' @examples
#' \dontrun{
#' # Demo run - requires user interactions
#' map_metadata()
#' }
#' @export
#' @importFrom dplyr %>% add_row
#' @importFrom cli cli_h1 cli_alert_info cli_alert_success
#' @importFrom utils packageVersion write.csv
#' @importFrom ggplot2 ggsave

map_metadata <- function(
    json_file = NULL,
    domain_file = NULL,
    look_up_file = NULL,
    output_dir = NULL,
    table_copy = TRUE) {
  timestamp_now_fname <- format(Sys.time(), "%Y-%m-%d-%H-%M-%S")
  timestamp_now <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

  # DEFINE INPUTS AND OUTPUTS ----

  ## Set output_dir to current wd if user has not provided it
  if (is.null(output_dir)) {
    output_dir <- getwd()
  }

  ## Use 'load_data.R' to collect inputs (defaults or user inputs)
  data <- load_data(json_file, domain_file, look_up_file)

  ## Extract Dataset from json_file
  dataset <- data$meta_json$dataModel
  dataset_name <- dataset$label

  ## Read in prepared output data frames
  log_output_df <- get("log_output_df")
  output_df <- get("output_df")

  ## Use 'ref_plot.R' to plot domains for the user's ref (save df for later use)
  df_plots <- ref_plot(data$domains)

  ## Check if look_up_file and domain_file are compatible
  mistmatch <- setdiff(data$lookup$domain_code, df_plots$code$code)
  if (length(mistmatch) > 0) {
    cli_alert_danger("The look_up_file and domain_file are not compatabile. These look up codes are not listed in the domain codes:")
    cat("\n")
    print(mistmatch)
    stop()
  }

  ## Use 'user_prompt.R' to get user initials for the log file
  user_initials <- user_prompt(
    prompt_text = "Enter your initials: ", any_keys = TRUE
  )

  # DISPLAY DATASET ----

  cli_h1("Dataset Name")
  cat(dataset_name)
  cli_h1("Dataset File Exported By")
  cat(paste(
    data$meta_json$exportMetadata$exportedBy,
    "at", data$meta_json$exportMetadata$exportedOn
  ))
  cat("\n\n")
  cli_alert_info("Reference outputs from browse_metadata for information about the dataset")
  cat("\nPress any key to continue ")
  readline()

  # WHICH TABLES FROM THE DATASET? ----
  ## Use 'user_prompt_list.R' to ask user which tables to process
  n_tables <- nrow(dataset$childDataClasses)
  table_list_df <- data.frame(table_name = character(0), table_number = integer(0))
  for (dc in 1:n_tables) {
    table_list_df <- table_list_df %>% add_row(
      table_number = dc,
      table_name = dataset$childDataClasses$label[dc]
    )
  }

  print(table_list_df, row.names = FALSE)
  n_tables_process <- user_prompt_list(
    prompt_text =
      paste(
        "Found", n_tables, "table(s) in this dataset.", "Enter table numbers",
        "you want to process (one table number on each line):"
      ),
    list_allowed = seq(from = 1, to = n_tables, by = 1),
    empty_allowed = FALSE
  )

  # PROCESS EACH CHOSEN TABLE ----
  ## Extract each Table
  for (dc in unique(n_tables_process)) {
    cat("\n")
    cli_alert_info("Processing Table {dc} of {n_tables}")
    cli_h1("Table Name")
    table_name <- dataset$childDataClasses$label[dc]
    cat(table_name, "\n", fill = TRUE)
    cat("\n")
    cli_alert_info("Reference outputs from browse_metadata for information about the table")
    cat("\n")

    ### Use 'copy_previous.R' to copy from previous output(s) if they exist
    if (table_copy == TRUE) {
      copy_prev <- copy_previous(dataset_name, output_dir)
      df_prev_exist <- copy_prev$df_prev_exist
      df_prev <- copy_prev$df_prev
    } else {
      df_prev_exist <- FALSE
    }

    table_note <- readline(paste(
      "Optional free text note about this table",
      "(or press enter to continue): "
    ))

    ###  Use 'json_table_to_df.R' to extract table from meta_json into a df
    table_df <- json_table_to_df(dataset = dataset, n = dc)

    ### Ask user which data elements to process

    cli_alert_info(paste(
      "There are", as.character(nrow(table_df)),
      "data elements (variables) in this table."
    ))

    if (data$demo_mode == TRUE) {
      start_v <- 1
      end_v <- min(20, nrow(table_df))
    } else {
      #### Use 'user_prompt_list.R' to ask user which data elements
      start_end_v <- 0
      start_v <- 0
      end_v <- 0
      while (length(start_end_v) != 2 | start_v > end_v) {
        start_end_v <- user_prompt_list(
          prompt_text = "Which data elements do you want to process? 1:[start integer] and 2:[end integer]",
          list_allowed = seq(from = 1, to = nrow(table_df), by = 1),
          empty_allowed = FALSE
        )
        start_v <- start_end_v[1]
        end_v <- start_end_v[2]
      }
    }

    ### Use 'user_categorisation_loop.R' to copy or request from user

    output_df <- user_categorisation_loop(start_v,
      end_v,
      table_df,
      df_prev_exist,
      df_prev,
      lookup = data$lookup,
      df_plots,
      output_df
    )

    output_df$timestamp <- timestamp_now
    output_df$table <- table_name

    ### Review auto categorized data elements
    #### Use 'user_prompt_list.R' to ask the user which rows to edit
    cat("\n")
    output_auto <- subset(output_df, note == "AUTO CATEGORISED")
    output_auto <- output_auto[, c("data_element", "domain_code", "note")]
    print(output_auto)

    auto_row <- user_prompt_list(
      prompt_text = paste(
        "These are the auto categorised data elements.",
        "Enter row numbers for those you want to edit: "
      ),
      list_allowed = which(output_df$note == "AUTO CATEGORISED"),
      empty_allowed = TRUE
    )

    if (length(auto_row) != 0) {
      for (data_v_auto in unique(auto_row)) {
        ##### collect user responses with with 'user_categorisation.R'
        decision_output <- user_categorisation(
          table_df$label[data_v_auto],
          table_df$description[data_v_auto],
          table_df$type[data_v_auto],
          max(df_plots$code$code)
        )
        ##### input user responses into output
        output_df$domain_code[data_v_auto] <- decision_output$decision
        output_df$note[data_v_auto] <- decision_output$decision_note
      }
    }

    ### Review user categorized data elements (optional)
    #### Use 'user_prompt.R' to ask the user if they want to review
    #### Use 'user_prompt_list.R' to ask the user which rows to edit
    review_cats <- user_prompt(
      prompt_text = "Would you like to review your categorisations? (y/n): ",
      any_keys = FALSE
    )
    if (review_cats == "Y" | review_cats == "y") {
      output_not_auto <- subset(output_df, note != "AUTO CATEGORISED")
      output_not_auto["note (first 12 chars)"] <-
        substring(output_not_auto$note, 1, 11)
      print(output_not_auto[
        ,
        c(
          "data_element",
          "domain_code",
          "note (first 12 chars)"
        )
      ])
      not_auto_row <- user_prompt_list(
        prompt_text = paste(
          "These are the data elements you categorised.",
          "Enter row numbers for those you want to edit: "
        ),
        list_allowed = which(output_df$note != "AUTO CATEGORISED"),
        empty_allowed = TRUE
      )
      if (length(not_auto_row) != 0) {
        for (data_v_not_auto in unique(not_auto_row)) {
          #####  collect user responses with with 'user_categorisation.R'
          decision_output <- user_categorisation(
            table_df$label[data_v_not_auto],
            table_df$description[data_v_not_auto],
            table_df$type[data_v_not_auto],
            max(df_plots$code$code)
          )
          ##### input user responses into output
          output_df$domain_code[data_v_not_auto] <- decision_output$decision
          output_df$note[data_v_not_auto] <- decision_output$decision_note
        }
      }
    }

    ### Fill in log output
    log_output_df$timestamp <- timestamp_now
    log_output_df$browseMetadata <- packageVersion("browseMetadata")
    log_output_df$initials <- user_initials
    log_output_df$metadata_version <- dataset$documentationVersion
    log_output_df$metadata_last_updated <- dataset$lastUpdated
    log_output_df$domain_list_desc <- data$domain_list_desc
    log_output_df$dataset <- dataset_name
    log_output_df$table <- table_name
    log_output_df$table_note <- table_note

    ### Create output file names
    csv_fname <- paste0(
      "OUTPUT_", gsub(" ", "", dataset_name), "_",
      gsub(" ", "", table_name), "_", timestamp_now_fname, ".csv"
    )
    csv_log_fname <- paste0(
      "LOG_", gsub(" ", "", dataset_name), "_",
      gsub(" ", "", table_name), "_", timestamp_now_fname, ".csv"
    )
    png_fname <- paste0(
      "PLOT_", gsub(" ", "", dataset_name), "_",
      gsub(" ", "", table_name), "_", timestamp_now_fname, ".png"
    )

    ### Save final categorisations for this Table
    write.csv(output_df, paste(output_dir, csv_fname, sep = "/"),
      row.names = FALSE
    )
    write.csv(log_output_df, paste(output_dir, csv_log_fname, sep = "/"),
      row.names = FALSE
    )
    cat("\n")
    cli_alert_success("Final categorisations saved in:\n{csv_fname}")
    cli_alert_success("Session log saved in:\n{csv_log_fname}")

    ### Create and save a summary plot
    end_plot_save <- end_plot(
      df = output_df, table_name,
      ref_table = df_plots$domain_table
    )
    ggsave(
      plot = end_plot_save,
      paste(output_dir, png_fname, sep = "/"),
      width = 14,
      height = 8,
      units = "in"
    )
    cli_alert_success("A summary plot has been saved:\n{png_fname}")
  } # end of loop for each table
} # end of function
