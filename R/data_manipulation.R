#' count_empty_desc
#'
#' This function is called within the browse_metadata function. \cr \cr
#' It reads in a data frame that summarises one table of the dataset. \cr \cr
#' It counts missing variable descriptions, based on specified criteria.
#'
#' @param Table_df Output from json_table_to_df.R
#' @param Table_colname Name of the table in column of the output dataframe
#' @return A simpler dataframe with Y/N empty counts for variables in the table.
#' @importFrom dplyr %>% group_by n summarize
#' @importFrom tidyr complete

count_empty_desc <- function(Table_df,Table_colname) {

  Table_df['Empty'] <- NA

  for (data_v in 1:nrow(Table_df)) {

    if ((nchar(Table_df$Description[data_v]) == 1)
        | (Table_df$Description[data_v] == 'Description to follow')
        | (Table_df$Description[data_v] == 'NA')){
      Table_df$Empty[data_v] = 'Yes'
    } else {
      Table_df$Empty[data_v] = 'No'}

  }

  # count how many are empty (add in N/Y count if 0)
  count_empty_table <- Table_df %>%
    group_by(Empty) %>%
    summarize(n = n()) %>%
    complete(Empty = c("No", "Yes"), fill = list(n = 0))

  # change the column name of 'n' to be the table name
  names(count_empty_table)[names(count_empty_table) == "n"] <- Table_colname

  count_empty_table

}

#' json_table_to_df
#'
#' This function is called within the browse_metadata and map_metadata functions. \cr \cr
#' It reads in the nested lists from the json and extracts information needed into a dataframe. \cr \cr
#' It does this for one specific table in a dataset. \cr \cr
#'
#' @param Dataset This is the dataModel field of the json
#' @param n The Dataset number (as a json can have multiple datasets)
#' @return A dataframe for that specific table, including data label, description and type.

json_table_to_df <- function(Dataset,n){

  jsonTable <- Dataset$childDataClasses[[n]]$childDataElements
  jsonTable_df <- data.frame(do.call(rbind, jsonTable)) # nested list to df
  jsonType_df_dataType <- data.frame(do.call(rbind, jsonTable_df$dataType)) # nested list to df

  Table_df <- data.frame(
    Label = unlist(jsonTable_df$label),
    Description = unlist(jsonTable_df$description),
    Type = unlist(jsonType_df_dataType$label)
  )

  Table_df <- Table_df[order(Table_df$Label), ]

  Table_df

}

#' join_outputs
#'
#' This function is called within the map_metadata_compare function. \cr \cr
#' Joins output dataframes from two sessions, on the column DataElement.
#'
#' @param session_1 Dataframe from session 1
#' @param session_2 Dataframe from session 2
#' @return Dataframe with information from session 1 and 2, joined on column DataElement.
#' @importFrom dplyr left_join join_by select contains

join_outputs <- function(session_1, session_2){

  ses_join <- left_join(session_1,session_2,suffix = c("_ses1","_ses2"),join_by(DataElement))
  ses_join <- select(ses_join,contains("_ses"),'DataElement')
  ses_join$Domain_code_join <- NA
  ses_join$Note_join <- NA
  ses_join
}

