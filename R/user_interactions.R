#' user_categorisation
#'
#' This function is called within the map_metadata function. \cr \cr
#' It displays data properties to the user and requests a categorisation into a domain. \cr \cr
#' An optional note can be included with the categorisation.
#'
#' @param data_element Name of the variable
#' @param data_desc Description of the variable
#' @param data_type Data type of the variable
#' @param domain_code_max Max code in the domain list (0-3 auto included, then N included via domain_file)
#' @return It returns a list containing the decision and decision note
#' @importFrom cli cli_alert_warning

user_categorisation <- function(data_element, data_desc, data_type, domain_code_max) {
  first_run <- TRUE
  go_back <- ""

  while (go_back == "Y" | go_back == "y" | first_run == TRUE) {
    go_back <- ""
    # print text to R console
    cat(paste(
      "\nDATA ELEMENT -----> ", data_element,
      "\n\nDESCRIPTION -----> ", data_desc,
      "\n\nDATA TYPE -----> ", data_type, "\n"
    ))

    # ask user for categorisation:

    decision <- ""
    validated <- FALSE
    cat("\n \n")

    while (decision == "" | validated == FALSE) {
      decision <- readline("Categorise data element into domain(s). E.g. 3 or 3,4: ")

      # validate input given by user
      decision_int <- as.integer(unlist(strsplit(decision, ",")))
      decision_int_NA <- any(is.na((decision_int)))
      suppressWarnings(decision_int_max <- max(decision_int, na.rm = TRUE))
      suppressWarnings(decision_int_min <- min(decision_int, na.rm = TRUE))
      if (decision_int_NA == TRUE | decision_int_max > domain_code_max | decision_int_min < 0) {
        cli_alert_warning("Formatting is invalid or integer out of range. Provide one integer or a comma seperated list of integers.")
        validated <- FALSE
      } else {
        validated <- TRUE
        # standardize output
        decision_int <- sort(decision_int)
        decision <- paste(decision_int, collapse = ",")
      }
    }

    # ask user for note on categorisation:

    cat("\n \n")
    decision_note <- readline("Categorisation note (or press enter to continue): ")

    while (go_back != "Y" & go_back != "y" & go_back != "N" & go_back != "n") {
      cat("\n \n")
      go_back <- readline(prompt = paste0("Response to be saved is '", decision, "'. Would you like to re-do? (y/n): "))
    }

    first_run <- FALSE
  }

  return(list(decision = decision, decision_note = decision_note))
}

#' user_categorisation_loop
#'
#' This function is called within the map_metadata function. \cr \cr
#' Given a specific table and a number of data elements to search, it checks for 3 different sources of domain categorisation: \cr \cr
#' 1 - If data elements match those in the look-up table, auto categorise them \cr \cr
#' 2 - If data elements match to previous table output, copy them \cr \cr
#' 3 - If no match for 1 or 2, data elements are categorised by the user \cr \cr
#' @param start_v Index of data element to start
#' @param end_v Index of data element to end
#' @param table_df Dataframe with the table information, extracted from json metadata
#' @param df_prev_exist Boolean to indicate with previous dataframes exist (to copy from)
#' @param df_prev Previous dataframes to copy from (or NULL)
#' @param lookup The lookup table to enable auto categorisations
#' @param df_plots Output from the ref_plot function, to indicate maximum domain code allowed
#' @param output Empty output dataframe, to fill
#' @return An output dataframe containing information about the table, data elements and categorisations
#' @importFrom dplyr %>% add_row
#' @importFrom cli cli_alert_info

user_categorisation_loop <- function(start_v, end_v, table_df, df_prev_exist, df_prev, lookup, df_plots, output) {
  for (data_v in start_v:end_v) {
    cat("\n \n")
    cli_alert_info(paste(length(data_v:end_v), "left to process"))
    cli_alert_info("Data element {data_v} of {nrow(table_df)}")
    this_data_element <- table_df$label[data_v]
    this_data_element_n <- paste(
      as.character(data_v), "of",
      as.character(nrow(table_df))
    )
    data_v_index <- which(lookup$data_element ==
      table_df$label[data_v]) # we should code this to ignore the case
    lookup_subset <- lookup[data_v_index, ]
    ##### search if data element matches any data elements from previous table
    if (df_prev_exist == TRUE) {
      data_v_index <- which(df_prev$data_element ==
        table_df$label[data_v])
      df_prev_subset <- df_prev[data_v_index, ]
    } else {
      df_prev_subset <- data.frame()
    }
    ##### decide how to process the data element out of 3 options
    if (nrow(lookup_subset) == 1) {
      ###### 1 - auto categorisation
      output <- output %>% add_row(
        data_element = this_data_element,
        data_element_n = this_data_element_n,
        domain_code = as.character(lookup_subset$domain_code),
        note = "AUTO CATEGORISED"
      )
    } else if (df_prev_exist == TRUE &
      nrow(df_prev_subset) == 1) {
      ###### 2 - copy from previous table
      output <- output %>% add_row(
        data_element = this_data_element,
        data_element_n = this_data_element_n,
        domain_code = as.character(df_prev_subset$domain_code),
        note = paste0("COPIED FROM: ", df_prev_subset$table)
      )
    } else {
      ###### 3 - collect user responses with 'user_categorisation.R'
      decision_output <- user_categorisation(
        table_df$label[data_v],
        table_df$description[data_v],
        table_df$type[data_v],
        max(df_plots$code$code)
      )
      output <- output %>% add_row(
        data_element = this_data_element,
        data_element_n = this_data_element_n,
        domain_code = decision_output$decision,
        note = decision_output$decision_note
      )
    }
  } # end of loop for data_element
  output
}

#' user_prompt
#'
#' This function is called within the map_metadata function. \cr \cr
#' It prompts a response from the user. \cr \cr
#'
#' @param prompt_text Text to display to the user, to prompt their response.
#' @param any_keys Boolean to determine if any key responses are allowable.
#' If FALSE, only these are allowed: Y, y, N and n.
#' @return It returns variable text, depending on any_keys.

user_prompt <- function(prompt_text, any_keys) {
  # prompt text is not
  # any_keys, when TRUE it allows any input, when FALSE it only allows y/n/Y/N
  # post_yes_text, when any_keys is FALSE and response is y/Y then print the post text

  # prompt text
  if (any_keys == TRUE) {
    response <- ""
    while (response == "") {
      response <- readline(prompt = prompt_text)
    }
  } else if (any_keys == FALSE) {
    response <- ""
    while (!response %in% c("Y", "y", "N", "n")) {
      response <- readline(prompt = prompt_text)
    }
  } else {
    stop("Invalid input given for 'any_keys'. Only TRUE or FALSE are allowed.")
  }

  response
}

#' user_prompt_list
#'
#' This function is called within the map_metadata function. \cr \cr
#' It prompts a response from the user, in the form of a list. \cr \cr
#' It checks if the user has given the an input within the allowed range - if not, it re-sends prompt. \cr \cr
#'
#' @param prompt_text Text to display to the user, to prompt their response.
#' @param list_allowed A list of allowable integer responses.
#' @param empty_allowed A boolean specifying if no response is allowed.
#' @return It returns a list of integers to process, that match the prompt options.
#' @importFrom cli cli_alert_info cli_alert_danger

user_prompt_list <- function(prompt_text, list_allowed, empty_allowed) {
  list_to_process_error <- TRUE
  list_to_process_in_range <- TRUE
  while (list_to_process_error == TRUE | list_to_process_in_range == FALSE) {
    tryCatch(
      {
        cat("\n \n")
        cli_alert_info(prompt_text)
        cat("\n")
        list_to_process <- scan(file = "", what = 0)
        list_to_process_in_range_1 <- (all(list_to_process %in% list_allowed))
        if (empty_allowed == FALSE) {
          list_to_process_in_range_2 <- (all(length(list_to_process) != 0))
        } else {
          list_to_process_in_range_2 <- TRUE
        }
        list_to_process_in_range <- all(list_to_process_in_range_1, list_to_process_in_range_2)
        if (list_to_process_in_range == FALSE) {
          cli_alert_danger("One of your inputs is out of range! Reference the allowable list of integers and try again.")
        }
        list_to_process_error <- FALSE
      },
      error = function(e) {
        list_to_process_error <- TRUE
        print(e)
        cat("\n")
        cli_alert_danger("Your input is in the wrong format. Reference the allowable list of integers and try again.")
      }
    )
  }
  list_to_process
}
