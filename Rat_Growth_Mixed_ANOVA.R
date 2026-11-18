# ==============================================================================
# BIO2105 - BIOSTATISTICS: FORMATIVE ASSESSMENT 11
# Mixed-Design Repeated Measures ANOVA Using R
# Students: Chavez, Ishi Santi V. | Lagaña, Alyssa Kaye L. | Quillope, Arabela Renee Florence M.
# Section: 4
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. LOAD PACKAGES AND PREPARE DATA (Part 1)
# ------------------------------------------------------------------------------
# Uncomment the line below if packages are not yet installed on your system:
# install.packages(c("nlmm", "tidyverse", "rstatix", "ggpubr"))

library(nlmm)
library(tidyverse)
library(rstatix)
library(ggpubr)

# Load the rats dataset from the nlmm package (Box, 1950)[cite: 1]
data("rats", package = "nlmm")

# Convert id, trt, and time into factor variables with appropriate labels[cite: 2]
rats <- rats %>%
  mutate(
    id = factor(id),
    trt = factor(
      trt,
      levels = c(1, 2, 3),
      labels = c("Control", "Thiouracil", "Thyroxin")
    ),
    time = factor(
      time,
      levels = 0:4,
      labels = c("Week 0", "Week 1", "Week 2", "Week 3", "Week 4")
    )
  )

# Create a local 'data' directory and export a CSV copy for your repository
if (!dir.exists("data")) dir.create("data")
write.csv(rats, "data/Rat_Growth_Dataset.csv", row.names = FALSE)

# Examine data structure, dimensions, first few observations, and group counts
str(rats)
dim(rats)
head(rats)
table(rats$trt)


# ------------------------------------------------------------------------------
# 2. DESCRIPTIVE STATISTICS AND DATA VISUALIZATION (Part 2)
# ------------------------------------------------------------------------------
# Compute sample size, mean, and standard deviation for each Treatment x Time cell
desc_stats <- rats %>%
  group_by(trt, time) %>%
  get_summary_stats(y, type = "mean_sd")
print(desc_stats, n = 15)

# Construct a boxplot showing body weight distribution across weeks by treatment[cite: 3]
p_box <- ggboxplot(
  rats,
  x = "time",
  y = "y",
  color = "trt",
  palette = "jco",
  add = "jitter"
) +
  labs(
    title = "Distribution of Rat Body Weight Across Measurement Occasions",
    x = "Measurement Occasion",
    y = "Body Weight (grams)",
    color = "Treatment"
  )
print(p_box)

# Construct an interaction plot showing mean body weight trajectories over time[cite: 3]
p_int <- rats %>%
  group_by(trt, time) %>%
  summarise(mean_weight = mean(y), .groups = "drop") %>%
  ggplot(aes(x = time, y = mean_weight, color = trt, group = trt)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    title = "Mean Body Weight Trajectories by Treatment Group",
    x = "Measurement Occasion",
    y = "Mean Body Weight (grams)",
    color = "Treatment"
  ) +
  theme_minimal()
print(p_int)


# ------------------------------------------------------------------------------
# 3. ASSUMPTION CHECKING (Part 3)
# ------------------------------------------------------------------------------
# A. Normality (Shapiro-Wilk test for each Treatment x Time combination)[cite: 3]
normality_res <- rats %>%
  group_by(trt, time) %>%
  shapiro_test(y)
print(normality_res, n = 15)

# Optional diagnostic Q-Q plots
ggqqplot(rats, "y", ggtheme = theme_bw()) +
  facet_grid(trt ~ time) +
  labs(title = "Normal Q-Q Plots by Treatment and Time")

# B. Outlier Detection (Identify extreme univariate outliers)[cite: 3]
outliers_res <- rats %>%
  group_by(trt, time) %>%
  identify_outliers(y)
print(outliers_res)

# C. Homogeneity of Variances (Levene's test separately at each measurement occasion)[cite: 3, 4]
levene_res <- rats %>%
  group_by(time) %>%
  levene_test(y ~ trt)
print(levene_res)

# D. Homogeneity of Covariance Matrices (Box's M test using wide-format data, alpha = 0.001)[cite: 4]
rats_wide <- rats %>%
  pivot_wider(
    id_cols = c(id, trt),
    names_from = time,
    values_from = y,
    names_prefix = "time_"
  )

box_m_res <- box_m(
  rats_wide %>% select(starts_with("time_")),
  rats_wide$trt
)
print(box_m_res)


# ------------------------------------------------------------------------------
# 4. MIXED-DESIGN REPEATED MEASURES ANOVA (Part 4)
# ------------------------------------------------------------------------------
# Conduct two-way mixed-design repeated measures ANOVA using rstatix[cite: 5]
res.aov <- anova_test(
  data = rats,
  dv = y,
  wid = id,
  between = trt,
  within = time
)

# Inspect complete ANOVA and Mauchly's sphericity test information[cite: 4, 5]
print(res.aov)

# Obtain the ANOVA table with Greenhouse-Geisser sphericity correction applied[cite: 4, 5]
aov_table_gg <- get_anova_table(res.aov, correction = "GG")
print(aov_table_gg)


# ------------------------------------------------------------------------------
# 5. POST HOC ANALYSIS AND DECOMPOSITION OF INTERACTION (Part 5)
# ------------------------------------------------------------------------------
# A. Treatment Differences at Each Measurement Occasion (One-way ANOVA + Tukey's HSD)[cite: 6]
one_way_time <- rats %>%
  group_by(time) %>%
  anova_test(dv = y, wid = id, between = trt) %>%
  get_anova_table()
print(one_way_time)

tukey_time <- rats %>%
  group_by(time) %>%
  tukey_hsd(y ~ trt)
print(tukey_time, n = 15)

# B. Changes Over Time Within Each Treatment Group (RM-ANOVA + Holm-adjusted paired t-tests)[cite: 6]
rm_trt <- rats %>%
  group_by(trt) %>%
  anova_test(dv = y, wid = id, within = time) %>%
  get_anova_table(correction = "GG")
print(rm_trt)

pwc_trt <- rats %>%
  group_by(trt) %>%
  pairwise_t_test(
    y ~ time,
    paired = TRUE,
    p.adjust.method = "holm"
  )
print(pwc_trt, n = 30)
