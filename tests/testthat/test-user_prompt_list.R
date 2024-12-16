# libraries: testthat

test_that("user_prompt_list works with valid input", {
  local_mocked_bindings(scan = function(file = "",what = 0){return(c(1,2,3))})
  response <- user_prompt_list(prompt_text = "Enter numbers: ", list_allowed = 1:5, empty_allowed = FALSE)
  expect_equal(response, c(1, 2, 3))
})

test_that("user_prompt_list handles out of range input and then valid input", {
    local_mocked_bindings(
    scan = function(file = "", what = 0) {
      if (!exists("call_count")) {
        call_count <<- 0
      }
      call_count <<- call_count + 1
      if (call_count == 1) {
        return(c(6, 7, 8))
      } else {
        return(c(1, 2, 3))
      }
    }
  )
  response <- user_prompt_list(prompt_text = "Enter numbers: ", list_allowed = 1:5, empty_allowed = FALSE)
  expect_equal(response, c(1, 2, 3)) # expect the valid input after the out-of-range input
})


test_that("user_prompt_list handles empty input when not allowed", {
  local_mocked_bindings(
    scan = function(file = "", what = 0) {
      if (!exists("call_count")) {
        call_count <<- 0
      }
      call_count <<- call_count + 1
      if (call_count == 1) {
        return(integer(0))
      } else {
        return(c(1, 2, 3))
      }
    }
  )
  response <- user_prompt_list(prompt_text = "Enter numbers: ", list_allowed = 1:5, empty_allowed = FALSE)
  expect_equal(response, c(1, 2, 3)) # expect the valid input after the empty input
})

test_that("user_prompt_list handles empty input when allowed", {
  local_mocked_bindings(
    scan = function(file = "", what = 0) {
      return(integer(0))
    }
  )
  response <- user_prompt_list(prompt_text = "Enter numbers: ", list_allowed = 1:5, empty_allowed = TRUE)
  expect_equal(response, integer(0)) # expect an empty list
})
