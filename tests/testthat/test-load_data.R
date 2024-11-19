# load libraries
library(testthat) # test_that, expect_true, expect_equal, expect_error, expect_false
library(mockery) # mock, stub
library(tools) # file_path_sans_ext
library(utils) # read.csv

# Define file paths to demo data relative to the package directory
json_file <- system.file("inputs/national_community_child_health_database_(ncchd)_20240405T130125.json", package = "browseMetadata")
look_up_file <- system.file("inputs/look_up.csv", package = "browseMetadata")
domains_file <- system.file("inputs/domain_list_demo.csv", package = "browseMetadata")

# Define package demo data
json <- get("json_metadata")
look_up <- get("look_up")
domains <- get("domain_list")

test_that("load_data runs in demo mode when both json_file and domain_file are NULL", {
  result <- load_data(NULL, NULL, NULL)
  expect_true(result$demo_mode)
  expect_equal(result$meta_json, json)
  expect_equal(result$domains, domains)
  expect_equal(result$domain_list_desc, "DemoList")
})

test_that("load_data throws error if only one of json_file or domain_file is NULL", {
  expect_error(load_data(json_file, NULL, NULL))
  expect_error(load_data(NULL, domains_file, NULL))
})

test_that("load_data reads user-specified files correctly", {
  result <- load_data(json_file, domains_file, NULL)
  expect_false(result$demo_mode)
  expect_true(is.list(result$meta_json))
  expect_true(is.data.frame(result$domains))
  expect_equal(result$domain_list_desc, file_path_sans_ext(basename(domains_file)))
})

test_that("load_data uses default look-up table when look_up_file is NULL", {
  result <- load_data(json_file, domains_file, NULL)
  expect_equal(result$lookup, look_up)
})

test_that("load_data reads user-specified look-up table correctly", {
  result <- load_data(json_file, domains_file, look_up_file)
  expect_true(is.data.frame(result$lookup))
  expect_equal(nrow(result$lookup), nrow(read.csv(look_up_file)))
})
