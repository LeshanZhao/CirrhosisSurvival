library(dplyr)

# Here Command
here::i_am("codes/00_clean_data.R")

# Reads in Data
df_cirr = read.csv(here::here("data/cirrhosis.csv"), 
                   header = TRUE)


# Remove all cases with NA in any column
df_cirr = df_cirr %>% 
  filter(complete.cases(.)) %>%
  mutate(event = ifelse(Status == "D", 1, 0),
         Drug = factor(Drug)) %>%
  rename(Treatment = Drug) %>%
  rename()

# Save onto the output folder
saveRDS(df_cirr, 
        file = here::here("outputs/data_clean.rds"))
