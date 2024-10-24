library(testthat) #test_that, expect_true
library(rjson)

test_that("browseMetadata function outputs files correctly", {

  # Setup
  temp_dir <- tempdir()
  example_json_file <- system.file('inputs/national_community_child_health_database_(ncchd)_20240405T130125.json',package = "browseMetadata")

  # Execution
  result <- browseMetadata(json_file = example_json_file, output_dir = temp_dir)

  # Verification of file outputs
  Dataset <- fromJSON(file = example_json_file)$dataModel
  Dataset_Name <- Dataset$label
  dataset_version <- fromJSON(file = example_json_file)[["dataModel"]][["documentationVersion"]]

  table_file <- file.path(temp_dir, paste0("BROWSE_table_", gsub(" ", "", Dataset_Name), "_V", dataset_version, ".html"))
  bar_file_html <- file.path(temp_dir, paste0("BROWSE_bar_", gsub(" ", "", Dataset_Name), "_V", dataset_version, ".html"))
  bar_file_csv <- file.path(temp_dir, paste0("BROWSE_bar_", gsub(" ", "", Dataset_Name), "_V", dataset_version, ".csv"))

  expect_true(file.exists(table_file))
  expect_true(file.exists(bar_file_html))
  expect_true(file.exists(bar_file_csv))

  # Verify some features of the CSV file
  bar_csv <- read.csv(bar_file_csv)
  expect_true(nrow(bar_csv) == 26)
  expect_true(ncol(bar_csv) == 3)
  expect_true(sum(bar_csv$N_Variables) == 318)

  # Teardown
  unlink(c(table_file, bar_file_html, bar_file_csv))
})


