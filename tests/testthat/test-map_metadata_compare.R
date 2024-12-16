# libraries: testthat, mockery, withr

test_that("map_metadata function works correctly with user input", {
  # Setup
  temp_dir <- local_tempdir()

  demo_session_dir <- system.file("outputs", package = "browseMetadata")
  demo_session1_base <- "NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-19-55"
  demo_session2_base <- "NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-23-52"
  demo_json_file <- system.file("inputs", "national_community_child_health_database_(ncchd)_20240405T130125.json", package = "browseMetadata")
  demo_domain_file <- system.file("inputs", "domain_list_demo.csv", package = "browseMetadata")

  # mock concensus_on_mismatch
  mock_concensus_on_mismatch <- function(ses_join, table_df, datavar, domain_code_max) {
    domain_code_join <- "0"
    note_join <- "concensus note"
    return(list(domain_code_join = domain_code_join, note_join = note_join))
  }

  # Use mockery::stub to mock functions
  stub(map_metadata_compare, "concensus_on_mismatch", mock_concensus_on_mismatch)

  # Run the function - requires user interaction
  map_metadata_compare(
    session_dir = demo_session_dir,
    session1_base = demo_session1_base,
    session2_base = demo_session2_base,
    json_file = demo_json_file,
    domain_file = demo_domain_file,
    output_dir = temp_dir
  )

  consensus_files <- list.files(temp_dir, pattern = "^CONSENSUS_", full.names = TRUE)
  concensus_df <- read.csv(consensus_files[1])
  demo_1_df <- read.csv(paste0(demo_session_dir, "/", "OUTPUT_", demo_session1_base, ".csv"))
  demo_2_df <- read.csv(paste0(demo_session_dir, "/", "OUTPUT_", demo_session2_base, ".csv"))

  expect_equal(nrow(concensus_df), 20)
  expect_equal(ncol(concensus_df), 13)
  expect_true(all(concensus_df$domain_code_join == 0))
  expect_true(all(concensus_df$note_join == "concensus note"))
  expect_equal(demo_1_df$data_element, concensus_df$data_element)
  expect_equal(demo_2_df$data_element, concensus_df$data_element)
  expect_equal(demo_1_df$timestamp, concensus_df$timestamp_ses1)
  expect_equal(demo_1_df$table, concensus_df$table_ses1)
  expect_equal(demo_1_df$data_element_n, concensus_df$data_element_n_ses1)
  expect_equal(demo_1_df$domain_code, concensus_df$domain_code_ses1)
  expect_equal(demo_1_df$note, concensus_df$note_ses1)
  expect_equal(demo_2_df$timestamp, concensus_df$timestamp_ses2)
  expect_equal(demo_2_df$table, concensus_df$table_ses2)
  expect_equal(demo_2_df$data_element_n, concensus_df$data_element_n_ses2)
  expect_equal(demo_2_df$domain_code, concensus_df$domain_code_ses2)
  expect_equal(demo_2_df$note, concensus_df$note_ses2)
})
