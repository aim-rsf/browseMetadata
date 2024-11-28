#' map_metadata_compare
#'
#' This function is to be used after running the map_metadata function. \cr \cr
#' It compares csv outputs from two sessions, finds their differences, and asks for a consensus. \cr \cr
#'
#' @param session_dir This directory should contain 2 csv files for each session (LOG_ and OUTPUT_), 4 csv files in total.
#' @param session1_base Base file name for session 1 e.g. 'NationalCommunityChildHealthDatabase(NCCHD)_BLOOD_TEST_2024-07-05-16-07-38'
#' @param session2_base Base file name for session 2 e.g. 'NationalCommunityChildHealthDatabase(NCCHD)_BLOOD_TEST_2024-07-08-12-03-30'
#' @param json_file The full path to the metadata file used when running map_metadata (should be the same for session 1 and session 2)
#' @param domain_file The full path to the domain file used when running map_metadata (should be the same for session 1 and session 2)
#' @return It returns a csv output, which represents the consensus decisions between session 1 and session 2
#' @export
#' @importFrom utils read.csv write.csv
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_success
#' @examples
#' \dontrun{
#' # Locate file paths for the example files in the package
#' session_dir <- system.file("outputs", package = "browseMetadata")
#' session1_base <- "NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-19-55"
#' session2_base <- "NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-23-52"
#' json_file <- system.file("inputs", "national_community_child_health_database_(ncchd)_20240405T130125.json", package = "browseMetadata")
#' domain_file <- system.file("inputs", "domain_list_demo.csv", package = "browseMetadata")
#'
#' # Run the function - requires user interaction
#' map_metadata_compare(
#'   session_dir = session_dir,
#'   session1_base = session1_base,
#'   session2_base = session2_base,
#'   json_file = json_file,
#'   domain_file = domain_file
#' )}

map_metadata_compare <- function(session_dir, session1_base, session2_base, json_file, domain_file) {
  timestamp_now_fname <- format(Sys.time(), "%Y-%m-%d-%H-%M-%S")

  # DEFINE INPUTS ----

  csv_1a <- read.csv(paste0(session_dir, "/", "LOG_", session1_base, ".csv"))
  csv_2a <- read.csv(paste0(session_dir, "/", "LOG_", session2_base, ".csv"))
  csv_1b <- read.csv(paste0(session_dir, "/", "OUTPUT_", session1_base, ".csv"))
  csv_2b <- read.csv(paste0(session_dir, "/", "OUTPUT_", session2_base, ".csv"))

  meta_json <- fromJSON(json_file)
  domains <- read.csv(domain_file, header = FALSE)

  dataset <- meta_json$dataModel
  dataset_name <- dataset$label

  # VALIDATION CHECKS ----

  ## Use 'valid_comparison.R' to check if sessions can be compared to each other and to the json (min requirements):

  valid_comparison(
    input_1 = csv_1a$dataset[1],
    input_2 = csv_2a$dataset[1],
    severity = "danger",
    severity_text = "Session 1 and 2 have different datasets"
  )

  valid_comparison(
    input_1 = csv_1a$table[1],
    input_2 = csv_2a$table[1],
    severity = "danger",
    severity_text = "Session 1 and 2 have different tables"
  )

  valid_comparison(
    input_1 = csv_1a$dataset[1],
    input_2 = dataset_name,
    severity = "danger",
    severity_text = "Different dataset to json"
  )

  valid_comparison(
    input_1 = nrow(csv_1b),
    input_2 = nrow(csv_2b),
    severity = "danger",
    severity_text = "Different number of data elements!"
  )

  ##  Use 'valid_comparison.R' to check the sessions can be compared to each other and to the json (warnings for user to check):

  valid_comparison(
    input_1 = csv_1a$browseMetadata[1],
    input_2 = csv_2a$browseMetadata[1],
    severity = "warning",
    severity_text = "Different version of browseMetadata package!"
  )

  valid_comparison(
    input_1 = csv_1a$metadata_version[1],
    input_2 = csv_2a$metadata_version[1],
    severity = "warning",
    severity_text = "Different metadata versions!"
  )

  valid_comparison(
    input_1 = csv_1a$metadata_version[1],
    input_2 = dataset$documentationVersion,
    severity = "warning",
    severity_text = "The version files do not match the json (different metadata versions)!"
  )

  valid_comparison(
    input_1 = csv_1a$metadata_last_updated[1],
    input_2 = csv_2a$metadata_last_updated[1],
    severity = "warning",
    severity_text = "Different metadata date!"
  )

  valid_comparison(
    input_1 = csv_1a$metadata_last_updated[1],
    input_2 = dataset$lastUpdated,
    severity = "warning",
    severity_text = "The session files do not match the json (different dates for metadata)!"
  )

  # DISPLAY TO USER ----

  ## Use 'ref_plot.R' to plot domains for the user's ref (save df for later use)
  df_plots <- ref_plot(domains)

  # EXTRACT TABLE INFO FROM METADATA JSON ----

  ## Use 'json_table_to_df.R' to extract table from meta_json into a df
  table_find <- data.frame(table_n = numeric(length(dataset$childDataClasses)), table_label = character(length(dataset$childDataClasses)))
  for (t in 1:length(dataset$childDataClasses)) {
    table_find$table_n[t] <- t
    table_find$table_label[t] <- dataset$childDataClasses$label[t]
  }
  table_n <- table_find$table_n[table_find$table_label == csv_1a$table[1]]

  table_df <- json_table_to_df(dataset = meta_json$data, n = table_n)

  # JOIN DATAFRAMES FROM SESSIONS IN ORDER TO COMPARE ----
  ses_join <- join_outputs(session_1 = csv_1b, session_2 = csv_2b)

  # FIND MISMATCHES AND ASK FOR CONCENSUS DECISION ----
  for (datavar in 1:nrow(ses_join)) {
    consensus <- concensus_on_mismatch(ses_join, table_df, datavar, max(df_plots$code$code))
    ses_join$domain_code_join[datavar] <- consensus$domain_code_join
    ses_join$note_join[datavar] <- consensus$note_join
  } # end of loop for DataElement

  # SAVE TO NEW CSV ----
  output_fname <- paste0("CONSENSUS_OUTPUT_", gsub(" ", "", dataset_name), "_", table_find$table_label[table_n], "_", timestamp_now_fname, ".csv")
  write.csv(ses_join, output_fname, row.names = FALSE)
  cat("\n")
  cli_alert_success("Your consensus categorisations have been saved to {output_fname}")
}
