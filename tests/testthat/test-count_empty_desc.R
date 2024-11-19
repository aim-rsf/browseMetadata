# load libraries
library(testthat) # test_that, expect_equal
library(tidyr)

test_that("count_empty_desc correctly counts empty descriptions", {
  # Sample input data frame
  table_df <- data.frame(
    label = c("var1", "var2", "var3", "var4", "var5"),
    description = c("Description to follow", "Valid description", "NA", "Another valid description", " "),
    type = c("VARCHAR", "BIGINT", "DATE", "TIMESTAMP", "VARCHAR"),
    stringsAsFactors = FALSE
  )

  # Expected output data frame
  expected_output <- tibble(
    empty = c("No", "Yes"),
    table_colname = c(2, 3)
  )

  # Call the function
  result <- count_empty_desc(table_df, "table_colname")

  # Check if the result matches the expected output
  expect_equal(result, expected_output)
})
