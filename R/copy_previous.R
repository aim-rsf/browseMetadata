#' copy_previous
#'
#' This function is called within the mapMetadata function. \cr \cr
#' It searches for previous OUTPUT files in the output_dir, that match the dataset name. \cr \cr
#' If files exist, it removes duplicates and autos, and stores the rest of the data elements in a dataframe. \cr \cr
#'
#' @param Dataset_Name Name of the dataset
#' @param output_dir Output directory to be searched
#' @return It returns a list of 2: df_prev_exist (a boolean) and df_prev (NULL or populated with data elements to copy)
#' @importFrom dplyr %>%

copy_previous <- function(Dataset_Name,output_dir) {

  o_search = paste0("^OUTPUT_",gsub(" ", "", Dataset_Name),'*')
  csv_list <- data.frame(file = list.files(output_dir, pattern = o_search))
  if (nrow(csv_list) != 0) {
    df_list <- lapply(paste0(output_dir, '/', csv_list$file), read.csv)
    df_prev <- do.call("rbind", df_list) #combine all df
    ## make a new date column, order by earliest, remove duplicates & auto
    df_prev$time2 <- as.POSIXct(df_prev$timestamp, format = "%Y-%m-%d-%H-%M-%S")
      df_prev <- df_prev[order(df_prev$time2), ]
      df_prev <- df_prev %>% dplyr::distinct(DataElement, .keep_all = TRUE)
      df_prev <- df_prev[-(which(df_prev$Note %in% "AUTO CATEGORISED")), ]
      df_prev_exist <- TRUE
      cat("\n")
      cli::cli_alert_info(paste0("Copying from previous session(s): "))
      cat("\n")
      print(csv_list$file)

    } else {
      df_prev <- NULL
      df_prev_exist <- FALSE
    }

  output <- list(df_prev = df_prev,df_prev_exist = df_prev_exist)
  output

}
