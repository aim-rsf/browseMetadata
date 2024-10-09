# load libraries
library(testthat) # test_that, expect_equal

# Define the mock json
mock_Dataset <- list(
  childDataClasses = list(
    list(
      childDataElements = list(
        list(ID = "111", label = "Label1", description = "Description1", dataType = list(ID = "a", label = "Type1")),
        list(ID = "112", label = "Label2", description = "Description2", dataType = list(ID = "b", label = "Type2"))
      )
    ),
    list(
      childDataElements = list(
        list(ID = "111", label = "Label3", description = "Description3", dataType = list(ID = "c", label = "Type1")),
        list(ID = "112", label = "Label4", description = "Description4", dataType = list(ID = "d", label = "Type3"))
      )
    )
  )
)

test_that("json_table_to_df gives expected output for first index", {
  result <- json_table_to_df(mock_Dataset, 1)

  expected <- data.frame(
    Label = c("Label1", "Label2"),
    Description = c("Description1", "Description2"),
    Type = c("Type1", "Type2")
  )

  expect_equal(result, expected)
})

test_that("json_table_to_df gives expected output for second index", {
  result <- json_table_to_df(mock_Dataset, 2)

  expected <- data.frame(
    Label = c("Label3", "Label4"),
    Description = c("Description3", "Description4"),
    Type = c("Type1", "Type3")
  )

  expect_equal(result, expected)
})
