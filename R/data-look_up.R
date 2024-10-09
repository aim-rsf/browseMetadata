#' Auto-categorisations
#'
#' A list of pre-defined pairings between data element and domain code. \cr \cr
#' For each data element that mapMetadata.R processes: \cr \cr
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
