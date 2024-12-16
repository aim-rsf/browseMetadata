#' json_table_to_df
#'
#' Internal Function: This function is called within the browse_metadata and map_metadata functions. \cr \cr
#' It reads in the nested lists from the json and extracts information needed into a dataframe. \cr \cr
#' It does this for one specific table in a dataset. \cr \cr
#'
#' @param dataset This is the dataModel field of the json
#' @param n The table number (as a json can have multiple tables within a dataset)
#' @return A dataframe for that specific table, including data label, description and type.
#' @keywords internal

json_table_to_df <- function(dataset, n) {
  json_table <- dataset$childDataClasses$childDataElements[n]
  json_table_df <- json_table[[1]]

  table_df <- data.frame(
    label = json_table_df$label,
    description = json_table_df$description,
    type = json_table_df$dataType$label
  )

  table_df <- table_df[order(table_df$label), ]

  table_df
}

#' count_empty_desc
#'
#' Internal Function: This function is called within the browse_metadata function. \cr \cr
#' It reads in a data frame that summarises one table of the dataset. \cr \cr
#' It counts missing variable descriptions, based on specified criteria.
#'
#' @param table_df Output from json_table_to_df.R
#' @param table_colname Name of the table in column of the output dataframe
#' @return A simpler dataframe with Y/N empty counts for variables in the table.
#' @importFrom dplyr %>% group_by n summarize
#' @importFrom tidyr complete
#' @keywords internal

count_empty_desc <- function(table_df, table_colname) {
  table_df["empty"] <- NA

  for (data_v in seq_len(nrow(table_df))) {
    if ((nchar(table_df$description[data_v]) == 1) ||
      (table_df$description[data_v] == "Description to follow") ||
      (table_df$description[data_v] == "NA")) {
      table_df$empty[data_v] <- "Yes"
    } else {
      table_df$empty[data_v] <- "No"
    }
  }

  # count how many are empty (add in N/Y count if 0)
  count_empty_table <- table_df %>%
    group_by(empty) %>%
    summarize(n = n()) %>%
    complete(empty = c("No", "Yes"), fill = list(n = 0))

  # change the column name of 'n' to be the table name
  names(count_empty_table)[names(count_empty_table) == "n"] <- table_colname

  count_empty_table
}

#' join_outputs
#'
#' Internal Function: This function is called within the map_metadata_compare function. \cr \cr
#' Joins output dataframes from two sessions, on the column DataElement.
#'
#' @param session_1 Dataframe from session 1
#' @param session_2 Dataframe from session 2
#' @return Dataframe with information from session 1 and 2, joined on column DataElement.
#' @importFrom dplyr left_join join_by select contains
#' @keywords internal


join_outputs <- function(session_1, session_2) {
  ses_join <- left_join(session_1, session_2, suffix = c("_ses1", "_ses2"), join_by(data_element))
  ses_join <- select(ses_join, contains("_ses"), "data_element")
  ses_join$domain_code_join <- NA
  ses_join$note_join <- NA
  ses_join
}
