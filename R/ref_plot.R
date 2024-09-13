#' ref_plot
#'
#' This function is called within the mapMetadata function. \cr \cr
#' It plots a reference table to guide the user in their categorisation of domains. \cr \cr
#' This reference table is based on the user inputted domains and the default domains provided by this package.  \cr \cr
#' @param domains The output of load_data
#' @return A reference table that appears in the Plots tab. A list of 2 containing the derivatives for this plot, used later in mapMetadata.
#' @importFrom CHECK LATER
#'
#'

ref_plot <- function(domains){

  colnames(domains)[1] = "Domain Name"
  graphics::plot.new()
  domains_extend <- rbind(c("*NO MATCH / UNSURE*"), c("*METADATA*"), c("*ID*"), c("*DEMOGRAPHICS*"), domains)
  Code <- data.frame(Code = 0:(nrow(domains_extend) - 1))
  Domain_table <- tableGrob(cbind(Code,domains_extend),rows = NULL,theme = ttheme_default())
  grid.arrange(Domain_table,nrow=1,ncol=1)

  return(list(Code = Code, Domain_table = Domain_table))

}


