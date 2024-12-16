# libraries: testthat, mockery

output_df <- get("output_df")
code <- data.frame(code = 0:2)
df_plots <- list(code = code, "")

test_that("user_categorisation_loop handles auto categorisation", {
  # Mock data
  table_df <- data.frame(label = c("Element1", "Element2"), description = c("Desc1", "Desc2"), type = c("Type1", "Type2"))
  lookup <- data.frame(data_element = c("Element1", "Element2"), domain_code = c(1, 2))

  # Call the function
  result <- user_categorisation_loop(1, 2, table_df, FALSE, data.frame(), lookup, df_plots, output_df)

  # Check the result
  expect_equal(nrow(result), 2)
  expect_equal(result$note[1], "AUTO CATEGORISED")
  expect_equal(result$note[2], "AUTO CATEGORISED")
})

test_that("user_categorisation_loop handles copying from previous table", {
  # Mock data
  table_df <- data.frame(label = c("Element1", "Element2"), description = c("Desc1", "Desc2"), type = c("Type1", "Type2"))
  df_prev <- data.frame(data_element = c("Element1", "Element2"), domain_code = c(1, 2), table = c("PrevTable1", "PrevTable2"))
  lookup <- data.frame(data_element = c("Element3", "Element4"), domain_code = c(3, 4))

  # Call the function
  result <- user_categorisation_loop(1, 2, table_df, TRUE, df_prev, lookup, df_plots, output_df)

  # Check the result
  expect_equal(nrow(result), 2)
  expect_equal(result$note[1], "COPIED FROM: PrevTable1")
  expect_equal(result$note[2], "COPIED FROM: PrevTable2")
})

test_that("user_categorisation_loop handles user categorisation", {
  # Mock data
  table_df <- data.frame(label = c("Element1", "Element2"), description = c("Desc1", "Desc2"), type = c("Type1", "Type2"))
  lookup <- data.frame(data_element = c("Element3", "Element4"), domain_code = c(3, 4))

  # Mock the user_categorisation function
  mock_user_categorisation <- mock(list(decision = "1", decision_note = "User note"), cycle = TRUE)
  stub(user_categorisation_loop, "user_categorisation", mock_user_categorisation)

  # Call the function
  result <- user_categorisation_loop(1, 2, table_df, FALSE, data.frame(), lookup, df_plots, output_df)

  # Check the result
  expect_equal(nrow(result), 2)
  expect_equal(result$note[1], "User note")
  expect_equal(result$domain_code[1], "1")
})
