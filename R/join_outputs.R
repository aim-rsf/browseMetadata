# used in browseMetadata_compare_outputs

join_outputs <- function(session_1, session_2){

  ses_join <- left_join(session_1,session_2,suffix = c("_ses1","_ses2"),join_by(DataElement))
  ses_join <- select(ses_join,contains("_ses"),'DataElement')
  ses_join$Domain_code_join <- NA
  ses_join$Note_join <- NA
  ses_join
}
