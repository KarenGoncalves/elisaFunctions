% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_model.R
\name{get_model}
\alias{get_model}
\title{Removes background}
\usage{
get_model(condition_column, measure_column, plate_column,
  concentration_column, data)
}
\arguments{
\item{condition_column}{name of the column where the conditions are listed}

\item{measure_column}{name of the column where the measures, corrected by removing the background, are recorded}

\item{plate_column}{column in data that indicates from which plate each data comes from}

\item{concentration_column}{name of the column where the measures are recorded}

\item{data}{name of the dataframe with condition_column and measure_column}
}
\value{
a list with: 1) list that contains the plot and the function of the curve, 2) a lm result (the model)
}
\description{
Calculates the linear regression for a numeric measure (measure_column) in function of a numeric condition (condition_column)
}
