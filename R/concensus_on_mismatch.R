#' concensus_on_mismatch
#'
#' This function is called within the map_metadata_compare function. \cr \cr
#' For a specific data element, it compares the domain code categorisation between two sessions.
#' If the categorisation differs, it prompts the user for a new consensus decision by presenting the json metadata. \cr \cr
#'
#' @param ses_join The joined dataframes from the two sessions
#' @param Table_df Metadata from the json file, for one table in the dataset
#' @param datavar Data Element n
#' @param domain_code_max The maximum allowable domain code integer
#' @return It returns a list of 2: the domain code and the note from the consensus decision
#' @importFrom cli cli_alert_info

concensus_on_mismatch <- function(ses_join,Table_df,datavar,domain_code_max){

  if (ses_join$Domain_code_ses1[datavar] != ses_join$Domain_code_ses2[datavar]){
    cat("\n\n")
    cli_alert_info("Mismatch of DataElement {ses_join$DataElement[datavar]}")
    cat(paste(
      "\nDOMAIN CODE (note) for session 1 --> ",ses_join$Domain_code_ses1[datavar],'(',ses_join$Note_ses1[datavar],')',
      "\nDOMAIN CODE (note) for session 2 --> ",ses_join$Domain_code_ses2[datavar],'(',ses_join$Note_ses2[datavar],')'
      ))
    cat("\n\n")
    cli_alert_info("Provide concensus decision for this DataElement:")
    decision_output <- user_categorisation(Table_df$Label[datavar],Table_df$Description[datavar],Table_df$Type[datavar],domain_code_max)
    Domain_code_join <- decision_output$decision
    Note_join <- decision_output$decision_note
    } else {
      Domain_code_join <- ses_join$Domain_code_ses1[datavar]
      Note_join <- 'No mismatch!'
    }
  return(list(Domain_code_join = Domain_code_join, Note_join = Note_join))
}
