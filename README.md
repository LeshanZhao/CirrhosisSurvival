
# Data Science Project: Survival Analysis in Clinical Trial for Cirrhosis Treatment

Author: Leshan Zhao
Last updated: 15 Dec 2024

## Data
The data for this project contains is from Cirrhosis Clinical Trial Dataset obtained from Kaggle, containing 18 clinical features used to predict the survival state of patients with liver cirrhosis, including demographic details like age and sex, and clinical markers such as urine Albumin, Copper, and alkaline phosphatase levels. The dataset was created to analyze the effects of prolonged liver damage, which often results from conditions such as hepatitis or chronic alcohol consumption. This study aims to explore the relationships between clinical variables and patient survival outcomes, as well as to identify key predictors for liver cirrhosis stage.

The dataset includes patients from a Mayo Clinic study on primary biliary cirrhosis (PBC) of the liver, carried out from 1974 to 1984. During 1974 to 1984, 424 PBC patients referred to the Mayo Clinic qualified for the randomized placebo-controlled trial testing the drug D-penicillamine. Of these, the initial 312 patients took part in the trial and have mostly comprehensive data. The remaining 112 patients didn't join the clinical trial but agreed to record basic metrics and undergo survival tracking. Six of these patients were soon untraceable after their diagnosis, leaving data for 106 of these individuals in addition to the 312 who were part of the randomized trial.
Our primary objective is to understand the impact of various clinical features on patient outcomes, particularly in terms of survival and cirrhosis progression.


## Descriptive Statistics
We aim to conduct a descriptive analysis on summarizing the numeric and categorical features in cirrhosis dataset, and visualize the distribution of Age by Survival State, Number of Days before event, and the age distribution itself. Also, we quickly checked the overall survival of patients and survival by treatment, using K-M plots.

## Final Report
Our final report will include detailed decription of dataset and its variables, the descriptive statistics and in the future, the statistical data analysis. The user can create the report by using command `make final_report.html` in command line, or simply `make`.
------------------------------------------------------------------------
!!! This Docker-R automatic workflow is designed for WINDOWS !!!
------------------------------------------------------------------------
Prerequisites: 
- GNU make
- Windows Operating System
- (MAC/Unix-Like System is not guaranteed to work.)
------------------------------------------------------------------------
------------------------------------------------------------------------
## Usage: (Recommended) 
- Option 1: Run workflow in Docker. 
- Extra prerequisites: Docker

#### Create Report
To create the report, the user can run command 
- `make report/final_report.html` in command line, or simply
- `make`, under the project root directory.
- The generated report will be found in the `/report` folder under  project root directory.
- Windows CMD is recommended; 
- Windows Powershell / Windows Git Bash and MAC/Unix-like shells are also supported.

# IMPORTANT: For MAC/Linux/Other Unix users , the user should add a parameter `OS=MAC` when running make. Possible command include:
- `make OS=MAC`
- `make report/final_report.html OS=MAC`
- `make OS=MAC report/final_report.html`


#### Synchronize Package Repository
To synchronize the package repository, the user can run `make install` under the project root directory; 
- Or, alternatively, go to project root directory and run `source("renv/activate.R")` followed by `renv::restore()` in R console.
- This step is completely not required under this option.

####  How to Build the Docker image
If the user wants to build the docker image locally, the user can run command 
- `make final_proj_img` in command line, under the project root directory.
- 
------------------------------------------------------------------------

## Usage: 
- Option 2: Run workflow locally.

#### Create Report
To create the report by running the workflow locally, the user can run command `make final_report.html` in command line, under the project root directory.
- The generated report will be found in the project root directory.

#### Synchronize Package Repository
To synchronize the package repository, the user can run `make install` under the project root directory; 
- Or, alternatively, go to project root directory and run `source("renv/activate.R")` followed by `renv::restore()` in R console.
- This step is not required explicitly.


------------------------------------------------------------------------

## Code Structure

`codes/00_clean_data.R`

  - Reads in the raw dataset
  - Creates a `event` varaible that is set to 1 to indicate death, if `Status` of that patient is equal to "D", and 0 to indicate censoring (`Status` = either `C` or `CL`).
  - Remove lines containing `NA` values.
  - Creates a `DIED` variable that is set to 1 if ```DATE_DIED``` is not NA and 0 if the variable is NA.
  - Cast the treatment groups to factor and rename it from `Drug` to `Treatment`.
  - Save the cleaned dataset as `data_clean.rds` in `outputs/` folder

`codes/01_descriptive.R`: creates all tables and graphs related to descriptive analysis.

  - Creates `table_numeric` with descriptive statistics on numeric characteristics.
  - Creates frequency table `table_categorical` with descriptive statistics on categorical characteristics.
  - Creates `plot_ageByState.rds`, `plot_NDaysHIST.rds`, and `plot_AgeHIST.rds`.
  - Creates `plot_KMOverall.rds` and `plot_KMbyTrt.rds`.
  - Creates `plot_KMOverall.png` and `plot_KMbyTrt.png`. This is a backup for machines that have problem with `ggplot` library.
  - All tables and graphs should be saved in the `outputs/` folder

`codes/02_analysis.R`: be responsible for later statistical analysis.

`codes/10_render_report.R`: Renders the report and create "final_report.html" in the project root directory.

`report.Rmd`

  - Produces 2 descriptive analysis tables
  - Produces 3 Charts and 2 K-M Plots.

------------------------------------------------------------------------

 
The Makefile, Rmarkdown (`report.Rmd`), and HTML report will be in the root directory of the project. The Rmarkdown will contain the tables and figures produced in the analysis.




