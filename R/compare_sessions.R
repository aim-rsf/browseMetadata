#' compare_sessions
#'
#' This function is to be used after running the domain_mapping function. \cr \cr
#' It compares csv outputs from two sessions, finds their differences, and asks for a consensus. \cr \cr
#'
#' @param session_dir This directory should contain 2 csv files for each session (LOG_ and OUTPUT_), 4 csv files in total.
#' @param session1_base Base file name for session 1 e.g. 'NationalCommunityChildHealthDatabase(NCCHD)_BLOOD_TEST_2024-07-05-16-07-38'
#' @param session2_base Base file name for session 1 e.g. 'NationalCommunityChildHealthDatabase(NCCHD)_BLOOD_TEST_2024-07-08-12-03-30'
#' @param json_file The full path to the metadata file used when running domain_mapping (should be the same for session 1 and session 2)
#' @param domain_file The full path to the domain file used when running domain_mapping (should be the same for session 1 and session 2)
#' @return It returns a csv output, which represents the consensus decisions between session 1 and session 2
#' @importFrom dplyr left_join select join_by
#' @export

compare_sessions <- function(session_dir,session1_base,session2_base,json_file,domain_file) {

  timestamp_now <- gsub(" ", "_", Sys.time())
  timestamp_now <- gsub(":", "-", timestamp_now)

  # read in the input files:

  csv_1a <- read.csv(paste0(session_dir,'/','LOG_',session1_base,'.csv'))
  csv_2a <- read.csv(paste0(session_dir,'/','LOG_',session2_base,'.csv'))
  csv_1b <- read.csv(paste0(session_dir,'/','OUTPUT_',session1_base,'.csv'))
  csv_2b <- read.csv(paste0(session_dir,'/','OUTPUT_',session2_base,'.csv'))
  meta_json <- rjson::fromJSON(file = json_file)
  domains <- read.csv(domain_file, header = FALSE)

  # check the session csvs can be compared to each other and to the json (min requirements):

  if (csv_1a$Dataset[1] != csv_2a$Dataset[1]){
    cat("\n\n")
    cli_alert_danger("Cannot compare session 1 and 2: different datasets")
    stop()}

  if (csv_1a$Table[1] != csv_2a$Table[1]){
    cat("\n\n")
    cli_alert_danger("Cannot compare session 1 and 2: different tables")
    stop()}

  if (csv_1a$Dataset[1] != meta_json$dataModel$label){
    cat("\n\n")
    cli_alert_danger("The csv files do not match the json: different datasets")
    stop()}

  # check the session csvs can be compared to each other and to the json (warnings for user to check):

  if (csv_1a$browseMetadata[1] != csv_2a$browseMetadata[1]){
    cat("\n\n")
    cli_alert_warning("Different version of browseMetadata for session 1 and 2!\nValid comparison may not be possible - please check!")
    continue <- readline("Press enter to continue or Esc to cancel: ")}

  if (csv_1a$MetaDataVersion[1] != csv_2a$MetaDataVersion[1]){
    cat("\n\n")
    cli_alert_warning("Different metadata versions for session 1 and 2\nValid comparison may not be possible - please check!")
    continue <- readline("Press enter to continue or Esc to cancel: ")}

  if (csv_1a$MetaDataVersion[1] != meta_json$dataModel$documentationVersion){
    cat("\n\n")
    cli_alert_warning("The session files do not match the json (different metadata versions)\nValid comparison may not be possible - please check!")
    continue <- readline("Press enter to continue or Esc to cancel: ")}

  if (csv_1a$MetaDataLastUpdated[1] != csv_2a$MetaDataLastUpdated[1]){
    cat("\n\n")
    cli_alert_warning("Different metadata date for session 1 and 2\nValid comparison may not be possible - please check!")
    continue <- readline("Press enter to continue or Esc to cancel: ")}

  if (csv_1a$MetaDataLastUpdated[1] != meta_json$dataModel$lastUpdated){
    cat("\n\n")
    cli_alert_warning("The session files do not match the json (different dates for metadata)\nValid comparison may not be possible - please check!")
    continue <- readline("Press enter to continue or Esc to cancel: ")}

  if (nrow(csv_1b) != nrow(csv_2b)){
    cat("\n\n")
    cli_alert_warning("Different number of data elements for session 1 and 2\nValid comparison may not be possible - please check!")
    continue <- readline("Press enter to continue or Esc to cancel: ")}

  # print details about each session
  cat("\n\n")
  cli_alert_success("Comparing session 1 and session 2")
  cli_alert_success("Session 1 created by {csv_1a$Initials[1]} and session 2 created by {csv_2a$Initials[1]}")

  # Present domains plots panel for user's reference (as in domain_mapping)
  colnames(domains)[1] = "Domain Name"
  graphics::plot.new()
  domains_extend <- rbind(c("*NO MATCH / UNSURE*"), c("*METADATA*"), c("*ID*"), c("*DEMOGRAPHICS*"), domains)
  Code <- data.frame(Code = 0:(nrow(domains_extend) - 1))
  Domain_table <- tableGrob(cbind(Code,domains_extend),rows = NULL,theme = ttheme_default())
  grid.arrange(Domain_table,nrow=1,ncol=1)

  # join csv_1b and csv_2b in order to compare
  ses_join <- left_join(csv_1b,csv_2b,suffix = c("_ses1","_ses2"),join_by(DataElement))
  ses_join$Domain_code_join <- NA
  ses_join$Note_join <- NA
  ses_join <- select(ses_join,
                     'timestamp_ses1','timestamp_ses2',
                     'DataElement_N_ses1','DataElement_N_ses2',
                     'Domain_code_ses1','Domain_code_ses2',
                     'Note_ses1','Note_ses2',
                     'Domain_code_join','Note_join')

  # extract table from meta_json - same code as domain_mapping
  table_find <- data.frame(table_n = numeric(length(meta_json$dataModel$childDataClasses)),table_label = character(length(meta_json$dataModel$childDataClasses)))
  for (t in 1:length(meta_json$dataModel$childDataClasses)) {
    table_find$table_n[t] = t
    table_find$table_label[t] = meta_json$dataModel$childDataClasses[[t]]$label
  }

  table_n = table_find$table_n[table_find$table_label == csv_1a$Table[1]]
  thisTable <- meta_json$dataModel$childDataClasses[[table_n]]$childDataElements
  thisTable_df <- data.frame(do.call(rbind, thisTable)) # nested list to dataframe
  dataType_df <- data.frame(do.call(rbind, thisTable_df$dataType)) # nested list to dataframe

  selectTable_df <- data.frame(
    Label = unlist(thisTable_df$label),
    Description = unlist(thisTable_df$description),
    Type = unlist(dataType_df$label)
  )

  selectTable_df <- selectTable_df[order(selectTable_df$Label), ]

  # find the mismatches and ask for consensus decisions
  for (datavar in 1:nrow(ses_join)) {
      # collect user responses
    if (ses_join$Domain_code_ses1[datavar] != ses_join$Domain_code_ses2[datavar]){
      cat("\n\n")
      cli_alert_info("Mismatch of DataElement {ses_join$DataElement[datavar]}")
      cat(paste(
        "\nDOMAIN CODE (note) for session 1 --> ",ses_join$Domain_code_ses1[datavar],'(',ses_join$Note_ses1[datavar],')',
        "\nDOMAIN CODE (note) for session 2 --> ",ses_join$Domain_code_ses2[datavar],'(',ses_join$Note_ses2[datavar],')'
      ))
      cat("\n\n")
      cli_alert_info("Provide concensus decision for this DataElement:")
      decision_output <- user_categorisation(selectTable_df$Label[datavar],selectTable_df$Description[datavar],selectTable_df$Type[datavar],max(Code$Code))
      ses_join$Domain_code_join[datavar] <- decision_output$decision
      ses_join$Note_join[datavar] <- decision_output$decision_note
    } else {
      ses_join$Domain_code_join[datavar] <- ses_join$Domain_code_ses1[datavar]
      ses_join$Note_join[datavar] <- 'No mismatch!'
    }
  } # end of loop for DataElement

  # save to new csv
  output_fname <- paste0("CONCENSUS_OUTPUT_", gsub(" ", "", meta_json$dataModel$label), "_", table_find$table_label[table_n], "_", timestamp_now, ".csv")
  utils::write.csv(ses_join, output_fname, row.names = FALSE)
  cat("\n")
  cli_alert_success("Your concensus categorisations have been saved to {output_fname}")
}
