# load libraries
library(testthat) # test_that, expect_equal

# Create sample data (only allow it to be different on timestamp, Domain_code and Note)
session_1 <- data.frame(
  timestamp = c("2024-08-22-13-26-33", "2024-08-22-13-26-33", "2024-08-22-13-26-33"),
  table = c("HEALTH","HEALTH","HEALTH"),
  data_element = c("ALF_E", "AVAIL_FROM_DT", "OUTCOME"),
  data_element_n = c("1 of 3", "2 of 3", "3 of 3"),
  domain_code = c("1", "1", "5"),
  note = c("ID", "Metadata", "Diagnostic category")
  )

session_2 <- data.frame(
  timestamp = c("2024-08-22-15-24-30", "2024-08-22-15-24-30", "2024-08-22-15-24-30"),
  table = c("HEALTH","HEALTH","HEALTH"),
  data_element = c("ALF_E", "AVAIL_FROM_DT", "OUTCOME"),
  data_element_n = c("1 of 3", "2 of 3", "3 of 3"),
  domain_code = c("1", "1", "4"),
  note = c("ID", "info about data", "diagnosis")
)

# Define expected outputs
expected_output_ses1_ses2 <- data.frame(
  timestamp_ses1 = c("2024-08-22-13-26-33", "2024-08-22-13-26-33", "2024-08-22-13-26-33"),
  table_ses1 = c("HEALTH","HEALTH","HEALTH"),
  data_element_n_ses1 = c("1 of 3", "2 of 3", "3 of 3"),
  domain_code_ses1 = c("1", "1", "5"),
  note_ses1 = c("ID", "Metadata", "Diagnostic category"),
  timestamp_ses2 = c("2024-08-22-15-24-30", "2024-08-22-15-24-30", "2024-08-22-15-24-30"),
  table_ses2 = c("HEALTH","HEALTH","HEALTH"),
  data_element_n_ses2 = c("1 of 3", "2 of 3", "3 of 3"),
  domain_code_ses2 = c("1", "1", "4"),
  note_ses2 = c("ID", "info about data", "diagnosis"),
  data_element = c("ALF_E", "AVAIL_FROM_DT", "OUTCOME"),
  domain_code_join = c(NA, NA, NA),
  note_join = c(NA, NA, NA)
)

expected_output_ses1_ses1 <- data.frame(
  timestamp_ses1 = c("2024-08-22-13-26-33", "2024-08-22-13-26-33", "2024-08-22-13-26-33"),
  table_ses1 = c("HEALTH","HEALTH","HEALTH"),
  data_element_n_ses1 = c("1 of 3", "2 of 3", "3 of 3"),
  domain_code_ses1 = c("1", "1", "5"),
  note_ses1 = c("ID", "Metadata", "Diagnostic category"),
  timestamp_ses2 = c("2024-08-22-13-26-33", "2024-08-22-13-26-33", "2024-08-22-13-26-33"),
  table_ses2 = c("HEALTH","HEALTH","HEALTH"),
  data_element_n_ses2 = c("1 of 3", "2 of 3", "3 of 3"),
  domain_code_ses2 = c("1", "1", "5"),
  note_ses2 = c("ID", "Metadata", "Diagnostic category"),
  data_element = c("ALF_E", "AVAIL_FROM_DT", "OUTCOME"),
  domain_code_join = c(NA, NA, NA),
  note_join = c(NA, NA, NA)
)

# Write the test
test_that("join_outputs works correctly", {
  result <- join_outputs(session_1, session_1)
  expect_equal(result, expected_output_ses1_ses1)
  result <- join_outputs(session_1,session_2)
  expect_equal(result, expected_output_ses1_ses2)
  })

