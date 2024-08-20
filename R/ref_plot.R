#' DOCUMENT!

browseMetadata_ref_plot <- function(domains){

  colnames(domains)[1] = "Domain Name"
  graphics::plot.new()
  domains_extend <- rbind(c("*NO MATCH / UNSURE*"), c("*METADATA*"), c("*ID*"), c("*DEMOGRAPHICS*"), domains)
  Code <- data.frame(Code = 0:(nrow(domains_extend) - 1))
  Domain_table <- tableGrob(cbind(Code,domains_extend),rows = NULL,theme = ttheme_default())
  grid.arrange(Domain_table,nrow=1,ncol=1)

  return(list(Code = Code, Domain_table = Domain_table))

}
