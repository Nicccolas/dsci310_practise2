.PHONY: all clean

all: outputs/penguins_cleaned.rds outputs/glimpsed.csv outputs/summarized.csv outputs/penguins_model_data.rds outputs/model.rds outputs/conf_mat.rds \
	reports/analysis.html reports/analysis.pdf index.html

outputs/penguins_cleaned.rds: scripts/01_load_data.R
	Rscript scripts/01_load_data.R --out_dir="outputs"

outputs/glimpsed.csv outputs/summarized.csv outputs/penguins_model_data.rds: scripts/02_methods.R
	Rscript scripts/02_methods.R --input="outputs/penguins_cleaned.rds" --out_dir="outputs"

outputs/model.rds outputs/test_data.rds: scripts/03_model.R
	Rscript scripts/03_model.R --input="outputs/penguins_model_data.rds" --out_dir="outputs"

outputs/conf_mat.rds: scripts/04_results.R
	Rscript scripts/04_results.R --input="outputs/model.rds" --test="outputs/test_data.rds" --out_dir="outputs"


# render quarto report 
reports/analysis.html: reports/analysis.qmd 
	quarto render reports/analysis.qmd --to html

reports/analysis.pdf: reports/analysis.qmd 
	quarto render reports/analysis.qmd --to pdf

index.html: reports/analysis.html
	cp reports/analysis.html index.html


clean: 
	rm -rf outputs/* \
	reports/analysis.html \
	reports/analysis.pdf \
	docs/index.html
