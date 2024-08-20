#' DOCUMENT!

copy_previous <- function(Dataset_Name,output_dir) {

  o_search = paste0("^OUTPUT_",gsub(" ", "", Dataset_Name),'*')
  csv_list <- data.frame(file = list.files(output_dir, pattern = o_search))
  if (nrow(csv_list) != 0) {
    df_list <- lapply(paste0(output_dir, '/', csv_list$file), read.csv)
    df_prev <- do.call("rbind", df_list) #combine all df
    ## make a new date column, order by earliest, remove duplicates & auto
    df_prev$time2 <- as.POSIXct(df_prev$timestamp, format = "%Y-%m-%d-%H-%M-%S")
      df_prev <- df_prev[order(df_prev$time2), ]
      df_prev <- df_prev %>% distinct(DataElement, .keep_all = TRUE)
      df_prev <- df_prev[-(which(df_prev$Note %in% "AUTO CATEGORISED")), ]
      df_prev_exist <- TRUE
      cat("\n")
      cli_alert_info(paste0("Copying from previous session(s): "))
      cat("\n")
      print(csv_list$file)

    } else {
      df_prev <- NULL
      df_prev_exist <- FALSE
    }

  output <- list(df_prev = df_prev,df_prev_exist = df_prev_exist)
  output

}
