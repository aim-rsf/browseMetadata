# Unit test for ref_plot function
test_that("ref_plot function works correctly", {
  # Mock input dataframe
  domains <- data.frame(Domains = c("Domain1", "Domain2", "Domain3", "Domain4"))

  # Call the function
  result <- ref_plot(domains)

  # Check the structure of the result
  expect_true(is.list(result))
  expect_true("Code" %in% names(result))
  expect_true("Domain_table" %in% names(result))

  # Check the content of the Code dataframe
  expect_equal(nrow(result$Code), 8)
  expect_equal(result$Code$Code, 0:7)

  # Check the content of the Domain_table
  expect_true(inherits(result$Domain_table, "gtable"))
  expect_equal(nrow(result$Domain_table), 9)
  expect_equal(result$Domain_table$layout$name[1], "colhead-fg")
})
