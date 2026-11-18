
# ==========================================
# WORKING MEMORY: SYNTHETIC DATA GENERATION
# ==========================================

library(tidyverse)

# ==========================================
# 1. Reproducibility
# ==========================================

set.seed(20261112)


# ==========================================
# 2. Define study parameters
# ==========================================

n_participants <- 24
trials_per_participant <- 40

conditions <- c("A", "B", "C")


# ==========================================
# 3. Create participant information
# ==========================================

participants <- tibble(
  participant_id = sprintf(
    "WM%03d",
    1:n_participants
  ),

  demo_condition = rep(
    conditions,
    each = n_participants / length(conditions)
  )
)


# ==========================================
# 4. Define simulated accuracy probabilities
# ==========================================

# Simulated probability of a correct response
# for each demonstration condition.

condition_accuracy <- c(
  A = 0.65,
  B = 0.75,
  C = 0.85
)


# ==========================================
# 5. Generate individual participant accuracy
# ==========================================

# Introduce individual differences in accuracy.

participants <- participants %>%
  mutate(
    participant_accuracy =
      condition_accuracy[demo_condition] +
      rnorm(
        n_participants,
        mean = 0,
        sd = 0.05
      ),

    # Restrict probabilities to a valid range.
    participant_accuracy = pmin(
      pmax(participant_accuracy, 0.05),
      0.95
    )
  )


# ==========================================
# 6. Generate trial-level responses
# ==========================================

wm_trials <- participants %>%
  select(
    participant_id,
    demo_condition,
    participant_accuracy
  ) %>%

  # Generate 40 trials for each participant.
  uncount(
    trials_per_participant,
    .id = "trial"
  ) %>%

  # Generate binary responses:
  # 1 = Correct response
  # 0 = Incorrect response
  mutate(
    response = rbinom(
      n(),
      size = 1,
      prob = participant_accuracy
    )
  ) %>%

  select(
    participant_id,
    demo_condition,
    trial,
    response
  ) %>%

  arrange(
    participant_id,
    trial
  )


# ==========================================
# 7. Validate the generated dataset
# ==========================================

cat("\n--- DATASET VALIDATION ---\n")

# Dataset dimensions
cat(
  "Number of observations:",
  nrow(wm_trials),
  "\n"
)

cat(
  "Number of participants:",
  n_distinct(wm_trials$participant_id),
  "\n"
)

# Check number of trials per participant
trials_check <- wm_trials %>%
  count(participant_id)

cat(
  "All participants have 40 trials:",
  all(trials_check$n == trials_per_participant),
  "\n"
)

# Check missing values
cat(
  "Total missing values:",
  sum(is.na(wm_trials)),
  "\n"
)

# Check response coding
cat("\nResponse distribution:\n")
print(table(wm_trials$response))

# Check condition distribution
cat("\nParticipant distribution by condition:\n")
print(
  participants %>%
    count(demo_condition)
)


# ==========================================
# 8. Inspect the dataset
# ==========================================

View(wm_trials)

dim(wm_trials)

head(wm_trials)

str(wm_trials)


# ==========================================
# 9. Save synthetic data
# ==========================================

if (!dir.exists("data/synthetic/working_memory")) {

  dir.create(
    "data/synthetic/working_memory",
    recursive = TRUE
  )

}

write.csv(
  wm_trials,
  "data/synthetic/working_memory/wm_trials_synthetic.csv",
  row.names = FALSE
)


# ==========================================
# 10. Completion message
# ==========================================

cat("\nWorking Memory synthetic data generated successfully!\n")

cat(
  "Saved file: data/synthetic/working_memory/wm_trials_synthetic.csv\n"
)



# ==========================================
# WORKING MEMORY: ACCURACY PROCESSING
# ==========================================

library(tidyverse)


# ==========================================
# 1. Import trial-level synthetic data
# ==========================================

wm_trials <- read.csv(
  "data/synthetic/working_memory/wm_trials_synthetic.csv"
)


# Inspect dataset

View(wm_trials)

dim(wm_trials)

str(wm_trials)


# ==========================================
# 2. Calculate participant-level accuracy
# ==========================================

wm_participant_summary <- wm_trials %>%

  group_by(
    participant_id,
    demo_condition
  ) %>%

  summarise(

    total_trials = n(),

    correct_responses = sum(
      response,
      na.rm = TRUE
    ),

    mean_response = mean(
      response,
      na.rm = TRUE
    ),

    accuracy = mean_response * 100,

    .groups = "drop"

  )


# Inspect participant-level summary

View(wm_participant_summary)

dim(wm_participant_summary)

head(wm_participant_summary)


# ==========================================
# 3. Validate participant-level accuracy
# ==========================================

# Check number of participants

n_distinct(wm_participant_summary$participant_id)

# Check trials per participant

table(wm_participant_summary$total_trials)

# Check accuracy range

summary(wm_participant_summary$accuracy)

# Verify all participants have 40 trials

all(
  wm_participant_summary$total_trials == 40
)


# ==========================================
# 4. Calculate group-level accuracy
# ==========================================

wm_group_summary <- wm_participant_summary %>%

  group_by(
    demo_condition
  ) %>%

  summarise(

    n_participants = n_distinct(
      participant_id
    ),

    group_mean_accuracy = mean(
      accuracy,
      na.rm = TRUE
    ),

    group_sd = sd(
      accuracy,
      na.rm = TRUE
    ),

    group_se = group_sd / sqrt(
      n_participants
    ),

    .groups = "drop"

  )


# Inspect group-level summary

View(wm_group_summary)

dim(wm_group_summary)

print(wm_group_summary)


# ==========================================
# 5. Save processed datasets
# ==========================================

write.csv(
  wm_participant_summary,
  "data/synthetic/working_memory/wm_participant_accuracy_synthetic.csv",
  row.names = FALSE
)


write.csv(
  wm_group_summary,
  "data/synthetic/working_memory/wm_group_accuracy_summary_synthetic.csv",
  row.names = FALSE
)


# ==========================================
# 6. Completion message
# ==========================================

cat("\nWorking Memory accuracy processing completed!\n")

cat(
  "Participant summary:",
  nrow(wm_participant_summary),
  "rows\n"
)

cat(
  "Group summary:",
  nrow(wm_group_summary),
  "rows\n"
)

cat("Both summary files saved successfully!\n")
