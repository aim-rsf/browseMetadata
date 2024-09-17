# load libraries
library(testthat) # test_that, expect_equal

# Create sample data (only allow it to different on timestamp, Domain_code and Note)
session_1 <- data.frame(
  timestamp = c("2024-08-22-13-26-33", "2024-08-22-13-26-33", "2024-08-22-13-26-33"),
  Table = c("HEALTH","HEALTH","HEALTH"),
  DataElement = c("ALF_E", "AVAIL_FROM_DT", "OUTCOME"),
  DataElement_N = c("1 of 3", "2 of 3", "3 of 3"),
  Domain_code = c("1", "1", "5"),
  Note = c("ID", "Metadata", "Diagnostic category")
  )

session_2 <- data.frame(
  timestamp = c("2024-08-22-15-24-30", "2024-08-22-15-24-30", "2024-08-22-15-24-30"),
  Table = c("HEALTH","HEALTH","HEALTH"),
  DataElement = c("ALF_E", "AVAIL_FROM_DT", "OUTCOME"),
  DataElement_N = c("1 of 3", "2 of 3", "3 of 3"),
  Domain_code = c("1", "1", "4"),
  Note = c("ID", "info about data", "diagnosis")
)

# Define expected outputs
expected_output_ses1_ses2 <- data.frame(
  timestamp_ses1 = c("2024-08-22-13-26-33", "2024-08-22-13-26-33", "2024-08-22-13-26-33"),
  Table_ses1 = c("HEALTH","HEALTH","HEALTH"),
  DataElement_N_ses1 = c("1 of 3", "2 of 3", "3 of 3"),
  Domain_code_ses1 = c("1", "1", "5"),
  Note_ses1 = c("ID", "Metadata", "Diagnostic category"),
  timestamp_ses2 = c("2024-08-22-15-24-30", "2024-08-22-15-24-30", "2024-08-22-15-24-30"),
  Table_ses2 = c("HEALTH","HEALTH","HEALTH"),
  DataElement_N_ses2 = c("1 of 3", "2 of 3", "3 of 3"),
  Domain_code_ses2 = c("1", "1", "4"),
  Note_ses2 = c("ID", "info about data", "diagnosis"),
  DataElement = c("ALF_E", "AVAIL_FROM_DT", "OUTCOME"),
  Domain_code_join = c(NA, NA, NA),
  Note_join = c(NA, NA, NA)
)

expected_output_ses1_ses1 <- data.frame(
  timestamp_ses1 = c("2024-08-22-13-26-33", "2024-08-22-13-26-33", "2024-08-22-13-26-33"),
  Table_ses1 = c("HEALTH","HEALTH","HEALTH"),
  DataElement_N_ses1 = c("1 of 3", "2 of 3", "3 of 3"),
  Domain_code_ses1 = c("1", "1", "5"),
  Note_ses1 = c("ID", "Metadata", "Diagnostic category"),
  timestamp_ses2 = c("2024-08-22-13-26-33", "2024-08-22-13-26-33", "2024-08-22-13-26-33"),
  Table_ses2 = c("HEALTH","HEALTH","HEALTH"),
  DataElement_N_ses2 = c("1 of 3", "2 of 3", "3 of 3"),
  Domain_code_ses2 = c("1", "1", "5"),
  Note_ses2 = c("ID", "Metadata", "Diagnostic category"),
  DataElement = c("ALF_E", "AVAIL_FROM_DT", "OUTCOME"),
  Domain_code_join = c(NA, NA, NA),
  Note_join = c(NA, NA, NA)
)

# Write the test
test_that("join_outputs works correctly", {
  result <- join_outputs(session_1, session_1)
  expect_equal(result, expected_output_ses1_ses1)
  result <- join_outputs(session_1,session_2)
  expect_equal(result, expected_output_ses1_ses2)
  })

