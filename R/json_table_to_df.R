
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
