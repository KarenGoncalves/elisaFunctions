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

rmbg_gm_gc <- function(data, background, treatments, condition_column, measure_column, plate_column, concentration_column){

  plates <- list()
  cond_col <- which(colnames(data) == condition_column)
  meas_col <- which(colnames(data) == measure_column)
  plate_col <- which(colnames(data) == plate_column)
  conc_col <- which(colnames(data) == concentration_column)

  for (i in unique(data[, plate_col])){
    data_plate <- data[data[, plate_col] == i, ]

    data_nobg <- remove_background(background = background,
                                   treatments = treatments,
                                   condition_column = condition_column,
                                   measure_column = measure_column,
                                   plate_column = plate_column,
                                   data = data_plate)

    modeling <-  get_model(condition_column = condition_column,
                           measure_column = measure_column,
                           plate_column = plate_column,
                           data = data_nobg,
                           concentration_column = concentration_column)

    plates[[i]] <- get_concentration(treatments = treatments,
                                     condition_column = condition_column,
                                     measure_column = paste0('new_', measure_column),
                                     plate_column = plate_column,
                                     concentration_column = concentration_column,
                                     model = modeling[[2]],
                                     data = data_nobg)

  }

  final <- do.call(rbind, plates)
  return(final)
}
