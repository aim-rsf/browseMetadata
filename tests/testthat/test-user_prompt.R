# libraries: testthat, mockery

test_that("user_prompt works with any_keys = TRUE", {
  mock_readline <- mock("test_response") # create a mock object that returns a string when called
  stub(user_prompt, "readline", mock_readline) # replace `readline` function within the `user_prompt` function with the `mock_readline` mock object
  response <- user_prompt(prompt_text = "Enter something: ", any_keys = TRUE)
  expect_equal(response, "test_response")
})

test_that("user_prompt works with any_keys = FALSE and response is y/Y", {
  mock_readline <- mock("Y")
  stub(user_prompt, "readline", mock_readline)

  response <- user_prompt(prompt_text = "Enter y/n: ", any_keys = FALSE)
  expect_equal(response, "Y")
})

test_that("user_prompt works with any_keys = FALSE and response is n/N", {
  mock_readline <- mock("n")
  stub(user_prompt, "readline", mock_readline)

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
  mock_readline <- mock("", "test_response")
  stub(user_prompt, "readline", mock_readline)

  response <- user_prompt(prompt_text = "Enter something: ", any_keys = TRUE)
  expect_equal(response, "test_response")
})

test_that("user_prompt handles invalid input for any_keys = FALSE", {
  mock_readline <- mock("invalid", "Y")
  stub(user_prompt, "readline", mock_readline)

  response <- user_prompt(prompt_text = "Enter y/n: ", any_keys = FALSE)
  expect_equal(response, "Y")
})
