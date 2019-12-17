#' Get concentration from absorbance data
#'
#' After calculating the model with get_model, it uses the measured values of absorbance (with background subtracted already) to get the concentration
#' @param treatments vector with strings for each condition/treatment in the study
#' @param condition_column name of the column where the conditions are listed
#' @param measure_column name of the column where the measures, corrected by removing the background, are recorded
#' @param plate_column column in data that indicates from which plate each data comes from
#' @param model named list of lm models, the names of the list should be the same as the strings in
#' @param data name of the dataframe with condition_column and measure_column
#' @return a data frame equal to the one entered (as data), but with an additional column with the concentration
#' @export
#' @name get_concentration

get_concentration <- function(treatments, condition_column, measure_column, plate_column, model, data){

  plate_col <- ifelse(is.numeric(plate_column),
                      plate_column,
                      which(colnames(data) == plate_column))
  cond_col <- ifelse(is.numeric(condition_column),
                     condition_column,
                     which(colnames(data) == condition_column))
  meas_col <- ifelse(is.numeric(measure_column),
                     measure_column,
                     which(colnames(data) == measure_column))

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

    plates[[i]]$concentration <- measures
    plates[[i]]$plate <- rep(i, dim(plates[[i]])[2])

  }

  concentration_df <- do.call(rbind, plates)
  return(concentration_df)
}
