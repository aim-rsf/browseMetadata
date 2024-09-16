test_that("copy_previous works correctly when there are files to copy from", {
  # Create a temporary directory
  temp_dir <- tempdir()

  # Create test CSV files
  # Criteria for test files: one must have 'AUTO CATEGORISED' as Note, overlap in DataElements across files, different timestamps across files)
  utils::write.csv(data.frame(timestamp = "2024-08-22-13-35-40", DataElement = c("DataElement1","DataElement2"), Note = c("note1","note2")),
            file = file.path(temp_dir, "OUTPUT_TestDataset_1.csv"), row.names = FALSE)
  utils::write.csv(data.frame(timestamp = "2024-09-22-13-00-05", DataElement = c("DataElement1","DataElement3"), Note = c("note3","note4")),
            file = file.path(temp_dir, "OUTPUT_TestDataset_2.csv"), row.names = FALSE)
  utils::write.csv(data.frame(timestamp = "2024-10-22-11-12-02", DataElement = c("DataElement4","DataElement2"), Note = c("AUTO CATEGORISED","note5")),
            file = file.path(temp_dir, "OUTPUT_TestDataset_3.csv"), row.names = FALSE)

  # Call the function
  result <- copy_previous("TestDataset", temp_dir)

  # Check the results
  testthat::expect_true(result$df_prev_exist)
  testthat::expect_equal(nrow(result$df_prev), 3)
  testthat::expect_equal(result$df_prev$timestamp, c("2024-08-22-13-35-40", "2024-08-22-13-35-40","2024-09-22-13-00-05"))
  testthat::expect_equal(result$df_prev$DataElement, c("DataElement1", "DataElement2","DataElement3"))
  testthat::expect_equal(result$df_prev$Note, c("note1", "note2","note4"))

  # Clean up
  unlink(temp_dir, recursive = TRUE)
})

test_that("copy_previous works correctly when there are no files to copy from", {
  # Create a temporary directory
  temp_dir <- tempdir()

  # Call the function
  result <- copy_previous("TestDataset", temp_dir)

  # Check the results
  testthat::expect_null(result$df_prev)
  testthat::expect_false(result$df_prev_exist)

  # Clean up
  unlink(temp_dir, recursive = TRUE)
})
