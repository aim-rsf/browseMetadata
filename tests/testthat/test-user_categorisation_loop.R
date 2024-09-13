Output <- get("Output")
Code <- data.frame(Code = 0:2)
df_plots <- list(Code = Code,'')

test_that("user_categorisation_loop handles auto categorisation", {
  # Mock data
  selectTable_df <- data.frame(Label = c("Element1", "Element2"), Description = c("Desc1", "Desc2"), Type = c("Type1", "Type2"))
  lookup <- data.frame(DataElement = c("Element1", "Element2"), DomainCode = c(1, 2))

  # Call the function
  result <- user_categorisation_loop(1, 2, selectTable_df, FALSE, data.frame(), lookup, df_plots, Output)

  # Check the result
  expect_equal(nrow(result), 2)
  expect_equal(result$Note[1], "AUTO CATEGORISED")
  expect_equal(result$Note[2], "AUTO CATEGORISED")
})

test_that("user_categorisation_loop handles copying from previous table", {
  # Mock data
  selectTable_df <- data.frame(Label = c("Element1", "Element2"), Description = c("Desc1", "Desc2"), Type = c("Type1", "Type2"))
  df_prev <- data.frame(DataElement = c("Element1", "Element2"), Domain_code = c(1, 2), Table = c("PrevTable1", "PrevTable2"))
  lookup <- data.frame(DataElement = c("Element3", "Element4"), DomainCode = c(3, 4))

  # Call the function
  result <- user_categorisation_loop(1, 2, selectTable_df, TRUE, df_prev, lookup, df_plots, Output)

  # Check the result
  expect_equal(nrow(result), 2)
  expect_equal(result$Note[1], "COPIED FROM: PrevTable1")
  expect_equal(result$Note[2], "COPIED FROM: PrevTable2")
})

test_that("user_categorisation_loop handles user categorisation", {
  # Mock data
  selectTable_df <- data.frame(Label = c("Element1", "Element2"), Description = c("Desc1", "Desc2"), Type = c("Type1", "Type2"))
  lookup <- data.frame(DataElement = c("Element3", "Element4"), DomainCode = c(3, 4))

  # Mock the user_categorisation function
  mock_user_categorisation <- mock(list(decision = "1", decision_note = "User note"), cycle = TRUE)
  stub(user_categorisation_loop, "user_categorisation", mock_user_categorisation)

  # Call the function
  result <- user_categorisation_loop(1, 2, selectTable_df, FALSE, data.frame(), lookup, df_plots, Output)

  # Check the result
  expect_equal(nrow(result), 2)
  expect_equal(result$Note[1], "User note")
  expect_equal(result$Domain_code[1], "1")
})
