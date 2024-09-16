# Mock user_categorisation function
mock_user_categorisation <- function(data_element, data_desc, data_type, domain_code_max) {
  return(list(decision = "mock_decision", decision_note = "mock_note"))
}

testthat::test_that("concensus_on_mismatch handles mismatch correctly", {
  # Mock data
  ses_join <- data.frame(
    Domain_code_ses1 = c("1", "1,2"),
    Domain_code_ses2 = c("1", "2"),
    DataElement = c("Element1", "Element2"),
    Note_ses1 = c("Note1", "Note2"),
    Note_ses2 = c("Note3", "Note4"),
    stringsAsFactors = FALSE
  )

  Table_df <- data.frame(
    Label = c("Element1", "Element2"),
    Description = c("Description1", "Description2"),
    Type = c("Type1", "Type2"),
    stringsAsFactors = FALSE
  )

  datavar <- 2
  domain_code_max <- 5

  # Stub the user_categorisation function
  mockery::stub(concensus_on_mismatch, "user_categorisation", mock_user_categorisation)

  # Call the function
  result <- concensus_on_mismatch(ses_join, Table_df, datavar, domain_code_max)

  # Check the result
  testthat::expect_equal(result$Domain_code_join, "mock_decision")
  testthat::expect_equal(result$Note_join, "mock_note")
})

testthat::test_that("concensus_on_mismatch handles no mismatch correctly", {
  # Mock data
  ses_join <- data.frame(
    Domain_code_ses1 = c("2", "2,4"),
    Domain_code_ses2 = c("2", "2,4"),
    DataElement = c("Element1", "Element2"),
    Note_ses1 = c("Note1", "Note2"),
    Note_ses2 = c("Note3", "Note4"),
    stringsAsFactors = FALSE
  )

  Table_df <- data.frame(
    Label = c("Element1", "Element2"),
    Description = c("Description1", "Description2"),
    Type = c("Type1", "Type2"),
    stringsAsFactors = FALSE
  )

  datavar <- 2
  domain_code_max <- 5

  # Call the function
  result <- concensus_on_mismatch(ses_join, Table_df, datavar, domain_code_max)

  # Check the result
  testthat::expect_equal(result$Domain_code_join, "2,4")
  testthat::expect_equal(result$Note_join, "No mismatch!")
})
