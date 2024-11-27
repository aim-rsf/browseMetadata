#' map_metadata_convert
#'
#' The 'OUTPUT_' file groups multiple categorisations onto one line e.g. Domain_code could read '1,3' \cr \cr
#' This function creates a new longer output 'L-OUTPUT_' which gives each categorisation its own row. \cr \cr
#' This 'L-OUTPUT_' may be more useful when using these csv files in later analyses.
#' @param output_csv The name of the 'OUTPUT_' csv file that was created from map_metadata
#' @param output_dir The location of output_csv
#' @return The function will return 'L-OUTPUT_' in the same output_dir
#' @export
#' @importFrom utils read.csv write.csv
#' @examples
#' # Create a temporary directory for the example
#' temp_dir <- tempdir()
#'
#' # Create an example OUTPUT_ CSV file with primary care data
#' example_data <- data.frame(
#'   patient_id = c(101, 102, 103, 104),
#'   condition_code = c("A01", "B02", "A01,C03", "D04"),
#'   medication = c("Medication1", "Medication2", "Medication3", "Medication4")
#' )
#' write.csv(example_data, file = file.path(temp_dir, "OUTPUT_example.csv"), row.names = FALSE)
#'
#' # Use the function to process the example file
#' map_metadata_convert("OUTPUT_example.csv", temp_dir)
#'
#' # Check the output
#' read.csv(file.path(temp_dir, "L-OUTPUT_example.csv"))
map_metadata_convert <- function(output_csv, output_dir) {
  output <- read.csv(paste0(output_dir, "/", output_csv))
  output_long <- output[0, ] # make duplicate

  for (row in 1:(nrow(output))) {
    if (grepl(",", output$domain_code[row])) { # Domain_code for this row is a list
      domain_code_list <- output$domain_code[row] # extract Domain_code list
      domain_code_list_split <- unlist(strsplit(domain_code_list, ",")) # split the list
      for (code in 1:(length(domain_code_list_split))) { # for every domain code in list, create a new row
        row_to_copy <- output[row, ] # extract row
        row_to_copy$domain_code <- domain_code_list_split[code] # change domain code to single
        output_long[nrow(output_long) + 1, ] <- row_to_copy # copy altered row
      }
    } else { # Domain_code for this row is not list
      row_to_copy <- output[row, ] # extract row
      output_long[nrow(output_long) + 1, ] <- row_to_copy # copy unaltered row
    }
  }

  # Save output_long
  write.csv(output_long, paste0(output_dir, "/", "L-", output_csv), row.names = FALSE)
}
