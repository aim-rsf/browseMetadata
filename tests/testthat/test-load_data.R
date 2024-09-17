# Define file paths to demo data relative to the package directory
json_file <- system.file("inputs/national_community_child_health_database_(ncchd)_20240405T130125.json", package = "browseMetadata")
look_up_file <- system.file("inputs/look_up.csv", package = "browseMetadata")
domains_file <- system.file("inputs/domain_list_demo.csv", package = "browseMetadata")

# Define package demo data
json <- get("json_metadata")
look_up <- get("look_up")
domains <- get("domain_list")

testthat::test_that("load_data runs in demo mode when both json_file and domain_file are NULL", {
  result <- load_data(NULL, NULL, NULL)
  testthat::expect_true(result$demo_mode)
  testthat::expect_equal(result$meta_json, json)
  testthat::expect_equal(result$domains, domains)
  testthat::expect_equal(result$DomainListDesc, "DemoList")
})

testthat::test_that("load_data throws error if only one of json_file or domain_file is NULL", {
  testthat::expect_error(load_data(json_file, NULL, NULL))
  testthat::expect_error(load_data(NULL, domains_file, NULL))
})

testthat::test_that("load_data reads user-specified files correctly", {
  result <- load_data(json_file, domains_file, NULL)
  testthat::expect_false(result$demo_mode)
  testthat::expect_true(is.list(result$meta_json))
  testthat::expect_true(is.data.frame(result$domains))
  testthat::expect_equal(result$DomainListDesc, tools::file_path_sans_ext(basename(domains_file)))
})

testthat::test_that("load_data uses default look-up table when look_up_file is NULL", {
  result <- load_data(json_file, domains_file, NULL)
  testthat::expect_equal(result$lookup, look_up)
})

testthat::test_that("load_data reads user-specified look-up table correctly", {
  result <- load_data(json_file, domains_file, look_up_file)
  testthat::expect_true(is.data.frame(result$lookup))
  testthat::expect_equal(nrow(result$lookup), nrow(utils::read.csv(look_up_file)))
})
