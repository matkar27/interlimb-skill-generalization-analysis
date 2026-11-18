# ==========================================
# 1. Load packages
# ==========================================

library(tidyverse)


# ==========================================
# 2. Import processed motor-error data
# ==========================================

motor_summary <- read.csv(
  "data/synthetic/motor_error_binned_summary_synthetic.csv"
)

# Inspect the dataset
View(motor_summary)

dim(motor_summary)

head(motor_summary)

str(motor_summary)

# ==========================================
# 3. Calculate group-level summary
# ==========================================

group_summary <- motor_summary %>%

  group_by(
    demo_condition,
    session,
    error_type,
    bin
  ) %>%

  summarise(

    n_participants = n_distinct(participant_id),

    group_mean = mean(mean_error, na.rm = TRUE),

    group_sd = sd(mean_error, na.rm = TRUE),

    group_se = group_sd / sqrt(n_participants),

    .groups = "drop"
  )


# Inspect group-level summary

View(group_summary)

dim(group_summary)

head(group_summary)

table(group_summary$n_participants)

# ==========================================
# 4. Create group-level motor-error plot
# ==========================================

motor_plot <- ggplot(
  group_summary,
  aes(
    x = bin,
    y = group_mean,
    colour = demo_condition,
    group = demo_condition
  )
) +

  geom_line(linewidth = 0.8) +

  geom_point(size = 2) +

  geom_errorbar(
    aes(
      ymin = group_mean - group_se,
      ymax = group_mean + group_se
    ),
    width = 0.15,
    alpha = 0.6
  ) +

  facet_grid(
    error_type ~ session,
    scales = "free_y"
  ) +

  scale_x_continuous(
    breaks = 1:8
  ) +

  labs(
    title = "Motor-error trends across learning and transfer",

    subtitle = "Synthetic demonstration data; group mean ± 1 SE",

    x = "Five-trial bin",

    y = "Mean error (arbitrary units)",

    colour = "Demo condition"
  ) +

  theme_minimal(base_size = 12) +

  theme(
    legend.position = "bottom"
  )


# Display graph

print(motor_plot)

# ==========================================
# 5. Save the graph
# ==========================================

if (!dir.exists("figures")) {
  dir.create("figures", recursive = TRUE)
}

ggsave(
  filename = "figures/motor_error_group_summary_synthetic.png",
  plot = motor_plot,
  width = 11,
  height = 8,
  dpi = 300
)

write.csv(
  group_summary,
  file = "data/synthetic/motor_error_group_summary_synthetic.csv",
  row.names = FALSE
)
