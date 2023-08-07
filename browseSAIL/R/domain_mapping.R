#' domain_mapping
#'
#' This function will read in the meta-data of a dataset (DataClass) from the SAIL databank, obtained from https://modelcatalogue.cs.ox.ac.uk/hdruk_live/.
#' It will loop through all the variable names, and ask you to categorise each variable into one of your chosen domains.
#' The domains (or 'latent concepts') will appear up in the Plots tab for your reference, as well as information about the dataset.
#' A log file will be saved with the categorizations you made.
#' @param dataset_desc The metadata file for the dataset, containing general information. See the demo data file in the data folder of this package.
#' @param dataset The metadata file for the dataset, containing information about each variable. See the demo data file in the data folder of this package.
#' @param domain The file that lists the domains (latent concepts) of interest to be used within the research study. See the demo data file in the data folder of this package.
#' @return The function will return a log file with your chosen categorizations.
#' @examples
#' In the R console run these four lines:
#'
#' data(dataset_desc)
#' data(dataset)
#' data(domains)
#'
#' domain_mapping(dataset_desc,dataset,domains)
#'
#' It will ask you for a range of rows to process.
#' For this demo, write '1,10' so that the dataset file can be processed quickly.
#' If you press enter, it will process all the rows in the dataset file (93).
#'
#' It will ask you for your initials. This is to save within the log file, to keep track of who made the categorizations.
#'
#' It will then loop through each row you have requested. It will show you the name, description and data type for each variable.
#' See the Plots tab for the Domain table, and tables that summarise information about the dataset that the variables derive from.
#' Respond to this prompt with a single number or multiple numbers separate by a column.
#' For example 'ALF_E' would be coded as '2' (ID INFORMATION)
#' The user has an option to write a note explaining their category choice.
#'
#' These example files (in data) started as excel or csv files.
#' Use the packages like read.csv or readxl to read your own files into R as a dataframes before calling the domain_mapping function.
#' @export
domain_mapping <- function(dataset_desc,dataset,domain) {

  library(gridExtra)
  library(grid)
  library(tidyverse)
  library(insight)

  # Read in domain file and present info in plots panel for user's reference ----
  plot.new()
  domains_extend <- rbind(c('NO MATCH TO DOMAIN'),c('UNSURE'), c('ID INFORMATION'),domains)
  grid.table(domains_extend[1],cols='Domain',rows=0:(nrow(domains_extend)-1))

  # Read in dataset description file and present info in plots panel for user's reference ----
  plot.new()
  grid.table(sapply(lapply(dataset_desc$DataAssestDescription, strwrap, width=75), paste, collapse="\n"), cols=paste('Data Asset: ',dataset_desc$DataAsset))
  plot.new()
  grid.table(sapply(lapply(dataset_desc$DataClassDescription, strwrap, width=75), paste, collapse="\n"), cols=paste('DataClass: ',dataset_desc$DataClass))

  # Create unique output csv to log the results ----
  timestamp_now <- gsub(" ", "_",Sys.time())
  timestamp_now <- gsub(":", "-",timestamp_now)
  output_fname <- paste0("LOG-FILE_",timestamp_now,".csv")

  Output <- data.frame(Initials <- c(""),
                       DataAsset <- c(""),
                       DataClass <- c(""),
                       DataElement <- c(""),
                       Domain_code <- c(""),
                       Note <- c("")
    )
    write.csv(Output, output_fname, row.names=FALSE)

  # User inputs ----

  select_rows <- ""
  cat("\n \n")
  select_rows_n <- readline(prompt="RANGE OF ROWS TO PROCESS IN THE DATASET FILE (write as 'start_row,end_row' or press Enter to process all): ")
  if (select_rows_n == "") {
    start_row <- 1
    end_row <- nrow(dataset)
  } else {
    seperate_rows <- unlist(strsplit(select_rows_n,","))
    start_row <- as.numeric(seperate_rows[1])
    end_row <- as.numeric(seperate_rows[2])
  }

  User_Initials <- ""
  while (User_Initials == "") {
    cat("\n \n")
    User_Initials <- readline(prompt="ENTER INITIALS: ")
  }

  # Loop through each variable, request response from the user to match to a domain ----
  for  (datarow in start_row:end_row) {

    cat(paste("\n \n", "DATA ELEMENT: \n",dataset$DataElement[datarow],"\n \n DESCRIPTION: \n",dataset$Description[datarow],"\n \n DATA TYPE: \n",dataset$DataType[datarow],"\n"))

    decision <- ""
    while (decision == "") {
      cat("\n \n")
      decision <- readline(prompt="CATEGORISE THIS VARIABLE (input a comma seperated list of domain numbers): ")
    }

    decision_note <- ""
    while (decision_note == "") {
      cat("\n \n")
      decision_note <- readline(prompt="NOTES (write 'No' if no notes): ")
    }

    new_row <- c(Initials <- User_Initials,
                DataAsset <- dataset_desc$DataAsset,
                DataClass <- dataset_desc$DataClass,
                DataElement <- dataset$DataElement[datarow],
                Domain_code <- decision,
                Note <-decision_note
    )

    Output[datarow,] <- new_row
    Output[Output == ''] <- NA
    write.csv(Output, output_fname, row.names=FALSE)  #save as we go in case session terminates prematurely
  }

  # Print the responses to be saved
   print_colour(paste("\n \n The below responses will be saved to", output_fname,"\n \n"),'blue')
   print(Output)

}
