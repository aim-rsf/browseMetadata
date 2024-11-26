# load libraries
library(testthat) # test_that, expect_equal
library(mockery) # stub

# Mock user_categorisation function
mock_user_categorisation <- function(data_element, data_desc, data_type, domain_code_max) {
  return(list(decision = "mock_decision", decision_note = "mock_note"))
}

test_that("concensus_on_mismatch handles mismatch correctly", {
  # Mock data
  ses_join <- data.frame(
    domain_code_ses1 = c("1", "1,2"),
    domain_code_ses2 = c("1", "2"),
    data_element = c("Element1", "Element2"),
    note_ses1 = c("Note1", "Note2"),
    note_ses2 = c("Note3", "Note4"),
    stringsAsFactors = FALSE
  )

  table_df <- data.frame(
    label = c("Element1", "Element2"),
    description = c("Description1", "Description2"),
    type = c("Type1", "Type2"),
    stringsAsFactors = FALSE
  )

  datavar <- 2
  domain_code_max <- 5

  # Stub the user_categorisation function
  stub(concensus_on_mismatch, "user_categorisation", mock_user_categorisation)

  # Call the function
  result <- concensus_on_mismatch(ses_join, table_df, datavar, domain_code_max)

  # Check the result
  expect_equal(result$domain_code_join, "mock_decision")
  expect_equal(result$note_join, "mock_note")
})

test_that("concensus_on_mismatch handles no mismatch correctly", {
  # Mock data
  ses_join <- data.frame(
    domain_code_ses1 = c("2", "2,4"),
    domain_code_ses2 = c("2", "2,4"),
    data_element = c("Element1", "Element2"),
    note_ses1 = c("Note1", "Note2"),
    note_ses2 = c("Note3", "Note4"),
    stringsAsFactors = FALSE
  )

  table_df <- data.frame(
    label = c("Element1", "Element2"),
    description = c("Description1", "Description2"),
    type = c("Type1", "Type2"),
    stringsAsFactors = FALSE
  )

  datavar <- 2
  domain_code_max <- 5

  # Call the function
  result <- concensus_on_mismatch(ses_join, table_df, datavar, domain_code_max)

  # Check the result
  expect_equal(result$domain_code_join, "2,4")
  expect_equal(result$note_join, "No mismatch!")
})
