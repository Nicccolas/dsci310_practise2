"This script is for the results

Usage:
  04_results.R --input=<data> --test=<test_data> --out_dir=<out_dir>

Options:
  --input=<data>    Input data
  --test=<test_data>  testing data
  --out_dir=<out_dir>   Path to save cleaned data rds file
" -> doc

library(docopt)
library(tidyverse)
library(tidymodels)

opt <- docopt(doc)

results <- function(input, test, out_dir) {

    # load the model
    penguin_fit <- readRDS(input)
    test_data <- readRDS(test)

    # Predict on test data
    predictions <- predict(penguin_fit, test_data, type = "class") %>%
    bind_cols(test_data)

    # Confusion matrix
    conf_mat <- conf_mat(predictions, truth = species, estimate = .pred_class)
    
    saveRDS(conf_mat, file = file.path(out_dir, "conf_mat.rds"))
}

results(opt$input, opt$test, opt$out_dir)