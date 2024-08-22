#' DOCUMENT!

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
