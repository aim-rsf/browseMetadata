#' join_outputs
#'
#' This function is called within the browseMetadata and mapMetadata functions. \cr \cr
#' It reads in the nested lists from the json and extracts information needed into a dataframe. \cr \cr
#' It does this for one specific table in a dataset. \cr \cr
#'
#' @param Dataset This is the dataModel field of the json
#' @param n The Dataset number (as a json can have multiple datasets)
#' @return A dataframe for that specific table, including data label, description and type.
#' @importFrom CHECK LATER
#'

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
