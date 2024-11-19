# load libraries
library(testthat) # test_that, expect_equal
library(mockery) # mock, stub

test_that("user_categorisation works with valid input", {
  mock_readline <- mock("3", "This is a note", "n") # create a mock object that returns user inputs in sequence
  stub(user_categorisation, "readline", mock_readline) # replace `readline` function within the `user_categorisation` function with the `mock_readline` mock object

  response <- user_categorisation(data_element = "Element1", data_desc = "Description1", data_type = "Type1", domain_code_max = 5)
  expect_equal(response, list(decision = "3", decision_note = "This is a note"))
})

test_that("user_categorisation handles invalid input and then valid input", {
  mock_readline <- mock("6", "3", "This is a note", "n") # create a mock object that returns invalid input first, then valid input
  stub(user_categorisation, "readline", mock_readline) # replace `readline` function within the `user_categorisation` function with the `mock_readline` mock object

  response <- user_categorisation(data_element = "Element1", data_desc = "Description1", data_type = "Type1", domain_code_max = 5)
  expect_equal(response, list(decision = "3", decision_note = "This is a note"))
})

test_that("user_categorisation handles multiple valid inputs", {
  mock_readline <- mock("3,4", "This is another note", "n") # create a mock object that returns multiple valid inputs
  stub(user_categorisation, "readline", mock_readline) # replace `readline` function within the `user_categorisation` function with the `mock_readline` mock object

  response <- user_categorisation(data_element = "Element1", data_desc = "Description1", data_type = "Type1", domain_code_max = 5)
  expect_equal(response, list(decision = "3,4", decision_note = "This is another note"))
})

test_that("user_categorisation handles re-do input", {
  mock_readline <- mock("3", "This is a note", "y", "4", "Another note", "n") # create a mock object that returns inputs including re-do
  stub(user_categorisation, "readline", mock_readline) # replace `readline` function within the `user_categorisation` function with the `mock_readline` mock object

  response <- user_categorisation(data_element = "Element1", data_desc = "Description1", data_type = "Type1", domain_code_max = 5)
  expect_equal(response, list(decision = "4", decision_note = "Another note"))
})
