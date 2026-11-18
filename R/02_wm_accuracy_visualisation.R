
# ==========================================
# WORKING MEMORY: VISUALISATION
# ==========================================

library(tidyverse)


# ==========================================
# 1. Import processed datasets
# ==========================================

# Participant-level accuracy dataset

wm_participant_summary <- read.csv(
  "data/synthetic/working_memory/wm_participant_accuracy_synthetic.csv"
)


# Group-level accuracy dataset

wm_group_summary <- read.csv(
  "data/synthetic/working_memory/wm_group_accuracy_summary_synthetic.csv"
)


# ==========================================
# 2. Inspect and validate datasets
# ==========================================

View(wm_participant_summary)

View(wm_group_summary)

dim(wm_participant_summary)

dim(wm_group_summary)


# Check required columns

stopifnot(
  all(c(
    "participant_id",
    "demo_condition",
    "accuracy"
  ) %in% names(wm_participant_summary))
)

stopifnot(
  all(c(
    "demo_condition",
    "n_participants",
    "group_mean_accuracy",
    "group_sd",
    "group_se"
  ) %in% names(wm_group_summary))
)


# Check accuracy values

summary(wm_participant_summary$accuracy)

summary(wm_group_summary$group_mean_accuracy)


# ==========================================
# 3. Group-level mean accuracy plot
# ==========================================

wm_group_plot <- ggplot(
  wm_group_summary,
  aes(
    x = demo_condition,
    y = group_mean_accuracy,
    fill = demo_condition
  )
) +

  geom_col(
    width = 0.6,
    alpha = 0.8
  ) +

  geom_errorbar(
    aes(
      ymin = group_mean_accuracy - group_se,
      ymax = group_mean_accuracy + group_se
    ),
    width = 0.15,
    linewidth = 0.7
  ) +

  labs(
    title = "Working Memory Accuracy by Condition",
    subtitle = "Group mean accuracy with ±1 standard error",
    x = "Demonstration condition",
    y = "Mean accuracy (%)"
  ) +

  scale_y_continuous(
    limits = c(0, 100),
    breaks = seq(0, 100, 10)
  ) +

  theme_minimal(base_size = 12) +

  theme(
    legend.position = "none",
    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      hjust = 0.5
    )
  )


# Display plot

print(wm_group_plot)


# ==========================================
# 4. Individual participant accuracy plot
# ==========================================

wm_individual_plot <- ggplot(
  wm_participant_summary,
  aes(
    x = demo_condition,
    y = accuracy,
    colour = demo_condition
  )
) +

  geom_jitter(
    width = 0.12,
    size = 2.5,
    alpha = 0.8
  ) +

  labs(
    title = "Individual Working Memory Accuracy",
    subtitle = "Each point represents one synthetic participant",
    x = "Demonstration condition",
    y = "Accuracy (%)"
  ) +

  scale_y_continuous(
    limits = c(0, 100),
    breaks = seq(0, 100, 10)
  ) +

  theme_minimal(base_size = 12) +

  theme(
    legend.position = "none",
    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      hjust = 0.5
    )
  )


# Display plot

print(wm_individual_plot)


# ==========================================
# 5. Distribution of accuracy
# ==========================================

wm_distribution_plot <- ggplot(
  wm_participant_summary,
  aes(
    x = demo_condition,
    y = accuracy,
    fill = demo_condition
  )
) +

  geom_boxplot(
    width = 0.5,
    alpha = 0.6,
    outlier.shape = NA
  ) +

  geom_jitter(
    aes(
      colour = demo_condition
    ),
    width = 0.12,
    size = 2,
    alpha = 0.7
  ) +

  labs(
    title = "Distribution of Working Memory Accuracy",
    subtitle = "Boxplots with individual participant observations",
    x = "Demonstration condition",
    y = "Accuracy (%)"
  ) +

  scale_y_continuous(
    limits = c(0, 100),
    breaks = seq(0, 100, 10)
  ) +

  theme_minimal(base_size = 12) +

  theme(
    legend.position = "none",
    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      hjust = 0.5
    )
  )


# Display plot

print(wm_distribution_plot)


# ==========================================
# 6. Save figures
# ==========================================

if (!dir.exists("figures/working_memory")) {

  dir.create(
    "figures/working_memory",
    recursive = TRUE
  )

}


# Group-level accuracy

ggsave(
  "figures/working_memory/wm_group_accuracy_synthetic.png",
  plot = wm_group_plot,
  width = 8,
  height = 6,
  dpi = 300
)


# Individual participant accuracy

ggsave(
  "figures/working_memory/wm_individual_accuracy_synthetic.png",
  plot = wm_individual_plot,
  width = 8,
  height = 6,
  dpi = 300
)


# Distribution of accuracy

ggsave(
  "figures/working_memory/wm_accuracy_distribution_synthetic.png",
  plot = wm_distribution_plot,
  width = 8,
  height = 6,
  dpi = 300
)


# ==========================================
# 7. Completion message
# ==========================================

cat("\nAll Working Memory figures saved successfully!\n")

cat("Figures generated:\n")
cat("1. Group-level accuracy\n")
cat("2. Individual participant accuracy\n")
cat("3. Distribution of accuracy\n")
