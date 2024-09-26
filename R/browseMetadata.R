#' browseMetadata
#'
#' Run this function before MapMetadata. \cr \cr
#' This function will read in the metadata file for a chosen dataset and save
#' two summary outputs. The first is a table output, storing the name and
#' description of the dataset, and each table within it. The second is a bar
#' chart, summarising how many variables there are for each table, and whether
#' these variables have a missing description. \cr \cr
#' @param json_file The metadata file. This should be a json download from the
#' metadata catalogue. By default, 'data/json_metadata.rda' is used - run
#' '?json_metadata' to see how it was created.
#' @param output_dir The path to the directory where the two output files
#' will be saved. By default, the current working directory is used.
#' @return The function will return two files, 'BROWSE_table_' and 'BROWSE_bar'
#' which gives summary informatin for this dataset and can be used as reference
#' when running the MapMetadata function. Open these outputs in a browser.
#' @export
#' @importFrom dplyr %>% add_row
#' @importFrom rjson fromJSON
#' @importFrom cli cli_alert_info
#' @importFrom plotly plot_ly layout
#' @importFrom htmlwidgets saveWidget
#' @importFrom tidyr pivot_longer

browseMetadata <- function(json_file,output_dir = NULL) {

  # DEFINE INPUTS AND OUTPUTS ----

  ## Read in the json file containing the meta data
  meta_json <- fromJSON(file = json_file)

  ## Set output_dir to current wd if user has not provided it
  if (is.null(output_dir)) {
    output_dir = getwd()
  }
  ## Extract Dataset from json_file
  Dataset <- meta_json$dataModel
  Dataset_Name <- Dataset$label
  dataset_version <- meta_json[["dataModel"]][["documentationVersion"]]

  # PREPARE 2 OUTPUT DATAFRAMES FOR LATER PLOTTING ----

  ## 1. Information about dataset and each table
  dataset_desc <- data.frame(N = character(0), Name = character(0),
                       Description = character(0))
  ### add information about the dataset at the top
  dataset_desc <- dataset_desc %>% add_row(N = '',Name = Dataset$label,
                          Description = gsub('\n\n', '', Dataset$description))
  dataset_desc <- dataset_desc %>%
    add_row(N = 'N',Name = 'Table',Description = '')

  ## 2. Counts of empty description fields for each table
  count_empty <- data.frame(Empty = c('No','Yes'))

  # LOOP THROUGH EACH TABLE IN DATASET ----

  ntables <- length(Dataset$childDataClasses)
  ntables_digits <- nchar(ntables)

  for (dc in 1:ntables) {
    cat("\n")
    Table_name <- Dataset$childDataClasses[[dc]]$label
    cli_alert_info(paste0("Processing Table {dc} of {ntables} (",
                          Table_name,")"))

    ## Add to the dataset_desc data frame
    dataset_desc <- dataset_desc %>% add_row(
      N = as.character(dc),
      Name = Table_name,
      Description = gsub('\n\n', '',Dataset$childDataClasses[[dc]]$description))

    ## Use 'json_table_to_df.R' to extract table from meta_json into a df
    Table_df <- json_table_to_df(Dataset = Dataset,n = dc)

    ## Use 'count_empty_desc.R' to count number of empty descriptions
    Table_colname <- paste0(Table_name,'(',dc,')')
    count_empty_table <- count_empty_desc(Table_df,Table_colname)

    ## Add to group dataframe for later plotting
    count_empty[[Table_colname]] <- count_empty_table[[Table_colname]]

  } # end of loop through each table

  # 1. TABLE SUMMARISING THE DATASET ----

  ## Create a matrix for cell colors
  cell_colors <- matrix("white", nrow = nrow(dataset_desc) + 1,
                        ncol = ncol(dataset_desc))
  cell_colors[2, ] <- "lightgrey"  # Change the color of the second row

  table_fig <- plot_ly(
    type = 'table',
    columnorder = c(0,1,2),
    columnwidth = c(ntables_digits, max(nchar(dataset_desc$Name)), 100),
    header = list(
      values = c("", "Dataset", "Description"),
      align = c("center", "center", "center"),
      line = list(width = 1, color = 'black'),
      fill = list(color = c("grey", "grey")),
      font = list(family = "Arial", size = 14, color = "white")
    ),
    cells = list(
      values = rbind(t(as.matrix(unname(dataset_desc)))),
      align = c("center", "center", "left"),
      line = list(color = "black", width = 1),
      fill = list(color = apply(cell_colors, 2, as.list)),  # Apply cell colors
      font = list(family = "Arial", size = 12, color = c("black"))
    )
  )

  ## Save the plot to a temporary HTML file
  table_fname <- paste0("BROWSE_table_",gsub(" ", "", Dataset_Name),"_V",
                        dataset_version,".html")
  saveWidget(widget = table_fig, file = table_fname, selfcontained = TRUE)
  ## Move temp file to desired dir (issue with saveWidget means 2 steps needed)
  file.rename(table_fname, paste0(output_dir, "/",table_fname))

  # 2. BAR CHART DISPLAYING COUNTS OF MISSING DESCRIPTIONS FOR ALL TABLES ----
  count_empty_long <- count_empty %>%
    pivot_longer(cols = -Empty, names_to = "Table", values_to = "N_Variables")

  empty_fig <- plot_ly(count_empty_long,
                       x = ~Table,
                       y = ~N_Variables,
                       color = ~Empty,
                       colors = c("grey","darkturquoise"),
                       type = 'bar',
                       text = ~N_Variables,
                       textposition = 'inside', # Position text inside the bars
                       texttemplate = '%{text}', # Ensure text displayed as is
                       textfont = list(color = 'black',size = 10)) %>%
    layout(barmode = 'stack',
           title = paste0('\n',Dataset_Name,' contains ',ntables,' tables'),
           xaxis = list(title = 'Table'),
           yaxis = list(title = 'N_Variables'),
           legend = list(title = list(text = 'Empty Description')))

  ## Save the plot to a temp HTML file
  bar_fname <- paste0("BROWSE_bar_",gsub(" ", "", Dataset_Name),"_V",
                        dataset_version,".html")
  saveWidget(widget = empty_fig, file = bar_fname, selfcontained = TRUE)
  ## Move temp file to desired dir (issue with saveWidget means 2 steps needed)
  file.rename(bar_fname, paste0(output_dir,"/",bar_fname))

  ## Save the data that made the bar plot to a csv file
  bar_fname <- paste0("BROWSE_bar_",gsub(" ", "", Dataset_Name),"_V",
                      dataset_version,".csv")
  write.csv(count_empty_long,paste0(output_dir,"/",bar_fname),row.names = FALSE)

  cat ("\n")
  cli_alert_info("Three outputs have been saved to your output directory.")
  cli_alert_info("Open the two html files in your browser for full screen viewing.")
  cat ("\n")

  list(table_fig = table_fig, empty_fig = empty_fig)

} # end of function
