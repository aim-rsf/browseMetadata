#' Json metadata file
#'
#' Example metadata for a health dataset, to demo the function mapMetadata.R \cr \cr
#' This data was created with these five steps:
#' \enumerate{
#'   \item Go to https://modelcatalogue.cs.ox.ac.uk/hdruk_live/#/catalogue/dataModel/16920b16-e24c-49f9-b4df-3dc85779822b/dataClasses
#'   \item Download json metadata file by selecting the 'Export as JSON' option on the download button
#'   \item \code{install.packages("rjson")}
#'   \item \code{json_metadata <- rjson::fromJSON(file = '/browseMetadata/data-raw/national_community_child_health_database_(ncchd)_20240405T130125.json')}
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
