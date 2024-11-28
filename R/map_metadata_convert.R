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
#' # Load the browseMetadata package
#' library(browseMetadata)
#' # Define the get_output_paths function temporarily (for example)
#' get_output_paths <- function(filename = NULL) {
#'   # Resolve the output directory relative to the installed package
#'   output_dir <- system.file("outputs", package = "browseMetadata")
#'
#'   # Check if the output_dir was correctly found
#'   if (output_dir == "") {
#'     stop("The outputs directory could not be found. Make sure the package is installed correctly.")
#'   }
#'
#'   # If a filename is provided, create the full file path (just the filename)
#'   output_csv <- if (!is.null(filename)) {
#'     filename  # Return just the filename (not full path yet)
#'   } else {
#'     NULL
#'   }
#'
#'   # Return both output_dir and output_csv (just the filename, not full path)
#'   list(output_dir = output_dir, output_csv = output_csv)
#' }
#'
#' # Define input parameters using dynamic paths
#' paths <- get_output_paths("OUTPUT_NationalCommunityChildHealthDatabase(NCCHD)_CHILD_2024-11-27-14-19-55.csv")
#' output_csv <- paths$output_csv  # Just the filename
#' output_dir <- paths$output_dir  # Directory path
#'
#' # Print paths for debugging (optional)
#' print(output_csv)  # Check the filename
#' print(output_dir)  # Check the directory path
#'
#' # Check if the directory exists before proceeding
#' if (!dir.exists(output_dir)) {
#'   stop("Output directory does not exist!")
#' }
#'
#' # Run the function to convert the metadata
#' map_metadata_convert(
#'   output_csv = output_csv,  # Pass just the filename here
#'   output_dir = output_dir   # Pass the directory path separately
#' )


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
