
# ============================================================
# PROJECT: Motor Learning Data Analysis
# SCRIPT: 01_motor_error_processing.R
#
# PURPOSE:
# Import, reshape, bin and summarise synthetic motor-error data.
# ============================================================


# 1. LOAD PACKAGES -------------------------------------------

library(tidyverse)


# 2. IMPORT DATA ---------------------------------------------

motor_trials <- read.csv(
  "data/synthetic/motor_error_trials_synthetic.csv"
)


# 3. INSPECT DATA --------------------------------------------

# View the dataset
View(motor_trials)

# Check its structure
str(motor_trials)

# Check number of rows and columns
dim(motor_trials)

# Check column names
names(motor_trials)

# Check missing values
colSums(is.na(motor_trials))



# 4. CONVERT WIDE DATA TO LONG FORMAT ------------------------

motor_long <- motor_trials %>%

  pivot_longer(

    cols = c(
      temporal_error,
      spatial_error,
      total_error
    ),

    names_to = "error_type",

    values_to = "error_value"

  )


# Inspect the transformed dataset

View(motor_long)

dim(motor_long)

head(motor_long)


# 5. GROUP TRIALS INTO BINS ----------------------------------

# Set the number of trials in each bin

bin_size <- 5


motor_binned <- motor_long %>%

  group_by(
    participant_id,
    demo_condition,
    session,
    error_type
  ) %>%

  mutate(

    bin = ceiling(trial / bin_size)

  ) %>%

  ungroup()


# Inspect the binned data

View(motor_binned)

table(motor_binned$bin)




# 6. CALCULATE SUMMARY STATISTICS ----------------------------

motor_summary <- motor_binned %>%

  group_by(
    participant_id,
    demo_condition,
    session,
    error_type,
    bin
  ) %>%

  summarise(

    n_trials = sum(!is.na(error_value)),

    mean_error = mean(
      error_value,
      na.rm = TRUE
    ),

    sd_error = sd(
      error_value,
      na.rm = TRUE
    ),

    se_error = sd_error / sqrt(n_trials),

    .groups = "drop"

  )


# Inspect the summary

View(motor_summary)

head(motor_summary)



# 7. SAVE PROCESSED DATA -------------------------------------

write.csv(

  motor_summary,

  file = "data/synthetic/motor_error_binned_summary_synthetic.csv",

  row.names = FALSE

)


# 8. FINAL CHECK ---------------------------------------------

cat(
  "Number of summary rows:",
  nrow(motor_summary),
  "\n"
)

cat(
  "Number of participants:",
  n_distinct(motor_summary$participant_id),
  "\n"
)

cat(
  "Number of bins:",
  n_distinct(motor_summary$bin),
  "\n"
)

cat("Processing completed successfully!\n")
