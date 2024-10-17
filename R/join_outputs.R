#' join_outputs
#'
#' This function is called within the mapMetadata_compare_outputs function. \cr \cr
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
