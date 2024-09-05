user_categorisation_loop <- function(start_v,end_v,Table_df,df_prev_exist,df_prev,lookup,df_plots,Output) {

  for (data_v in start_v:end_v) {
    cat("\n \n")
    cli_alert_info(paste(length(data_v:end_v), 'left to process'))
    cli_alert_info("Data element {data_v} of {nrow(Table_df)}")
    this_DataElement <- Table_df$Label[data_v]
    this_DataElement_N <- paste(as.character(data_v), 'of',
                                as.character(nrow(Table_df)))
    data_v_index <- which(lookup$DataElement ==
                            Table_df$Label[data_v]) #we should code this to ignore the case
    lookup_subset <- lookup[data_v_index, ]
    ##### search if data element matches any data elements from previous table
    if (df_prev_exist == TRUE) {
      data_v_index <- which(df_prev$DataElement ==
                              Table_df$Label[data_v])
      df_prev_subset <- df_prev[data_v_index, ]
    } else {
      df_prev_subset <- data.frame()
    }
    ##### decide how to process the data element out of 3 options
    if (nrow(lookup_subset) == 1) {
      ###### 1 - auto categorisation
      Output <- Output %>% add_row(
        DataElement = this_DataElement,
        DataElement_N = this_DataElement_N,
        Domain_code = as.character(lookup_subset$DomainCode),
        Note = 'AUTO CATEGORISED'
      )
    } else if (df_prev_exist == TRUE &
               nrow(df_prev_subset) == 1) {
      ###### 2 - copy from previous table
      Output <- Output %>% add_row(
        DataElement = this_DataElement,
        DataElement_N = this_DataElement_N,
        Domain_code = as.character(df_prev_subset$Domain_code),
        Note = paste0("COPIED FROM: ", df_prev_subset$Table)
      )
    } else {
      ###### 3 - collect user responses with 'user_categorisation.R'
      decision_output <- user_categorisation(
        Table_df$Label[data_v],
        Table_df$Description[data_v],
        Table_df$Type[data_v],
        max(df_plots$Code$Code)
      )
      Output <- Output %>% add_row(
        DataElement = this_DataElement,
        DataElement_N = this_DataElement_N,
        Domain_code = decision_output$decision,
        Note = decision_output$decision_note
      )
    }
  } # end of loop for DataElement
  Output
}
