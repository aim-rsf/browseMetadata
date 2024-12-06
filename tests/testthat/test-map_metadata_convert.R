library(testthat) # test_that, expect_true


test_that("map_metadata_convert function outputs files correctly", {
  # Setup
  temp_dir <- tempdir()
  file_in <- system.file("outputs/OUTPUT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-19-55.csv", package = "browseMetadata")
  file_out <- system.file("outputs/L-OUTPUT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-19-55.csv", package = "browseMetadata")

  # Copy the demo input file to the temporary directory
  file.copy(file_in, file.path(temp_dir, basename(file_in)))

  # Run the function
  map_metadata_convert(output_csv = basename(file_in), output_dir = temp_dir)

  # Read the expected and actual output files
  expected_output <- read.csv(file_out)
  actual_output <- read.csv(file.path(temp_dir, paste0("L-", basename(file_in))))

  # Test that the outputs are the same
  expect_equal(actual_output, expected_output)

})
