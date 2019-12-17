#' Removes background from absorbance data
#'
#' This function allows you to subtract the background (when it was measured) for all other measures
#' @param background string in the condition column that indicates which measures are the blank
#' @param treatments vector with strings for each condition/treatment in the study
#' @param condition_column name of the column where the conditions are listed
#' @param measure_column name of the column where the measures, corrected by removing the background, are recorded
#' @param plate_column column in data that indicates from which plate each data comes from
#' @param data name of the dataframe with condition_column and measure_column
#' @name remove_background
#' @export

remove_background <- function(background, treatments, condition_column, measure_column, plate_column, data){

  plates <- list()
  plate_col <- ifelse(is.numeric(plate_column),
                      plate_column,
                      which(colnames(data) == plate_column))
  cond_col <- ifelse(is.numeric(condition_column),
                     condition_column,
                     which(colnames(data) == condition_column))
  meas_col <- ifelse(is.numeric(measure_column),
                     measure_column,
                     which(colnames(data) == measure_column))

  if (is.numeric(data[, meas_col]) == F){
    stop("Your data in the column of measures is not numeric.")
  }

  for (i in unique(plate_column)){
    plates[[i]]$new_data <- plates[[i]]$data <- data[data[, plate_col] == i, ]

    new_measure <- paste0('new_', measure_column)
    plates[[i]]$new_data$new_measure <-
      plates[[i]]$data[, meas_col]
    plates[[i]]$new_data$new_measure <-
      as.numeric(plates[[i]]$new_data$new_measure)

    colnames(plates[[i]]$new_data)[ncol(plates[[i]]$new_data)] <-
      new_measure
    plates[[i]]$mean_background <-
      mean(plates[[i]]$data[plates[[i]]$data[, cond_col] == background, meas_col])

    for (t in treatments){
      for (measure in rownames(plates[[i]]$data[plates[[i]]$data[, cond_col] == t,])){
        plates[[i]]$new_data[measure, ncol(plates[[i]]$new_data)] <-
          plates[[i]]$data[measure, meas_col] - plates[[i]]$mean_background
      }
    }

    plates[[i]]$new_data$plate <- rep(i, length(plates[[i]]$new_data))
    plates[[i]] <- plates[[i]]$new_data

  }
  corrected <- do.call(rbind, plates)
  return(corrected)
}
