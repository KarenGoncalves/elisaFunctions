#' Remove background, get model, get concentration
#'
#' This function removes background absorbance from absorbance measured in each treatment (exported as first object of the list),
#' then it calculates the standard curve from the values in lines for which the condition is a number (considered the known concentration),
#' the curve is exported as the second object of the list.
#' Finally, it uses the measured values of absorbance (with background subtracted already)
#' to get the concentration and saves it to a data frame (only the for the treatments),
#' this data frame is the third object of the list
#' @param data name of the dataframe with condition_column and measure_column
#' @param background string in the condition column that indicates which measures are the blank
#' @param treatments vector with strings for each condition/treatment in the study
#' @param condition_column name of the column where the conditions are listed
#' @param plate_column column in data that indicates from which plate each data comes from
#' @param measure_column name of the column where the measures, corrected by removing the background, are recorded
#' @export
#' @name rmbg_gm_gc

rmbg_gm_gc <- function(data, background, treatments, condition_column, measure_column, plate_column){

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

  for (i in unique(plate_column)){
    plates[[i]]$data <- data[data[, plate_col] == i, ]

    plates[[i]]$model_cond <-
      plates[[i]]$data[!is.na(as.numeric(plates[[i]]$data[, cond_col])), ]

    plates[[i]]$model_cond[, cond_col] <-
      as.numeric(plates[[i]]$model_cond[, cond_col])

    plates[[i]]$data_nobg <- remove_background(background = background ,
                                               treatments = treatments,
                                               condition_column = cond_col,
                                               measure_column = meas_col,
                                               data = plates[[i]]$data)

    plates[[i]]$modeling <-  curve(condition_column = cond_col,
                                   measure_column = meas_col,
                                   data = plates[[i]]$model_cond)

    plates[[i]]$final <- concentration(treatments = treatments, condition_column = cond_col,
                                       measure_column = ncol(plates[[i]]$data_corrected),
                                       model = plates[[i]]$modeling,
                                       data = plates[[i]]$data_nobg)

  }
  return(plates)
}
