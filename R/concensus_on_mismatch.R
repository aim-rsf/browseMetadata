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
    ses_join$Domain_code_join[datavar] <- decision_output$decision
    ses_join$Note_join[datavar] <- decision_output$decision_note
    } else {
      ses_join$Domain_code_join[datavar] <- ses_join$Domain_code_ses1[datavar]
      ses_join$Note_join[datavar] <- 'No mismatch!'
    }

}
