#' ref_plot
#'
#' This function is called within the map_metadata function. \cr \cr
#' It plots a reference table to guide the user in their categorisation of domains. \cr \cr
#' This reference table is based on the user inputted domains and the default domains provided by this package.  \cr \cr
#' @param domains The output of load_data
#' @return A reference table that appears in the Plots tab. A list of 2 containing the derivatives for this plot, used later in map_metadata'
#' @importFrom gridExtra tableGrob grid.arrange
#' @importFrom graphics plot.new

ref_plot <- function(domains){

  colnames(domains)[1] = "Domain Name"
  plot.new()
  domains_extend <- rbind(c("*NO MATCH / UNSURE*"), c("*METADATA*"), c("*ID*"), c("*DEMOGRAPHICS*"), domains)
  Code <- data.frame(Code = 0:(nrow(domains_extend) - 1))
  Domain_table <- tableGrob(cbind(Code,domains_extend),rows = NULL)
  grid.arrange(Domain_table,nrow=1,ncol=1)

  return(list(Code = Code, Domain_table = Domain_table))

}

#' end_plot
#'
#' This function is called within the map_metadata function. \cr \cr
#' A summary plot is created that includes the domain code reference table and counts of domain code categorisations \cr \cr
#'
#' @param df The Output dataframe with all the domain categorisations
#' @param Table_name The table name
#' @param ref_table The domain code reference table (which domain maps to which integer)
#' @return It returns a ggplot
#' @importFrom dplyr %>% group_by count arrange
#' @importFrom stats reorder
#' @importFrom gridExtra grid.arrange
#' @import ggplot2

end_plot <- function(df,Table_name, ref_table){

  counts <- df %>% group_by(Domain_code) %>% count() %>% arrange(n)

  Domain_plot <- counts %>%
    ggplot(aes(x = reorder(Domain_code, -n), y = n)) +
    geom_col() +
    ggtitle(paste("Data Elements in",Table_name,"grouped by Domain code")) +
    theme_gray(base_size = 18) +
    theme(axis.text.x = element_text(
      angle = 90,
      vjust = 0.5,
      hjust = 1
    )) +
    xlab('Domain Code') +
    ylab('Count') +
    scale_y_continuous(breaks = seq(0, max(counts$n), 1))

  full_plot <- grid.arrange(Domain_plot,
                            ref_table,
                            nrow = 1,
                            ncol = 2)
  return(full_plot)

}


