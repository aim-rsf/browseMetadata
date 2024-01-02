#' domain_mapping
#'
#'This function will read in the meta-data of a Data Asset obtained from metadata catalogue: https://modelcatalogue.cs.ox.ac.uk/hdruk_live.
#'It will loop through all the Data Elements (variable names) in each Data Class (table), and ask you to categorise each variable into one of your chosen domains.
#'Information about the Data Asset and Data Class can be displayed to the command window for reference.
#'The domains will appear in the Plots tab, with the labels you should use for the categorisation.
#'@param json_file The metadata file. This should be downloaded from the metadata catalogue as a json file.
#'@param domain_file The file that lists the domains of interest to be used within the research study, provided as a csv with each domain on a separate line, within quotations.
#'@return The function will return a log file with your mapping between variables and domains, alongside details about the Data Asset.
#'@examples
#'# Run the code with the demo files
#'\emph{domain_mapping(,,TRUE)}
#'# Respond with your initials when prompted.
#'# Respond 'Demo List.' for the description of demo list.
#'# Respond 'Y' if you want to see the descriptions printed out.
#'# Respond '1,10' to the RANGE OF VARIABLES prompt (or process the full 93 variables if you like!)
#'# Reference the plot tab and categorise each variable into a single ('1') or multiple  ('1,2') domain.
#'# Write a note explaining your category choice (optional).
#'@export
domain_mapping <- function(json_file= NULL,domain_file= NULL) {

  library(rjson)
  library(gridExtra)
  library(grid)
  library(insight)

  # Load data: Check if demo data should be used
  if (is.null(json_file) && is.null(domain_file)) {
    # If both json_file and domain_file are NULL, use demo data
    data(package='browse-metadata')
    meta_json <- data(json_metdata)
    domains <- data(domains_list)
  } else if (is.null(json_file) || is.null(domain_file)) {
    # If only one of json_file and domain_file is NULL, throw error
    stop("Please provide both json_file and domain_file or neither")
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

  # Get user and demo list info for log file ----
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

  # Print information about Data Asset ----
  print_colour("\nData Asset Name \n",'br_violet')
  cat(meta_json$dataModel$label,fill=TRUE)
  print_colour("Data Asset Last Updated \n",'br_violet')
  cat(meta_json$dataModel$lastUpdated,fill=TRUE)
  print_colour("Data Asset Exported \n",'br_violet')
  cat("By", meta_json$exportMetadata$exportedBy, "at", meta_json$exportMetadata$exportedOn,fill=TRUE)
  nDataClasses <- length(meta_json$dataModel$childDataClasses)
  print_colour(sprintf("There are %s Data Classes (tables) in this Data Asset",nDataClasses),'br_violet')

  dataasset_desc <- readline(prompt="Would you like to read a description of the Data Asset? (Y/N) ")
  if (dataasset_desc == "Y") {
    print_colour("Data Asset Description \n",'br_violet')
    cat(meta_json$dataModel$description,fill=TRUE)
    readline(prompt="Press [enter] to proceed")
  }

  # Extract each DataClass (Table)
  for (dc in 1:nDataClasses) {
    print_colour(sprintf("\n\nProcessing Data Class (Table) %s of %s \n",dc,nDataClasses),'br_violet')
    print_colour("\nData Class Name \n",'br_violet')
    cat(meta_json$dataModel$childDataClasses[[dc]]$label,fill=TRUE)
    print_colour("Data Class Last Updated \n",'br_violet')
    cat(meta_json$dataModel$childDataClasses[[dc]]$lastUpdated,fill=TRUE)

    dataclass_desc <- readline(prompt="Would you like to read a description of the Data Class (Table)? (Y/N) ")
    if (dataclass_desc == "Y") {
      print_colour("Data Class Description \n",'br_violet')
      cat(meta_json$dataModel$childDataClasses[[dc]]$description,fill=TRUE)
      readline(prompt="Press [enter] to proceed")
    }

    thisDataClass <- meta_json$dataModel$childDataClasses[[dc]]$childDataElements #  probably a better way of dealing with complex json files in R ...
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

    output_fname <- paste0("LOG_",gsub(" ", "",meta_json$dataModel$label),'_',gsub(" ", "",meta_json$dataModel$childDataClasses[[dc]]$label),'_',timestamp_now,".csv")

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

    # Loop through each variable, request response from the user to match to a domain ----
    for  (datavar in start_var:end_var ) {

      # auto categorise (full string and partial string matches)
      if (selectDataClass_df$Label[datavar] == "NA") {

        Output [ nrow(Output) + 1 , ] <- NA
        Output$DataElement[datavar]
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- '0'
        Output$Note[datavar] <- 'AUTO CATEGORISED'

      } else if (selectDataClass_df$Label[datavar] == "AVAIL_FROM_DT") {

        Output [ nrow(Output) + 1 , ] <- NA
        Output$DataElement[datavar]
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- '1'
        Output$Note[datavar] <- 'AUTO CATEGORISED'

      } else if ((selectDataClass_df$Label[datavar] == "ALF_E")
        ||  (selectDataClass_df$Label[datavar] == "RALF")
        ||  (selectDataClass_df$Label[datavar] == "ALF_STS_CD")
        ||  (selectDataClass_df$Label[datavar] == "ALF_MTCH_PCT")
        ||  (grepl("_ALF_E", selectDataClass_df$Label[datavar],ignore.case = TRUE))  # grepl because of MOTHER_ALF_E and CHILD_ALF_E etc.
        ||  (grepl("_RALF", selectDataClass_df$Label[datavar],ignore.case = TRUE))
        ||  (grepl("_ALF_STS_CD", selectDataClass_df$Label[datavar],ignore.case = TRUE))
        ||  (grepl("_ALF_MTCH_PCT", selectDataClass_df$Label[datavar],ignore.case = TRUE)))
        {
        Output [ nrow(Output) + 1 , ] <- NA
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- '2'
        Output$Note[datavar] <- 'AUTO CATEGORISED'

      } else if (grepl("_ID_", selectDataClass_df$Label[datavar],ignore.case = TRUE)) { # picking up generic IDs

        Output [ nrow(Output) + 1 , ] <- NA
        Output$DataElement[datavar] <- selectDataClass_df$Label[datavar]
        Output$Domain_code[datavar] <- '3'
        Output$Note[datavar] <- 'AUTO CATEGORISED'

      } else if ((selectDataClass_df$Label[datavar] == "AGE") # likely to be a better way to code this section with fewer lines
                 || (selectDataClass_df$Label[datavar] == "DOB")
                 || (selectDataClass_df$Label[datavar] == "WOB")
                 || (selectDataClass_df$Label[datavar] == "SEX")
                 || (selectDataClass_df$Label[datavar] == "GENDER")
                 || (selectDataClass_df$Label[datavar] == "GNDR")
                 || (grepl("_AGE",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("_DOB",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("_WOB",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("_SEX",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("_GENDER",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("_GNDR",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("AGE_",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("DOB_",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("WOB_",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("SEX_",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                 || (grepl("GENDER_",selectDataClass_df$Label[datavar],ignore.case = TRUE))
                || (grepl("GNDR_",selectDataClass_df$Label[datavar],ignore.case = TRUE)))
        {
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
          decision_note <- readline(prompt="NOTES (write 'N' if no notes): ")
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
    Output$DataClass = meta_json$dataModel$childDataClasses[[dc]]$label

    # Save file & print the responses to be saved
    Output[Output == ''] <- NA
    write.csv(Output, output_fname, row.names=FALSE)  #save as we go in case session terminates prematurely
    print_colour(paste("\n \n The below responses will be saved to", output_fname,"\n \n"),'blue')
    print(Output[,c("DataClass","DataElement","Domain_code","Note")])
  }

  print_colour("\n \n Please check the auto categorised data elements are accurate!\n Manually edit csv file to correct errors, if needed.\n",'red')
}

