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
