# used in browseMetadata_compare_outputs

join_outputs <- function(session_1, session_2){

  ses_join <- left_join(session_1,session_2,suffix = c("_ses1","_ses2"),join_by(DataElement))
  ses_join$Domain_code_join <- NA
  ses_join$Note_join <- NA
  ses_join <- select(ses_join,
                     'timestamp_ses1','timestamp_ses2',
                     'DataElement_N_ses1','DataElement_N_ses2',
                     'Domain_code_ses1','Domain_code_ses2',
                     'Note_ses1','Note_ses2',
                     'Domain_code_join','Note_join')

  ses_join
}
