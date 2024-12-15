FROM rocker/rstudio:4.4.1

RUN mkdir /home/rstudio/project

WORKDIR /home/rstudio/project

RUN mkdir -p renv
COPY renv.lock .
COPY .Rprofile .
COPY renv/activate.R renv
COPY renv/settings.json renv

RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE=renv/.cache

RUN R -e "renv::restore()"


#copy all relevant files 
RUN mkdir codes
RUN mkdir outputs
RUN mkdir data
RUN mkdir report

COPY codes codes
COPY data data
COPY Makefile .
COPY final_report.Rmd .

CMD ["sh", "-c", "make final_report.html && mv final_report.html /home/rstudio/project/report"]

