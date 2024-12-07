% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_manipulation.R
\name{join_outputs}
\alias{join_outputs}
\title{join_outputs}
\usage{
join_outputs(session_1, session_2)
}
\arguments{
\item{session_1}{Dataframe from session 1}

\item{session_2}{Dataframe from session 2}
}
\value{
Dataframe with information from session 1 and 2, joined on column DataElement.
}
\description{
Internal Function: This function is called within the map_metadata_compare function. \cr \cr
Joins output dataframes from two sessions, on the column DataElement.
}
\keyword{internal}
