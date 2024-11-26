# load libraries
library(testthat) # test_that, expect_equal, expect_true
library(mockery) # mock, stub

# Unit test for ref_plot function
test_that("ref_plot function works correctly", {
  # Mock input dataframe
  domains <- data.frame(Domains = c("Domain1", "Domain2", "Domain3", "Domain4"))

  # Call the function
  result <- ref_plot(domains)

  # Check the structure of the result
  expect_true(is.list(result))
  expect_true("code" %in% names(result))
  expect_true("domain_table" %in% names(result))

  # Check the content of the code dataframe
  expect_equal(nrow(result$code), 8)
  expect_equal(result$code$code, 0:7)

  # Check the content of the Domain_table
  expect_true(inherits(result$domain_table, "gtable"))
  expect_equal(nrow(result$domain_table), 9)
  expect_equal(result$domain_table$layout$name[1], "colhead-fg")
})
