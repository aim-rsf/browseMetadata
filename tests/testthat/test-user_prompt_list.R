# load libraries
library(testthat) # test_that, expect_equal
library(mockery) # mock, stub

test_that("user_prompt_list works with valid input", {
  mock_scan <- mock(c(1, 2, 3), cycle = TRUE)  # create a mock object that returns a list of integers when called, cycling the same value
  stub(user_prompt_list, "scan", mock_scan)  # replace `scan` function within the `user_prompt_list` function with the `mock_scan` mock object

  response <- user_prompt_list(prompt_text = "Enter numbers: ", list_allowed = 1:5, empty_allowed = FALSE)
  expect_equal(response, c(1, 2, 3))
})

test_that("user_prompt_list handles out of range input and then valid input", {
  mock_scan <- mock(c(6, 7, 8), c(1, 2, 3))  # create a mock object that returns out-of-range values first, then valid values
  stub(user_prompt_list, "scan", mock_scan)  # replace `scan` function within the `user_prompt_list` function with the `mock_scan` mock object

  response <- user_prompt_list(prompt_text = "Enter numbers: ", list_allowed = 1:5, empty_allowed = FALSE)
  expect_equal(response, c(1, 2, 3))  # expect the valid input after the out-of-range input
})

test_that("user_prompt_list handles empty input when not allowed", {
  mock_scan <- mock(integer(0), c(1, 2, 3))  # create a mock object that returns an empty list first, then valid values
  stub(user_prompt_list, "scan", mock_scan)  # replace `scan` function within the `user_prompt_list` function with the `mock_scan` mock object

  response <- user_prompt_list(prompt_text = "Enter numbers: ", list_allowed = 1:5, empty_allowed = FALSE)
  expect_equal(response, c(1, 2, 3))  # expect the valid input after the empty input
})

test_that("user_prompt_list handles empty input when allowed", {
  mock_scan <- mock(integer(0), cycle = TRUE)  # create a mock object that returns an empty list when called, cycling the same value
  stub(user_prompt_list, "scan", mock_scan)  # replace `scan` function within the `user_prompt_list` function with the `mock_scan` mock object

  response <- user_prompt_list(prompt_text = "Enter numbers: ", list_allowed = 1:5, empty_allowed = TRUE)
  expect_equal(response, integer(0))  # expect an empty list
})
