#' domain_mapping
#'
#' This function will read in the meta-data of a dataset (DataClass) from the SAIL databank, obtained from metadata catalogue (https://modelcatalogue.cs.ox.ac.uk/hdruk_live).
#' It will loop through all the variable names, and ask you to categorise each variable into one of your chosen domains.
#' Information about the Data Asset and Data Class will be displayed to the command window for reference.
#' The domains will appear in the Plots tab, with the labels you should you for the categorisation.
#' A log file will be saved with the categorisations you made.
#' @param json_file The metadata file. This should be downloaded from the metadata catalogue as a json file.
#' @param domain_file The file that lists the domains of interest to be used within the research study, provided as a csv with each domain on a separate line, within quotations.
#' @param demo_mode Write TRUE to run the function in demo mode, using the demo data in the package, and leaving the other inputs blank. See example below.
#' @return The function will return a log file with your chosen categorisations.
#' @examples
#' \strong{Run the code with the demo files}
#'
#' \emph{domain_mapping(,,TRUE)}
#'
#' It will first output a description of the data asset and data class that you have loaded in.
#'
#' It will ask you for a range of variables (data elements) to process from this data class.
#' For this demo, write '1,10' so that the meta dataset file can be processed quickly.
#' If you press enter, it will process all the variables in the dataset file (93).
#'
#' It will ask you for your initials.
#' This is to save within the log file, to keep track of who made the categorizations.
#'
#' It will then loop through each variable you have requested.
#' It will show you the name, description and data type for each variable.
#' See the Plots tab for the Domain table.
#' Respond to this prompt with a single number or multiple numbers separate by a column.
#' The user has an option to write a note explaining their category choice.
#'
#' \strong{Run the code with your input files}
#'
#' \emph{domain_mapping(your-metadata.json,your-domain-list.csv)}
#'
#'
#' @export
domain_mapping <- function(json_file,domain_file,demo_mode = FALSE) {

  library(rjson)
  library(gridExtra)
  library(grid)
  library(insight)

  # Demo mode or normal mode

  if (demo_mode == TRUE) {
    data(package='browseSAIL')
    data(json_metdata)
    data(domains_list)
    meta_json <- json_metdata
    domains <-domains_list
  } else {
    # Read in the json file containing the meta data
    meta_json <- fromJSON(file = json_file)
    # Read in the domain file containing the meta data
    domains <- read.csv(domain_file,header = FALSE)
  }

  # Present domains plots panel for user's reference ----
  plot.new()
  domains_extend <- rbind(c('*NO MATCH / UNSURE*'),c('*METADATA*'), c('*ALF ID*'),c('*OTHER ID*'),c('*DEMOGRAPHICS*'),domains)
  grid.table(domains_extend[1],cols='Domain',rows=0:(nrow(domains_extend)-1))

  # Print information about Data Asset and Class ----
  print_colour("\nData Asset Name --- Last Updated \n",'br_violet')
  cat(meta_json$dataModel$label,"---",meta_json$dataModel$lastUpdated,fill=TRUE)
  print_colour("Data Asset Description \n",'br_violet')
  cat(meta_json$dataModel$description,fill=TRUE)
  print_colour("Data Asset Exported \n",'br_violet')
  cat("By", meta_json$exportMetadata$exportedBy, "at", meta_json$exportMetadata$exportedOn,"\n",fill=TRUE)
  print_colour("\nData Class Name --- Last Updated \n",'br_violet')
  cat(meta_json$dataModel$childDataClasses[[1]]$label,'---',meta_json$dataModel$childDataClasses[[1]]$lastUpdated,fill=TRUE)
  print_colour("Data Class Description \n",'br_violet')
  cat(meta_json$dataModel$childDataClasses[[1]]$description,fill=TRUE)

  # Extract DataClass (probably a better way of dealing with jsons in R ...)
  thisDataClass <- meta_json$dataModel$childDataClasses[[1]]$childDataElements
  thisDataClass_df <- data.frame(do.call(rbind,thisDataClass)) # nested list to dataframe
  dataType_df <- data.frame(do.call(rbind,thisDataClass_df$dataType)) # nested list to dataframe

  selectDataClass_df <- data.frame (Label  = unlist(thisDataClass_df$label),
                                    Description = unlist(thisDataClass_df$description),
                                    Type = unlist(dataType_df$label)
                                    )

  selectDataClass_df <- selectDataClass_df[order(selectDataClass_df$Label),]

  # Create unique output csv to log the results ----
  timestamp_now <- gsub(" ", "_",Sys.time())
  timestamp_now <- gsub(":", "-",timestamp_now)
  output_fname <- paste0("LOG-FILE_",timestamp_now,".csv")

  Output <- data.frame(Initials = c(""),
                       MetaDataVersion = c(""),
                       MetaDataLastUpdated = c(""),
                       DomainListDesc = c(""),
                       DataAsset = c(""),
                       DataClass = c(""),
                       DataElement = c(""),
                       Domain_code = c(""),
                       Note = c("")
    )
  # User inputs ----

  cat("\n \n")
  select_vars_n <- readline(prompt="RANGE OF VARIABLES (DATA ELEMENTS) TO PROCESS (write as 'start_var,end_var' or press Enter to process all): ")
  if (select_vars_n == "") {
    start_var <- 1
    end_var <- length(thisDataClass)
  } else {
    seperate_vars <- unlist(strsplit(select_vars_n,","))
    start_var <- as.numeric(seperate_vars[1])
    end_var <- as.numeric(seperate_vars[2])
  }

  User_Initials <- ""
  while (User_Initials == "") {
    cat("\n \n")
    User_Initials <- readline(prompt="ENTER INITIALS: ")
  }

  DomainListDesc <- ""
  while (DomainListDesc == "") {
    cat("\n \n")
    DomainListDesc <- readline(prompt="PROVIDE SOME DESCRIPTION OF DOMAIN LIST USED (version number, created by): ")
  }

  # Loop through each variable, request response from the user to match to a domain ----
  for  (datavar in start_var:end_var ) {

    # auto categorise
    if (grepl("AVAIL_FROM_DT", selectDataClass_df$Label[datavar])) {

      Output [ nrow(Output) + 1 , ] <- NA
      Output$DataElement[datavar]
      Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
      Output$Domain_code[datavar] <- '1'
      Output$Note[datavar] <- 'AUTO CATEGORISED'

    } else if (grepl("ALF", selectDataClass_df$Label[datavar])) {

      Output [ nrow(Output) + 1 , ] <- NA
      Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
      Output$Domain_code[datavar] <- '2'
      Output$Note[datavar] <- 'AUTO CATEGORISED'

    } else if (grepl("_ID_", selectDataClass_df$Label[datavar])) {

      Output [ nrow(Output) + 1 , ] <- NA
      Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
      Output$Domain_code[datavar] <- '3'
      Output$Note[datavar] <- 'AUTO CATEGORISED'

    } else if (grepl("AGE", selectDataClass_df$Label[datavar])
               || grepl("DOB", selectDataClass_df$Label[datavar])
               || grepl("WOB", selectDataClass_df$Label[datavar])
               || grepl("ETHNIC", selectDataClass_df$Label[datavar])
               || grepl("SEX", selectDataClass_df$Label[datavar])
               || grepl("GENDER", selectDataClass_df$Label[datavar])) {

      Output [ nrow(Output) + 1 , ] <- NA
      Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
      Output$Domain_code[datavar] <- '4'
      Output$Note[datavar] <- 'AUTO CATEGORISED'

    } else {

      # user response
      cat(paste("\nDATA ELEMENT -----> ",selectDataClass_df$Label[datavar],"\n\nDESCRIPTION -----> ",selectDataClass_df$Description[datavar],"\n\nDATA TYPE -----> ",selectDataClass_df$Type[datavar],"\n"))

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

      Output [ nrow(Output) + 1 , ] <- NA
      Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
      Output$Domain_code[datavar] <- decision
      Output$Note[datavar] <- decision_note

    }

  }

  # Fill in columns that have all rows identical
  Output$Initials = User_Initials
  Output$MetaDataVersion = meta_json$dataModel$documentationVersion
  Output$MetaDataLastUpdated = meta_json$dataModel$lastUpdated
  Output$DomainListDesc = DomainListDesc
  Output$DataAsset = meta_json$dataModel$label
  Output$DataClass = meta_json$dataModel$childDataClasses[[1]]$label

  # Save file & print the responses to be saved
   Output[Output == ''] <- NA
   write.csv(Output, output_fname, row.names=FALSE)  #save as we go in case session terminates prematurely
   print_colour(paste("\n \n The below responses will be saved to", output_fname,"\n \n"),'blue')
   print(Output)

}



