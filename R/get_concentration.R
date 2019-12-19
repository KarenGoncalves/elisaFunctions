#' Get concentration from absorbance data
#'
#' After calculating the model with get_model, it uses the measured values of absorbance (with background subtracted already) to get the concentration
#' @param treatments vector with strings for each condition/treatment in the study
#' @param condition_column name of the column where the conditions are listed
#' @param measure_column name of the column where the measures, corrected by removing the background, are recorded
#' @param plate_column column in data that indicates from which plate each data comes from
#' @param model named list of lm models (second object of the result of 'get_model'), the names of the list should be the same as the strings in
#' @param data name of the dataframe with condition_column and measure_column
#' @return a data frame equal to the one entered (as data), but with an additional column with the concentration
#' @export
#' @name get_concentration

get_concentration <- function(treatments, condition_column, measure_column, plate_column, concentration_column, model, data){

  cond_col <- which(colnames(data) == condition_column)
  meas_col <- which(colnames(data) == measure_column)
  plate_col <- which(colnames(data) == plate_column)
  conc_col <- which(colnames(data) == concentration_column)

  plates <- list()
  for (i in unique(data[, plate_col])){
    data_plate <- data[data[, plate_col] == i, ]
    plates[[i]] <-
      data.frame(data_plate[data_plate[, cond_col] %in% treatments,])

    measures <- c()
    for (m in 1:nrow(plates[[i]])){
      measures <- c(measures,
                    (coef(model[[i]])[[2]] * plates[[i]][m, meas_col] +
                       coef(model[[i]])[[1]]))
    }

    plates[[i]][, conc_col] <- measures

  }

  concentration_df <- do.call(rbind, plates)
  return(concentration_df)
}
