"This script loads and cleans the dataset.

Usage:
  01_load_data.R --out_dir=<out_dir>

Options:
  --out_dir=<out_dir>   Path to save cleaned data rds file
" -> doc

library(docopt)
library(tidyverse)
library(palmerpenguins)

opt <- docopt(doc)

load_data <- function(out_dir) {

    data <- penguins

    data <- data %>% drop_na()

    saveRDS(data, file = file.path(out_dir, "penguins_cleaned.rds"))
}

load_data(opt$out_dir)

