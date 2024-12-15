.DEFAULT_GOAL := report/final_report.html

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
	rm -f outputs/*.rds
	rm -f outputs/*.png
	rm -f *.html
	rm -f *.pdf
	rm -rf report
	rm -rf final_proj_img

install:
	Rscript -e "renv::restore(prompt = FALSE)"


print-os:
	echo $(OS)


	
PROJECTFILES = final_report.Rmd codes/00_clean_data.R codes/01_descriptive.R codes/02_analysis.R codes/10_render_report.R data/cirrhosis.csv
RENVFILES = renv.lock renv/activate.R renv/settings.json .Rprofile
# Set volume mount path prefix based on OS
ifeq ($(OS), MAC)
	PREFIX := 
else 
	PREFIX := /
endif

final_proj_img: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t leshanzhao333/final_proj .
	touch $@

test:
	touch test.test
	echo $(os)

report/final_report.html:
	docker run -v $(PREFIX)"$$(PWD)/report":/home/rstudio/project/report leshanzhao333/final_proj




