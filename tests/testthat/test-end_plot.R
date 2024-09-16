testthat::test_that("end_plot function works correctly", {
  # Sample data frame
  df <- get("Output")

  df <- df %>% dplyr::add_row(
    timestamp = format(Sys.time(), "%Y-%m-%d-%H-%M-%S"),
    Table = 'Sample Table',
    DataElement = 'DataElement 1',
    DataElement_N = '1 of 2',
    Domain_code = '1',
    Note = 'AUTO CATEGORISED'
  )

  df <- df %>% dplyr::add_row(
    timestamp = format(Sys.time(), "%Y-%m-%d-%H-%M-%S"),
    Table = 'Sample Table',
    DataElement = 'DataElement 2',
    DataElement_N = '2 of 2',
    Domain_code = '3',
    Note = 'DEMOGRAPHICS'
  )

  # Sample reference table
  domains_extend <- rbind(c("*NO MATCH / UNSURE*"), c("*METADATA*"), c("*ID*"), c("*DEMOGRAPHICS*"), c("Domain A"),c("Domain B"))
  Code <- data.frame(Code = 0:(nrow(domains_extend) - 1))
  ref_table <- gridExtra::tableGrob(cbind(Code,domains_extend),rows = NULL,theme = ttheme_default())

  # Call the function
  result <- end_plot(df, "Sample Table", ref_table)

  # Check if the result is a gtable object
  testthat::expect_s3_class(result, "gtable")
})
