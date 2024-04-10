#' compare_csv_outputs
#'
#' This function is to be used after running the domain_mapping function. \cr \cr
#' It compares two csv outputs, finds their differences, and asks for a consensus. \cr \cr
#'
#' @param csv_file_1 CSV output file from running domain_mapping
#' @param csv_file_2 CSV output file from running domain_mapping (different to csv_file_1)
#' @param json_file The metadata file used when running domain_mapping (should be the same for csv_file_1 and csv_file_2)
#' @return It returns csv_3, with consensus decisions
#' @importFrom dplyr left_join select join_by
#' @export

compare_csv_outputs <- function(csv_file_1,csv_file_2,json_file) {

  timestamp_now <- gsub(" ", "_", Sys.time())
  timestamp_now <- gsub(":", "-", timestamp_now)

  # read in input files
  csv_1 <- read.csv(csv_file_1)
  csv_2 <- read.csv(csv_file_2)
  meta_json <- rjson::fromJSON(file = json_file)

  # check the csv files can be compared
  if (csv_1$MetaDataVersion[1] != csv_2$MetaDataVersion[1]){
    cat("\n\n")
    cli_alert_danger("Cannot compare csv 1 and csv 2: different metadata versions")
    stop()}

  if (csv_1$MetaDataLastUpdated[1] != csv_2$MetaDataLastUpdated[1]){
    cat("\n\n")
    cli_alert_danger("Cannot compare csv 1 and csv 2: different dates for metadata")
    stop()}

  if (csv_1$DomainListDesc[1] != csv_2$DomainListDesc[1]){
    cat("\n\n")
    cli_alert_danger("Cannot compare csv 1 and csv 2: different domain lists")
    stop()}

  if (csv_1$Dataset[1] != csv_2$Dataset[1]){
    cat("\n\n")
    cli_alert_danger("Cannot compare csv 1 and csv 2: different datasets")
    stop()}

  if (csv_1$Table[1] != csv_2$Table[1]){
    cat("\n\n")
    cli_alert_danger("Cannot compare csv 1 and csv 2: different tables")
    stop()}

  if (length(csv_1) != length(csv_2)){
    cat("\n\n")
    cli_alert_warning("Different number of rows in csv 1 and csv 2 - please check")}

  # check the csv files can be compared to the meta_json
  if (csv_1$MetaDataVersion[1] != meta_json$dataModel$documentationVersion){
    cat("\n\n")
    cli_alert_danger("The csv files do not match the json: different metadata versions")
    stop()}

  if (csv_1$MetaDataLastUpdated[1] != meta_json$dataModel$lastUpdated){
    cat("\n\n")
    cli_alert_danger("The csv files do not match the json: different dates for metadata")
    stop()}

  if (csv_1$Dataset[1] != meta_json$dataModel$label){
    cat("\n\n")
    cli_alert_danger("The csv files do not match the json: different datasets")
    stop()}

  # print details about each csv
  cat("\n\n")
  cli_alert_success("Comparing csv 1 and csv 2")
  cli_alert_success("csv_1 -> {csv_file_1}")
  cli_alert_success("csv_2 -> {csv_file_2}")
  cli_alert_success("csv_1 created by {csv_1$Initials[1]} and csv_2 created by {csv_2$Initials[2]}")

  # join csv_1 and csv_2 in order to compare
  csv_join <- left_join(csv_1,csv_2,suffix = c("_csv1","_csv2"),join_by(MetaDataVersion,MetaDataLastUpdated,DomainListDesc,Dataset,Table,DataElement))
  csv_join$Domain_code_join <- NA
  csv_join$Note_join <- NA
  csv_join <- select(csv_join,2,3,4,5,6,7,1,8,9,10,11,12,13,14)

  # extract table from meta_json - same code as domain_mapping
  table_find <- data.frame(table_n = numeric(length(meta_json$dataModel$childDataClasses)),table_label = character(length(meta_json$dataModel$childDataClasses)))
  for (t in 1:length(meta_json$dataModel$childDataClasses)) {
    table_find$table_n[t] = t
    table_find$table_label[t] = meta_json$dataModel$childDataClasses[[t]]$label
  }

  table_n = table_find$table_n[table_find$table_label == csv_1$Table[1]]
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
  for (datavar in 1:nrow(csv_join)) {
    cat("\n \n")
      # collect user responses
    if (csv_join$Domain_code_csv1[datavar] != csv_join$Domain_code_csv2[datavar]){
      cat("\n\n")
      cli_alert_info("Mismatch of DataElement {csv_join$DataElement[datavar]}")
      cat(paste(
        "\nDOMAIN CODE (note) for csv 1 --> ",csv_join$Domain_code_csv1[datavar],'(',csv_join$Note_csv1[datavar],')',
        "\nDOMAIN CODE (note) for csv 2 --> ",csv_join$Domain_code_csv2[datavar],'(',csv_join$Note_csv2[datavar],')'
      ))
      cat("\n\n")
      cli_alert_info("Provide concensus decision for this DataElement:")
      decision_output <- user_categorisation(selectTable_df$Label[datavar],selectTable_df$Description[datavar],selectTable_df$Type[datavar])
      csv_join$Domain_code_join <- decision_output$decision
      csv_join$Note_join <- decision_output$decision_note
    } else {
      csv_join$Domain_code_join <- csv_join$Domain_code_csv1[datavar]
      csv_join$Note_join <- 'No mismatch'
    }
  } # end of loop for DataElement

  # save to new csv
  output_fname <- paste0("CONCENSUS_LOG_", gsub(" ", "", meta_json$dataModel$label), "_", table_find$table_label[table_n], "_", timestamp_now, ".csv")
  utils::write.csv(csv_join, output_fname, row.names = FALSE)
  cat("\n")
  cli_alert_success("Your concensus categorisations have been saved to {output_fname}")
}
