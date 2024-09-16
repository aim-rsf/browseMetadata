testthat::test_that("user_prompt works with any_keys = TRUE", {
  mock_readline <- mockery::mock("test_response")  # create a mock object that returns a string when called
  mockery::stub(user_prompt, "readline", mock_readline) # replace `readline` function within the `user_prompt` function with the `mock_readline` mock object
  response <- user_prompt(prompt_text = "Enter something: ", any_keys = TRUE)
  testthat::expect_equal(response, "test_response")
})

testthat::test_that("user_prompt works with any_keys = FALSE and response is y/Y", {
  mock_readline <- mockery::mock("Y")
  mockery::stub(user_prompt, "readline", mock_readline)

  response <- user_prompt(prompt_text = "Enter y/n: ", any_keys = FALSE)
  testthat::expect_equal(response, "Y")
})

testthat::test_that("user_prompt works with any_keys = FALSE and response is n/N", {
  mock_readline <- mockery::mock("n")
  mockery::stub(user_prompt, "readline", mock_readline)

  response <- user_prompt(prompt_text = "Enter y/n: ", any_keys = FALSE)
  testthat::expect_equal(response, "n")
})

testthat::test_that("user_prompt throws error with invalid any_keys", {
  testthat::expect_error(user_prompt(prompt_text = "Enter something: ", any_keys = "invalid"),
               "Invalid input given for 'any_keys'. Only TRUE or FALSE are allowed.")
})

testthat::test_that("user_prompt handles empty input initially", {
  mock_readline <- mockery::mock("", "test_response")
  mockery::stub(user_prompt, "readline", mock_readline)

  response <- user_prompt(prompt_text = "Enter something: ", any_keys = TRUE)
  testthat::expect_equal(response, "test_response")
})

testthat::test_that("user_prompt handles invalid input for any_keys = FALSE", {
  mock_readline <- mockery::mock("invalid", "Y")
  mockery::stub(user_prompt, "readline", mock_readline)

  response <- user_prompt(prompt_text = "Enter y/n: ", any_keys = FALSE)
  testthat::expect_equal(response, "Y")
})




