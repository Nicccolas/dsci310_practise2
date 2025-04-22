"This script is for the model

Usage:
  03_model.R --input=<data> --out_dir=<out_dir>

Options:
  --input=<data>    Input data
  --out_dir=<out_dir>   Path to save cleaned data rds file
" -> doc

library(docopt)
library(tidyverse)
library(tidymodels)
library(kknn)

opt <- docopt(doc)

methods <- function(input, out_dir) {

    # load model data
    data <- readRDS(input)

    # Split data
    set.seed(123)
    data_split <- initial_split(data, strata = species)
    train_data <- training(data_split)
    test_data <- testing(data_split)

    saveRDS(test_data, file = file.path(out_dir, "test_data.rds"))

    # Define model
    penguin_model <- nearest_neighbor(mode = "classification", neighbors = 5) %>%
    set_engine("kknn")

    # Create workflow
    penguin_workflow <- workflow() %>%
    add_model(penguin_model) %>%
    add_formula(species ~ .)

    # Fit model
    penguin_fit <- penguin_workflow %>%
    fit(data = train_data)

    saveRDS(penguin_fit, file = file.path(out_dir, "model.rds"))
}

methods(opt$input, opt$out_dir)