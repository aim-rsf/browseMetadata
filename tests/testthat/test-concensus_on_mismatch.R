test_that("concensus_on_mismatch handles mismatch correctly", {
  # Mock the user_categorisation function
  local_mocked_bindings(user_categorisation = function(data_element = NULL, data_desc = NULL, data_type = NULL, domain_code_max = NULL) {
    return(list(decision = "mock_decision", decision_note = "mock_note"))
  })

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
