test_that("end_plot function works correctly", {
  # Sample data frame
  df <- get("output_df")

  df <- df %>% dplyr::add_row(
    timestamp = format(Sys.time(), "%Y-%m-%d-%H-%M-%S"),
    table = "Sample Table",
    data_element = "DataElement 1",
    data_element_n = "1 of 2",
    domain_code = "1",
    note = "AUTO CATEGORISED"
  )

  df <- df %>% dplyr::add_row(
    timestamp = format(Sys.time(), "%Y-%m-%d-%H-%M-%S"),
    table = "Sample Table",
    data_element = "DataElement 2",
    data_element_n = "2 of 2",
    domain_code = "3",
    note = "DEMOGRAPHICS"
  )

  # Sample reference table
  domains_extend <- rbind(c("*NO MATCH / UNSURE*"), c("*METADATA*"), c("*ID*"), c("*DEMOGRAPHICS*"), c("Domain A"), c("Domain B"))
  code <- data.frame(code = 0:(nrow(domains_extend) - 1))
  ref_table <- gridExtra::tableGrob(cbind(code, domains_extend), rows = NULL, theme = gridExtra::ttheme_default())

  # Call the function
  result <- end_plot(df, "Sample Table", ref_table)

  # Check if the result is a gtable object
  expect_s3_class(result, "gtable")
})
