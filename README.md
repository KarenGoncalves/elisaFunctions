# elisaFunctions

Prepare a table that looks like this

| plate | condition | abs_390 | concentration390 | abs_750 | concentration750  |
|:-----:|:---------:|:-------:|:----------------:|:-------:|:-----------------:|
| 1 | Standard | 0.07 | 0 | 0.084 | 0  |
| 1 | Standard | 0.071 | 0 | 0.065 | 0  |
| 1 | Standard | 0.069 | 0 | 0.069 | 0  |
| 1 | Standard | 0.115 | 25 | 0.102 | 0.2  |
| 1 | Standard | 0.107 | 25 | 0.101 | 0.2  |
| 1 | Standard | 0.106 | 25 | 0.105 | 0.2  |
| 1 | Standard | 0.14 | 50 | 0.145 | 0.5  |
| 1 | Standard | 0.129 | 50 | 0.147 | 0.5  |
| 1 | Standard | 0.125 | 50 | 0.151 | 0.5  |
| 1 | Standard | 0.223 | 100 | 0.177 | 0.75  |
| 1 | Standard | 0.209 | 100 | 0.194 | 0.75  |
| 1 | Standard | 0.197 | 100 | 0.181 | 0.75  |
| 1 | Standard | 0.319 | 150 | 0.095 | 1  |
| 1 | Standard | 0.314 | 150 | 0.224 | 1  |
| 1 | Standard | 0.293 | 150 | 0.224 | 1  |
| 1 | Standard | 0.35 | 200 | 0.26 | 1.25  |
| 1 | Standard | 0.346 | 200 | 0.262 | 1.25  |
| 1 | Standard | 0.346 | 200 | 0.262 | 1.25  |
| 1 | Standard | 0.399 | 250 | 0.284 | 1.5  |
| 1 | Standard | 0.396 | 250 | 0.284 | 1.5  |
| 1 | Standard | 0.402 | 250 | 0.302 | 1.5  |
| 1 | background | 0.176 | NA | NA  | NA  |
| 1 | background | 0.175 | NA |  NA |  NA  |
| 1 | background | 0.173 | NA |  NA |  NA  |
| 1 | wt | 0.218 | NA | 0.258 | NA  |
| 1 | wt | 0.212 | NA | 0.25 | NA  |
| 1 | wt | 0.208 | NA | 0.254 | NA  |
| 1 | AC1C3 | 0.413 | NA | 0.212 | NA  |
| 1 | AC1C3 | 0.404 | NA | 0.185 | NA  |
| 1 | AC1C3 | 0.394 | NA | 0.158 | NA  |

# Install the package

```
  if (!'devtools' %in% rownames(installed.packages())){
      install.packages('devtools')}
  library('devtools')
  if (!'elisaFunctions' %in% rownames(installed.packages())){
      devtools::install_github('KarenGoncalves/elisaFunctions')}
  library('elisaFunctions')
```

# Running the functions

If all you want is the table of concentrations, do:

result <- rmbg_gm_gc(data, background, treatments, condition_column, measure_column, plate_column, concentration_column)

Using the table shown here as an example, the code would be:

```
  result <- rmbg_gm_gc(
        data = table_above, # name of the data frame
        background = 'background', # The text in the condition column that identifies that line as the blank
        treatments = c('wt', 'AC1C3'), # The text in the condition column that identifies that line as the measure of interest
        condition_column = 'condition', 
        measure_column = 'abs_390', 
        plate_column = 'plate', 
        concentration_column = 'concentration390')
```

Now, if you want the table where the background absorbance was subtracted from your treatments, a plot of the standard curve for each plate and the final concentration table, you have to run the three functions of the package separately. Again, using the table above as example, the code would be:

```
no_background <- remove_background(
                  background = 'background', # The text in the condition column that identifies that line as the blank, 
                  treatments = c('wt', 'AC1C3'), # The text in the condition column that identifies that line as the measure of interest
                  condition_column = 'condition', 
                  measure_column = 'abs_390', 
                  plate_column = 'plate', 
                  data = table_above, # name of the data frame)
## no_background is the same table as the one used as input to the function, but with a new collumn called 'new_abs_390' (the text 'new_' will be attached to the name of the condition column entered in the function)

standard_curves <- get_model(
                    condition_column = 'condition', 
                    measure_column = 'abs_390', 
                    plate_column = 'plate', 
                    concentration_column = 'concentration390', 
                    data = table_above, # name of the data frame)
## standard_curves will be a list of lists. Each object of the list is a list for each plate. In this case, standard_curves[[1]] would be the result for the first plate. 
## standard_curves[[1]][[1]] is the plot of the standard curve, the title is the equation of the curve. 
## standard_curves[[1]][[2]] is the linear model result (the equation of the curve), it will be used to calculate the concentration table.

 concentration_table <- get_concentration(
                          treatments = c('wt', 'AC1C3'), 
                          # treatments should be a vector with the text in the condition column that identifies that line as the measure of interest
                          condition_column = 'condition', 
                          measure_column = 'new_abs_390', # Use the column with corrected absorbance
                          plate_column = 'plate', 
                          concentration_column = 'concentration390', 
                          model = standard_curves, 
                          data = no_background)
                          
## The concentration_table includes only the lines for the treatments (background and standards are omitted).

```
