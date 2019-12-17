#' Removes background
#'
#' Calculates the linear regression for a numeric measure (measure_column) in function of a numeric condition (condition_column)
#' @param condition_column name of the column where the conditions are listed
#' @param measure_column name of the column where the measures, corrected by removing the background, are recorded
#' @param plate_column column in data that indicates from which plate each data comes from
#' @param concentration_column name of the column where the measures are recorded
#' @param data name of the dataframe with condition_column and measure_column
#' @name get_model
#' @return a list with: 1) list that contains the plot and the function of the curve, 2) a lm result (the model)
#' @export
#'

get_model <- function(condition_column, measure_column, plate_column, concentration_column, data){

  plate_col <- ifelse(is.numeric(plate_column),
                      plate_column,
                      which(colnames(data) == plate_column))
  cond_col <- ifelse(is.numeric(condition_column),
                     condition_column,
                     which(colnames(data) == condition_column))
  cond_col <- ifelse(is.numeric(condition_column),
                     condition_column,
                     which(colnames(data) == condition_column))
  meas_col <- ifelse(is.numeric(measure_column),
                     measure_column,
                     which(colnames(data) == measure_column))

  plates <- list()
  model <- list()

  conc_rows <- !is.na(as.numeric(data[, cond_col]))

  for (i in unique(data[, plate_col])){
    plates[[i]] <- list()

    plotting <-
      data.frame(value = data[conc_rows, meas_col],
                 condition = as.numeric(as.character(data[conc_rows, cond_col])))

    model[[i]] <- lm(value ~ condition, data = plotting)

    plates[[i]]$plot <-
      ggplot2::ggplot(plotting) +
      geom_point(aes(condition, value)) +
      geom_abline(slope = coef(model[[i]])[[2]],
                  intercept = coef(model[[i]])[[1]])

    plates[[i]]$formula = paste('y =', coef(model[[i]])[[2]],
                                '* x +', coef(model[[i]])[[1]])

  }

  return(list(plates, model))
}
