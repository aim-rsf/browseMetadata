#' browse_metadata
#'
#' Run this function before map_metadata \cr \cr
#' This function will read in the metadata file for a chosen dataset and save
#' three summary outputs. The first is a table output, storing the name and
#' description of the dataset, and each table within it. The second is a bar
#' chart, summarising how many variables there are for each table, and whether
#' these variables have a missing description. The third is a csv file storing
#' the data that created this bar chart. \cr \cr
#' @param json_file The metadata file. This should be a json download from the
#' metadata catalogue. By default, the .json file within 'inst/inputs' is used.
#' @param output_dir The path to the directory where the three output files
#' will be saved. By default, the current working directory is used.
#' @return The function will return three files, 'BROWSE_table...html',
#' 'BROWSE_bar...html' and 'BROWSE_bar...csv' which gives summary information
#' for this dataset. Open the two html output files in your browser and use
#' these as reference when running the map_metadata function.
#' @examples
#' # Demo run requires no function inputs or user interaction
#' browse_metadata()
#' @export
#' @importFrom dplyr %>% add_row
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_info
#' @importFrom plotly plot_ly layout
#' @importFrom htmlwidgets saveWidget
#' @importFrom tidyr pivot_longer
#' @importFrom utils browseURL

browse_metadata <- function(json_file = NULL, output_dir = getwd()) {
  # DEFINE INPUTS AND OUTPUTS ----

  ## Read in the json file containing the meta data, if null load the demo file
  if (is.null(json_file)) {
    demo_json <- system.file("inputs/national_community_child_health_database_(ncchd)_20240405T130125.json", package = "browseMetadata")
    meta_json <- fromJSON(demo_json)
    cat("\n")
    cli_alert_info("Running browseMetadata in demo mode using package data files")
    cat("\n ")
  } else {
    meta_json <- fromJSON(json_file)
  }

  ## Extract dataset from json_file
  dataset <- meta_json$dataModel
  dataset_name <- dataset$label
  dataset_version <- meta_json$dataModel$documentationVersion

  # PREPARE 2 OUTPUT DATAFRAMES FOR LATER PLOTTING ----

  ## 1. Information about dataset and each table
  dataset_desc <- data.frame(
    N = character(0), Name = character(0),
    Description = character(0)
  )
  ### add information about the dataset at the top
  dataset_desc <- dataset_desc %>% add_row(
    N = "", Name = dataset_name,
    Description = gsub("\n\n", "", dataset$description)
  )
  dataset_desc <- dataset_desc %>%
    add_row(N = "N", Name = "Table", Description = "")

  ## 2. Counts of empty description fields for each table
  count_empty <- data.frame(Empty = c("No", "Yes"))

  # LOOP THROUGH EACH TABLE IN DATASET ----

  ntables <- nrow(dataset$childDataClasses)
  ntables_digits <- nchar(ntables)

  for (dc in 1:ntables) {
    cat("\n")
    table_name <- dataset$childDataClasses$label[dc]
    cli_alert_info(paste0(
      "Processing Table {dc} of {ntables} (",
      table_name, ")"
    ))

    ## Add to the dataset_desc data frame
    dataset_desc <- dataset_desc %>% add_row(
      N = as.character(dc),
      Name = table_name,
      Description = gsub("\n\n", "", dataset$childDataClasses$description[dc])
    )

    ## Use 'json_table_to_df.R' to extract table from meta_json into a df
    table_df <- json_table_to_df(dataset = dataset, n = dc)

    ## Use 'count_empty_desc.R' to count number of empty descriptions
    table_colname <- paste0(table_name, "(", dc, ")")
    count_empty_table <- count_empty_desc(table_df, table_colname)

    ## Add to group dataframe for later plotting
    count_empty[[table_colname]] <- count_empty_table[[table_colname]]
  } # end of loop through each table

  # 1. TABLE SUMMARISING THE DATASET ----

  ## Create a matrix for cell colors
  cell_colors <- matrix("white",
    nrow = nrow(dataset_desc) + 1,
    ncol = ncol(dataset_desc)
  )
  cell_colors[2, ] <- "lightgrey" # Change the color of the second row

  table_html <- plot_ly(
    type = "table",
    columnorder = c(0, 1, 2),
    columnwidth = c(ntables_digits, max(nchar(dataset_desc$Name)), 100),
    header = list(
      values = c("", "Dataset", "Description"),
      align = c("center", "center", "center"),
      line = list(width = 1, color = "black"),
      fill = list(color = c("grey", "grey")),
      font = list(family = "Arial", size = 14, color = "white")
    ),
    cells = list(
      values = rbind(t(as.matrix(unname(dataset_desc)))),
      align = c("center", "center", "left"),
      line = list(color = "black", width = 1),
      fill = list(color = apply(cell_colors, 2, as.list)), # Apply cell colors
      font = list(family = "Arial", size = 12, color = c("black"))
    )
  )

  # 2. BAR CHART DISPLAYING COUNTS OF MISSING DESCRIPTIONS FOR ALL TABLES ----
  count_empty_long <- count_empty %>%
    pivot_longer(cols = -Empty, names_to = "Table", values_to = "N_Variables")

  barplot_html <- plot_ly(count_empty_long,
    x = ~Table,
    y = ~N_Variables,
    color = ~Empty,
    colors = c("grey", "darkturquoise"),
    type = "bar",
    text = ~N_Variables,
    textposition = "inside", # Position text inside the bars
    texttemplate = "%{text}", # Ensure text displayed as is
    textfont = list(color = "black", size = 10)
  ) %>%
    layout(
      barmode = "stack",
      title = paste0("\n", dataset_name, " contains ", ntables, " table(s)"),
      xaxis = list(title = "Table"),
      yaxis = list(title = "N_Variables"),
      legend = list(title = list(text = "Empty Description"))
    )

  # SAVE PLOTS ----

  original_wd <- getwd()
  setwd(output_dir) # saveWidget has a bug with paths & saving
  base_fname <- paste0(gsub(" ", "", dataset_name), "_V", dataset_version)

  ## Save the table plot to a HTML file
  table_fname <- paste0("BROWSE_table_", base_fname, ".html")
  saveWidget(widget = table_html, file = table_fname, selfcontained = TRUE)

  ## Save the bar plot to a HTML file
  bar_fname <- paste0("BROWSE_bar_", base_fname, ".html")
  saveWidget(widget = barplot_html, file = bar_fname, selfcontained = TRUE)

  ## Save the data that made the bar plot to a csv file
  bar_data_fname <- paste0("BROWSE_bar_", base_fname, ".csv")
  write.csv(count_empty_long, bar_data_fname, row.names = FALSE)

  setwd(original_wd) # saveWidget has a bug with paths & saving

  # OUTPUTS ----
  cat("\n")
  browseURL(table_fname)
  browseURL(bar_fname)
  cli_alert_info("Three outputs have been saved to your output directory, and two outputs should have opened in your browser.")

} # end of function
