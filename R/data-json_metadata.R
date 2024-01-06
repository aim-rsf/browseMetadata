#' Json metadata file
#'
#' Example metadata for a health dataset, to demo the function domain_mapping.R \cr \cr
#' This data was created with these five steps:
#' \enumerate{
#'   \item Go to https://modelcatalogue.cs.ox.ac.uk/hdruk_live/#/catalogue/dataModel/17e86f3f-ec29-4c8e-9efc-8793a74b107d
#'   \item Download json metadata file by selecting the 'Export as JSON' option on the download button
#'   \item \code{install.packages("rjson")}
#'   \item \code{json_metadata <- rjson::fromJSON(file = '/browseMetadata/data-raw/maternity_indicators_dataset_(mids)_20240105T132210.json')}
#'   \item \code{usethis::use_data(json_metadata)}
#' }
#'
#' @docType data
#
#' @usage data(json_metadata)
#'
#' @format Nested lists
#'
#' @source https://modelcatalogue.cs.ox.ac.uk/hdruk_live/#/catalogue/dataModel/17e86f3f-ec29-4c8e-9efc-8793a74b107d
"json_metadata"
