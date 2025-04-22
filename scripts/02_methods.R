"This script is for methods.

Usage:
  02_methods.R --input=<data> --out_dir=<out_dir>

Options:
  --input=<data>    Input data
  --out_dir=<out_dir>   Path to save cleaned data rds file
" -> doc

library(docopt)
library(tidyverse)

opt <- docopt(doc)

methods <- function(input, out_dir) {

    # load the data
    data <- readRDS(input)

    # Summary statistics
    glimpsed <- glimpse(data)
    write_csv(glimpsed, file.path(out_dir, "glimpsed.csv"))

    summarized <- summarise(data, mean_bill_length = mean(bill_length_mm), mean_bill_depth = mean(bill_depth_mm))
    write_csv(summarized, file.path(out_dir, "summarized.csv"))

    # Visualizations
    eda <- ggplot(data, aes(x = species, y = bill_length_mm, fill = species)) +
    geom_boxplot() +
    theme_minimal()

    ggsave(file.path(out_dir, "eda.png"), eda, width = 9, height = 6, dpi = 300)
    # Prepare data for modeling
    data <- data %>%
        select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
        mutate(species = as.factor(species))

    saveRDS(data, file = file.path(out_dir, "penguins_model_data.rds"))

}

methods(opt$input, opt$out_dir)
