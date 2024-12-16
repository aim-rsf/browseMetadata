test_that("valid_comparison function works correctly", {
  # Test invalid severity
  expect_error(
    valid_comparison(1, 1, "info", "Invalid severity test"),
    "Invalid severity. Only 'danger' and 'warning' are allowed."
  )

  # Test danger severity with different inputs
  expect_error(
    valid_comparison(1, 2, "danger", "Different inputs test"),
    "Exiting!"
  )

  # Test warning severity with different inputs
  expect_message(
    valid_comparison(1, 2, "warning", "Different inputs test"),
    "Continuing but please check comparison is valid!"
  )

  # Test danger severity with same inputs
  expect_silent(valid_comparison(1, 1, "danger", "Same inputs test"))

  # Test warning severity with same inputs
  expect_silent(valid_comparison(1, 1, "warning", "Same inputs test"))
})
