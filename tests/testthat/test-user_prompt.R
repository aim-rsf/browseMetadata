# libraries: testthat

test_that("user_prompt works with any_keys = TRUE", {
  local_mocked_bindings(readline = function(prompt) {response <- "test_response"})
  response <- user_prompt(prompt_text = "Enter something: ", any_keys = TRUE)
  expect_equal(response, "test_response")
})

test_that("user_prompt works with any_keys = FALSE and response is y/Y", {
  local_mocked_bindings(readline = function(prompt) {response <- "Y"})
  response <- user_prompt(prompt_text = "Enter y/n: ", any_keys = FALSE)
  expect_equal(response, "Y")
})

test_that("user_prompt works with any_keys = FALSE and response is n/N", {
  local_mocked_bindings(readline = function(prompt) {response <- "n"})
  response <- user_prompt(prompt_text = "Enter y/n: ", any_keys = FALSE)
  expect_equal(response, "n")
})

test_that("user_prompt throws error with invalid any_keys", {
  expect_error(
    user_prompt(prompt_text = "Enter something: ", any_keys = "invalid"),
    "Invalid input given for 'any_keys'. Only TRUE or FALSE are allowed."
  )
})

test_that("user_prompt handles empty input initially", {
  local_mocked_bindings(
    readline = function(prompt) {
      if (!exists("call_count")) {
        call_count <<- 0
      }
      call_count <<- call_count + 1
      if (call_count == 1) {
        return("")
      } else {
        return("test_response")
      }
    }
  )
  response <- user_prompt(prompt_text = "Enter something: ", any_keys = TRUE)
  expect_equal(response, "test_response")
})

test_that("user_prompt handles invalid input for any_keys = FALSE", {
  local_mocked_bindings(
    readline = function(prompt) {
      if (!exists("call_count")) {
        call_count <<- 0
      }
      call_count <<- call_count + 1
      if (call_count == 1) {
        return("invalid")
      } else {
        return("Y")
      }
    }
  )
  response <- user_prompt(prompt_text = "Enter y/n: ", any_keys = FALSE)
  expect_equal(response, "Y")
})
