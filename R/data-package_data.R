#' Output dataframe
#'
#' Empty output dataframe for map_metadata.R to fill. Created by: \cr \cr
#' \enumerate{
#'  \item \code{output <- data.frame(timestamp = character(0),
#'  Table = character(0),
#'  DataElement_N = character(0),
#'  DataElement = character(0),
#'  Domain_code = character(0),
#'  Note = character(0))}
#'  \item \code{usethis::use_data(output)}
#' }
#'
#' @docType data
#
#' @usage data(output)
#'
#' @format A data frame with 0 rows and 6 columns
#'
#' @source The dataframe was manually created as package data, using the above code.
"output"

#' Output log dataframe
#'
#' Empty log output dataframe for map_metadata.R to fill. Created by: \cr \cr
#' \enumerate{
#'  \item \code{log_output <- data.frame(timestamp = character(1),
#'  browseMetadata = character(1),
#'  Initials = character(1),
#'  MetaDataVersion = character(1),
#'  MetaDataLastUpdated = character(1),
#'  DomainListDesc = character(1),
#'  Dataset = character(1),
#'  Table = character(1),
#'  Table_note = character(1))}
#'  \item \code{usethis::use_data(log_output)}
#' }
#'
#' @docType data
#
#' @usage data(log_output)
#'
#' @format A data frame with 1 empty row and 9 columns
#'
#' @source The dataframe was manually created as package data, using the above code.
"log_output"

#' List of domains
#'
#' A simplified list of domains, to demo the function map_metadata.R \cr \cr
#' This data was created with these two steps:
#' \enumerate{
#'  \item \code{domain_list <- read.csv('browseMetadata/inst/inputs/domain_list_demo.csv',header=FALSE)}
#'  \item \code{usethis::use_data(domain_list)}
#' }
#' @docType data
#
#' @usage data(domain_list)
#'
#' @format A data frame with 5 rows and 1 column
#'
#' @source The csv was manually created
"domain_list"

#' Json metadata file
#'
#' Example metadata for a health dataset, to demo the function map_metadata.R \cr \cr
#' This data was created with these five steps:
#' \enumerate{
#'   \item Go to https://modelcatalogue.cs.ox.ac.uk/hdruk_live/#/catalogue/dataModel/16920b16-e24c-49f9-b4df-3dc85779822b/dataClasses
#'   \item Download json metadata file by selecting the 'Export as JSON' option on the download button
#'   \item \code{install.packages("rjson")}
#'   \item \code{json_metadata <- rjson::fromJSON(file = 'browseMetadata/inst/inputs/national_community_child_health_database_(ncchd)_20240405T130125.json')}
#'   \item \code{usethis::use_data(json_metadata)}
#' }
#'
#' @docType data
#
#' @usage data(json_metadata)
#'
#' @format Nested lists
#'
#' @source https://modelcatalogue.cs.ox.ac.uk/hdruk_live/#/catalogue/dataModel/16920b16-e24c-49f9-b4df-3dc85779822b/dataClasses
"json_metadata"

#' Auto-categorisations
#'
#' A list of pre-defined pairings between data element and domain code. \cr \cr
#' For each data element that map_metadata processes: \cr \cr
#' If it is contained within this look-up table, it uses the auto-categorised domain code rather than asking the user to categorise.\cr\cr
#' This data was created with these two steps:
#' \enumerate{
#'  \item \code{look_up <- read.csv('browseMetadata/inst/inputs/look_up.csv')}
#'  \item \code{usethis::use_data(look_up)}
#' }
#' @docType data
#
#' @usage data(look_up)
#'
#' @format A data frame with a variable number of rows and 3 columns
#'
#' @source The csv was manually created
"look_up"

