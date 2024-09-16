# Unit test for ref_plot function
testthat::test_that("ref_plot function works correctly", {
  # Mock input dataframe
  domains <- data.frame(Domains = c("Domain1", "Domain2", "Domain3", "Domain4"))

  # Call the function
  result <- ref_plot(domains)

  # Check the structure of the result
  testthat::expect_true(is.list(result))
  testthat::expect_true("Code" %in% names(result))
  testthat::expect_true("Domain_table" %in% names(result))

  # Check the content of the Code dataframe
  testthat::expect_equal(nrow(result$Code), 8)
  testthat::expect_equal(result$Code$Code, 0:7)

  # Check the content of the Domain_table
  testthat::expect_true(inherits(result$Domain_table, "gtable"))
  testthat::expect_equal(nrow(result$Domain_table), 9)
  testthat::expect_equal(result$Domain_table$layout$name[1], "colhead-fg")
})
