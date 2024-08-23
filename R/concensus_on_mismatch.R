concensus_on_mismatch <- function(ses_join,Table_df,datavar){

  if (ses_join$Domain_code_ses1[datavar] != ses_join$Domain_code_ses2[datavar]){
    cat("\n\n")
    cli_alert_info("Mismatch of DataElement {ses_join$DataElement[datavar]}")
    cat(paste(
      "\nDOMAIN CODE (note) for session 1 --> ",ses_join$Domain_code_ses1[datavar],'(',ses_join$Note_ses1[datavar],')',
      "\nDOMAIN CODE (note) for session 2 --> ",ses_join$Domain_code_ses2[datavar],'(',ses_join$Note_ses2[datavar],')'
      ))
    cat("\n\n")
    cli_alert_info("Provide concensus decision for this DataElement:")
    decision_output <- user_categorisation(Table_df$Label[datavar],Table_df$Description[datavar],Table_df$Type[datavar],max(Code$Code))
    Domain_code_join <- decision_output$decision
    Note_join <- decision_output$decision_note
    } else {
      Domain_code_join <- ses_join$Domain_code_ses1[datavar]
      Note_join <- 'No mismatch!'
    }
  return(list(Domain_code_join = Domain_code_join, Note_join = Note_join))
}
