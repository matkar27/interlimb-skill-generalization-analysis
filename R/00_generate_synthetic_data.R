
# ============================================================
# PROJECT: Motor Learning Data Analysis
# SCRIPT: 00_generate_synthetic_data.R
#
# PURPOSE:
# Generate artificial behavioural data for demonstrating
# data processing and visualisation workflows.
#
# IMPORTANT:
# These data are entirely synthetic. They are not observations
# from the original IIT Hyderabad research study.
# ============================================================


# 1. SET UP THE SIMULATION -----------------------------------

set.seed(20261111)

n_participants <- 24

trials_per_session <- 40

sessions <- c("Learning", "Transfer")


# 2. CREATE FICTIONAL PARTICIPANTS ---------------------------

participants <- data.frame(

  participant_id = sprintf(
    "P%03d",
    seq_len(n_participants)
  ),

  demo_condition = rep(
    c("Condition_A", "Condition_B", "Condition_C"),
    length.out = n_participants
  ),

  participant_offset = rnorm(
    n_participants,
    mean = 0,
    sd = 4
  )
)


# 3. CREATE THE TRIAL STRUCTURE ------------------------------

trial_grid <- expand.grid(

  trial = seq_len(trials_per_session),

  session = sessions,

  KEEP.OUT.ATTRS = FALSE,

  stringsAsFactors = FALSE
)


# 4. COMBINE PARTICIPANTS AND TRIALS -------------------------

synthetic_data <- merge(
  participants,
  trial_grid,
  by = NULL
)


# Arrange observations in a consistent order

synthetic_data <- synthetic_data[
  order(
    match(
      synthetic_data$participant_id,
      participants$participant_id
    ),
    match(
      synthetic_data$session,
      sessions
    ),
    synthetic_data$trial
  ),
]


# 5. CREATE ARTIFICIAL BEHAVIOURAL MEASUREMENTS --------------

# Trial progression

progress <- (
  synthetic_data$trial - 1
) / (
  trials_per_session - 1
)


# Artificial condition differences

condition_effect <- c(
  Condition_A = -2,
  Condition_B = 0,
  Condition_C = 2
)[synthetic_data$demo_condition]


# Artificial session difference

session_effect <- ifelse(
  synthetic_data$session == "Transfer",
  2,
  0
)


# Temporal error

synthetic_data$temporal_error <- pmax(
  0,
  50 - 16 * progress +
    synthetic_data$participant_offset +
    condition_effect +
    session_effect +
    rnorm(nrow(synthetic_data), 0, 3)
)


# Spatial error

synthetic_data$spatial_error <- pmax(
  0,
  35 - 10 * progress +
    0.7 * synthetic_data$participant_offset +
    0.8 * condition_effect +
    0.6 * session_effect +
    rnorm(nrow(synthetic_data), 0, 3)
)


# Artificial total error measurement
# This is independently simulated, not a reconstruction
# of the original study's composite error calculation.

synthetic_data$total_error <- pmax(
  0,
  65 - 20 * progress +
    1.1 * synthetic_data$participant_offset +
    condition_effect +
    session_effect +
    rnorm(nrow(synthetic_data), 0, 4)
)


# 6. KEEP ONLY THE VARIABLES REQUIRED -----------------------

synthetic_data <- synthetic_data[, c(
  "participant_id",
  "demo_condition",
  "session",
  "trial",
  "temporal_error",
  "spatial_error",
  "total_error"
)]


# 7. SAVE THE SYNTHETIC DATASET ------------------------------

output_folder <- file.path(
  "data",
  "synthetic"
)

if (!dir.exists(output_folder)) {
  dir.create(
    output_folder,
    recursive = TRUE
  )
}


output_file <- file.path(
  output_folder,
  "motor_error_trials_synthetic.csv"
)


write.csv(
  synthetic_data,
  file = output_file,
  row.names = FALSE
)


# 8. DISPLAY A SUMMARY ---------------------------------------

cat("Synthetic dataset successfully created!\n")

cat("Number of observations:", nrow(synthetic_data), "\n")

cat(
  "Number of participants:",
  length(unique(synthetic_data$participant_id)),
  "\n"
)

cat(
  "Sessions:",
  paste(unique(synthetic_data$session), collapse = ", "),
  "\n"
)

cat("Saved to:", output_file, "\n")
