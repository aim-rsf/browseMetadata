# load libraries
library(testthat) # test_that, expect_equal

test_that("count_empty_desc correctly counts empty descriptions", {

  # Sample input data frame
  Table_df <- data.frame(
    Label = c("var1", "var2", "var3", "var4","var5"),
    Description = c("Description to follow", "Valid description", "NA", "Another valid description"," "),
    Type = c("VARCHAR", "BIGINT", "DATE", "TIMESTAMP", "VARCHAR"),
    stringsAsFactors = FALSE
  )

  # Expected output data frame
  expected_output <- tibble(
    Empty = c("No", "Yes"),
    Table_colname = c(2, 3)
  )

  # Call the function
  result <- count_empty_desc(Table_df, "Table_colname")

  # Check if the result matches the expected output
  expect_equal(result, expected_output)
})
