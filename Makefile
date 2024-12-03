
final_report.html: codes/10_render_report.R \
  final_report.Rmd \
  descriptive
	Rscript codes/10_render_report.R

outputs/data_clean.rds: codes/00_clean_data.R data/cirrhosis.csv 
	Rscript codes/00_clean_data.R
	
descriptive: \
outputs/table_numeric.rds \
outputs/table_categorical.rds\
outputs/plot_ageByState.rds \
outputs/plot_NDaysHIST.rds \
outputs/plot_AgeHIST.rds \
outputs/plot_KMOverall.png \
outputs/plot_KMOverall.rds \
outputs/plot_KMbyTrt.png \
outputs/plot_KMbyTrt.rds

outputs/table_numeric.rds \
outputs/table_categorical.rds\
outputs/plot_ageByState.rds \
outputs/plot_NDaysHIST.rds \
outputs/plot_AgeHIST.rds \
outputs/plot_KMOverall.png \
outputs/plot_KMOverall.rds \
outputs/plot_KMbyTrt.png \
outputs/plot_KMbyTrt.rds: \
codes/01_descriptive.R outputs/data_clean.rds
	Rscript codes/01_descriptive.R


.PHONY: clean install
clean:
	rm -f outputs/*.rds && \
	rm -f outputs/*.png && \
	rm -f *.html && \
	rm -f *.pdf

install:
    Rscript -e "renv::restore(prompt = FALSE)"