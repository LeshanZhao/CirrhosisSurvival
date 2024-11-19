library(dplyr)
library(survival)
library(ggplot2)
here::i_am("codes/01_descriptive.R")

df = readRDS(
  file = here::here("outputs/data_clean.rds")
)

# Table summary for Numeric variables ====================
numeric_vars = df %>% select_if(is.numeric)

# Create summary tables
numeric_summary = sapply(numeric_vars, function(x) {
  c(
    mean = round(mean(x, na.rm = TRUE),1),
    min = round(min(x, na.rm = TRUE),1),
    median = round(median(x, na.rm = TRUE),1),
    max = round(max(x, na.rm = TRUE),1),
    n_NAs = round(sum(is.na(x)),1)
  )
})


# Display the summary tables in a well-formatted manner
numeric_table = knitr::kable(numeric_summary,
                             caption = "Summary of Numeric Clinical Features in Cirrhosis Prediction Dataset")

saveRDS(numeric_table,
  file = here::here("outputs/table_numeric.rds")
)



# Table summary for categorical variables ====================
categorical_vars = df %>% 
  select_if(~!is.numeric(.))
categorical_summary = lapply(categorical_vars, function(x) {
  as.data.frame(table(x))
})

combined_categorical_summary = do.call(rbind, categorical_summary)

# Display the summary tables in a well-formatted manner
categorical_table = knitr::kable(combined_categorical_summary,
                                 caption = "Summary of Categorical Clinical Features in Cirrhosis Prediction Dataset")
  
  
saveRDS(categorical_table,
  here::here("outputs/table_categorical.rds")
)




# Plots for visualizing data ===========================
# PLOT 1 - Boxplot showing age distribution by survival state
Age_by_Survival = 
  ggplot(df, aes(x = Status, y = Age)) +
  geom_boxplot() +
  labs(title = "Age Distribution by Survival State",
       x = "Survival State",
       y = "Age (Days)")
saveRDS(Age_by_Survival,
        file = "outputs/plot_ageByState.rds")

# PLOT 2 - Histogram of N_Days
HIST_N_Days = 
  ggplot(df, aes(x = N_Days)) +
  geom_histogram(binwidth = 100,  color = "black", alpha = 0.7) +
  labs(title = "Histogram of N_Days",
       x = "Number of Days",
       y = "Frequency")
saveRDS(HIST_N_Days,
        file = "outputs/plot_NDaysHIST.rds")

# PLOT 3 - Histogram of Age
HIST_Age = 
  ggplot(df, aes(x = Age)) +
  geom_histogram(binwidth = 500, color = "black", alpha = 0.7) +
  labs(title = "Histogram of Age",
       x = "Age (Days)",
       y = "Frequency")
saveRDS(HIST_Age,
        file = "outputs/plot_AgeHIST.rds")

# ## Backup - Plot 4 and Plot 5 using plot
# # PLOT 4 - Overall Survival
# png("outputs/plot_KMOverall.png", width=1440, height=1080)
# fit_KM_overall = survival::survfit(Surv(time = N_Days, event = event) ~ 1, data=df, conf.type = "plain")
# KM_Overall = 
#   plot(fit_KM_overall,
#      col=c(1,1,1),
#      lty=c(1,2,2),
#      lwd=2,
#      xlab = "Time from Treatment Administration （Days)",
#      ylab = "Survival Probability",
#      main = "K-M Plot - Overall Survival")
# legend("topright", legend=c("KM estimate", "95% CI"), lty=1:2,cex=0.7)
# KM_Overall = recordPlot()
# dev.off()
# saveRDS(KM_Overall,
#         file = "outputs/plot_KMOverall.rds")

# # PLOT 5 - Survival by Treatment Groups
# png("outputs/plot_KMbyTrt.png", , width=1440, height=1080)
# fit_KM_byTrt = survfit(Surv(time = N_Days, event = event) ~ Treatment, data=df, conf.type = "plain")
# KM_byTrt = 
#   plot(fit_KM_byTrt,
#      col=1:2,
#      lty=1,
#      lwd=2,
#      xlab = "Time from Treatment Administration （Days)",
#      ylab = "Survival Probability",
#      main = "K-M Plot - Overall Survival across Treatment groups")
# legend("topright", legend=c("D-penicillamine", "Placebo"), col = 1:2,lty=1,cex=0.7)
# KM_byTrt = recordPlot()
# dev.off()
# saveRDS(KM_byTrt,
#         file = "outputs/plot_KMbyTrt.rds")


# ## Backup - Plot 4 and Plot 5 using ggplot2
# Plot 4
fit_KM_overall <- survfit(Surv(time = N_Days, event = event) ~ 1, data = df)
# extract survival data
surv_data_overall <- data.frame(
  time = fit_KM_overall$time,
  surv = fit_KM_overall$surv,
  upper = fit_KM_overall$upper,
  lower = fit_KM_overall$lower
)
KM_Overall =
  ggplot(surv_data_overall, aes(x = time)) +
  geom_line(aes(y = surv), colour = "blue", linewidth = 1) +  # 生存曲线
  geom_ribbon(aes(ymin = lower, ymax = upper), fill = "blue", alpha = 0.2) +  # 置信区间
  labs(x = "Time from Treatment Administration (Days)",
       y = "Survival Probability",
       title = "K-M Plot - Overall Survival") +
  geom_line(aes(y = surv, colour = "KM estimate"), linewidth = 1) +
  geom_ribbon(aes(ymin = lower, ymax = upper, fill = "95% CI"), alpha = 0.2) +
  scale_color_manual(name = "Legend", values = c("KM estimate" = "blue")) +
  scale_fill_manual(name = "", values = c("95% CI" = "blue"))
saveRDS(KM_Overall,
        file = "outputs/plot_KMOverall.rds")
ggsave("outputs/plot_KMOverall.png")


# Plot 5
fit_KM_byTrt <- survfit(Surv(time = N_Days, event = event) ~ Treatment, data = df)
strata_info <- fit_KM_byTrt$strata
names_strata <- names(strata_info)
indexes <- cumsum(c(1, strata_info))
start_indexes <- indexes[-length(indexes)]
end_indexes <- indexes[-1] - 1
surv_data_list <- Map(function(start, end, name) {
  data.frame(
    time = fit_KM_byTrt$time[start:end],
    surv = fit_KM_byTrt$surv[start:end],
    strata = name
  )
}, start = start_indexes, end = end_indexes, name = names_strata)
surv_data_byTrt <- do.call(rbind, surv_data_list)
KM_byTrt =
  ggplot(surv_data_byTrt, aes(x = time, y = surv, color = strata)) +
  geom_line() +
  labs(x = "Time from Treatment Administration (Days)",
       y = "Survival Probability",
       title = "K-M Plot - Overall Survival across Treatment groups") +
  scale_color_manual(values = c("blue", "red"),
                     labels = c("D-penicillamine", "Placebo"))
saveRDS(KM_byTrt,
        file = "outputs/plot_KMbyTrt.rds")
ggsave("outputs/plot_KMbyTrt.png")

# # Plot 5-2: with 95% CI
# fit_KM_byTrt <- survfit(Surv(time = N_Days, event = event) ~ Treatment, data = df)
# strata_info <- fit_KM_byTrt$strata
# names_strata <- names(strata_info)
# indexes <- cumsum(c(1, strata_info))
# start_indexes <- indexes[-length(indexes)]
# end_indexes <- indexes[-1] - 1
# surv_data_list <- Map(function(start, end, name) {
#   data.frame(
#     time = fit_KM_byTrt$time[start:end],
#     surv = fit_KM_byTrt$surv[start:end],
#     upper = fit_KM_byTrt$upper[start:end],
#     lower = fit_KM_byTrt$lower[start:end],
#     strata = name
#   )
# }, start = start_indexes, end = end_indexes, name = names_strata)
# surv_data_byTrt <- do.call(rbind, surv_data_list)
# KM_byTrt =
#   ggplot(surv_data_byTrt, aes(x = time, y = surv, color = strata, fill = strata)) +
#   geom_line(linewidth = 1) +
#   geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.2) +
#   labs(x = "Time from Treatment Administration (Days)",
#        y = "Survival Probability",
#        title = "K-M Plot - Overall Survival across Treatment groups") +
#   scale_color_manual(values = c("blue", "red"), labels = c("D-penicillamine", "Placebo")) +
#   scale_fill_manual(values = c("blue", "red"), labels = c("D-penicillamine", "Placebo"))
# saveRDS(KM_byTrt,
#         file = "outputs/plot_KMbyTrt.rds")











