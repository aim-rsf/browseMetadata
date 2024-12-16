# libraries: testthat

test_that("user_categorisation works with valid input", {
  local_mocked_bindings(
    readline = function(prompt) {
      if (!exists("call_count")) {
        call_count <<- 0
      }
      call_count <<- call_count + 1
      if (call_count == 1) {
        return("3")
      } else if (call_count == 2) {
        return("This is a note")
      } else {
        return("n")
      }
    }
  )
  response <- user_categorisation(data_element = "Element1", data_desc = "Description1", data_type = "Type1", domain_code_max = 5)
  expect_equal(response, list(decision = "3", decision_note = "This is a note"))
})

test_that("user_categorisation handles invalid input and then valid input", {
  local_mocked_bindings(
    readline = function(prompt) {
      if (!exists("call_count")) {
        call_count <<- 0
      }
      call_count <<- call_count + 1
      if (call_count == 1) {
        return("6")
      } else if (call_count == 2) {
        return("3")
      } else if (call_count == 3) {
        return("This is a note")
      } else {
        return("n")
      }
    }
  )
  response <- user_categorisation(data_element = "Element1", data_desc = "Description1", data_type = "Type1", domain_code_max = 5)
  expect_equal(response, list(decision = "3", decision_note = "This is a note"))
})

test_that("user_categorisation handles multiple valid inputs", {
  local_mocked_bindings(
    readline = function(prompt) {
      if (!exists("call_count")) {
        call_count <<- 0
      }
      call_count <<- call_count + 1
      if (call_count == 1) {
        return("3,4")
      } else if (call_count == 2) {
        return("This is another note")
      } else {
        return("n")
      }
    }
  )
  response <- user_categorisation(data_element = "Element1", data_desc = "Description1", data_type = "Type1", domain_code_max = 5)
  expect_equal(response, list(decision = "3,4", decision_note = "This is another note"))
})

test_that("user_categorisation handles re-do input", {
  local_mocked_bindings(
    readline = function(prompt) {
      if (!exists("call_count")) {
        call_count <<- 0
      }
      call_count <<- call_count + 1
      if (call_count == 1) {
        return("3")
      } else if (call_count == 2) {
        return("This is a note")
      } else if (call_count == 3) {
        return("y")
      } else if (call_count == 4) {
        return("4")
      } else if (call_count == 5) {
        return("Another note")
      } else {
        return("n")
      }
    }
  )
  response <- user_categorisation(data_element = "Element1", data_desc = "Description1", data_type = "Type1", domain_code_max = 5)
  expect_equal(response, list(decision = "4", decision_note = "Another note"))
})
