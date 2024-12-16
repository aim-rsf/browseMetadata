# libraries: testthat, withr

test_that("map_metadata function works correctly with user input", {
  # Setup
  temp_dir <- local_tempdir()

  demo_log_output <- system.file("outputs/LOG_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-19-55.csv", package = "browseMetadata")
  demo_output <- system.file("outputs/OUTPUT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-19-55.csv", package = "browseMetadata")

  # Mock functions
  local_mocked_bindings(
    readline = function(prompt) {
    response <- switch(prompt,
      "Press any key to continue " = "", # line 109 in map_metadata
      "Optional free text note about this table (or press enter to continue): " = "demo run" # line 109 in map_metadata
    )
  })

  local_mocked_bindings(
    user_prompt = function(prompt_text, any_keys) {
    if (prompt_text == "Enter your initials: ") { # line 93 in map_metadata
      response <- "demo"
    } else if (prompt_text == "Would you like to review your categorisations? (y/n): ") { # line 238 in map_metadata
      response <- "n"
    }
    return(response)
  })

  local_mocked_bindings(
  user_categorisation_loop = function(start_v, end_v, table_df, df_prev_exist, df_prev, lookup, df_plots, output_df) {
    output_df <- read.csv(demo_output)
    output_df$timestamp <- NA
    output_df$table <- NA
    return(output_df)
  })

  local_mocked_bindings(
  user_prompt_list = function(prompt_text, list_allowed, empty_allowed) {
    if (grepl("Enter row numbers for those you want to edit:", prompt_text)) {
      return(list()) # return an empty list for the auto categorised data elements prompt
    }
    return(list(2)) # return a list with '2' which means choosing the table CHILD
  })

  # Run the map_metadata function
  map_metadata(output_dir = temp_dir, table_copy = FALSE)

  # Dynamically determine the filenames generated during the test run
  log_file <- list.files(temp_dir, pattern = "LOG_NationalCommunityChildHealthDatabase\\(NCCHD\\)_CHILD_.*\\.csv", full.names = TRUE)
  output_file <- list.files(temp_dir, pattern = "OUTPUT_NationalCommunityChildHealthDatabase\\(NCCHD\\)_CHILD_.*\\.csv", full.names = TRUE)

  # Read the expected and actual output files
  expected_log_output <- read.csv(demo_log_output)
  actual_log_output <- read.csv(log_file)

  expected_output <- read.csv(demo_output)
  actual_output <- read.csv(output_file)

  # Remove the timestamp and package version columns for comparison
  expected_log_output$timestamp <- NULL
  actual_log_output$timestamp <- NULL
  expected_log_output$browseMetadata <- NULL
  actual_log_output$browseMetadata <- NULL
  expected_output$timestamp <- NULL
  actual_output$timestamp <- NULL

  # Test that the outputs are the same
  expect_equal(actual_log_output, expected_log_output)
  expect_equal(actual_output, expected_output)
})
