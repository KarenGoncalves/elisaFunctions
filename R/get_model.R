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

  cond_col <- which(colnames(data) == condition_column)
  meas_col <- which(colnames(data) == measure_column)
  plate_col <- which(colnames(data) == plate_column)
  conc_col <- which(colnames(data) == concentration_column)

  plates <- list()
  model <- list()

  conc_rows <- which(data[, cond_col] == 'Standard')

  for (i in unique(data[, plate_col])){

    plotting <-
      data.frame(value = as.numeric(data[conc_rows, meas_col]),
                 condition = as.numeric(data[conc_rows, conc_col]))

    model[[i]] <- lm(value ~ condition, data = plotting)

    plates[[i]] <-
      ggplot2::ggplot(plotting) +
      geom_point(aes(condition, value)) +
      geom_abline(slope = coef(model[[i]])[[2]],
                  intercept = coef(model[[i]])[[1]]) +
      labs(x = 'Concentration', y = 'Absorbance', title = paste('Equation of the curve\n',
                                                                'y =', coef(model[[i]])[[2]],
                                                                '* x +', coef(model[[i]])[[1]]))

  }

  return(list(plates, model))
}
