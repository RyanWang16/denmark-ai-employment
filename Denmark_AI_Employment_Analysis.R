# Run this script from the repository root
employment_raw <- read.csv("data/industry_employment.csv", stringsAsFactors = FALSE)
ai_raw <- read.csv("data/ai_business_use.csv", stringsAsFactors = FALSE)

employment <- employment_raw[employment_raw$REF_AREA == "DNK",
                             c("ACTIVITY", "TIME_PERIOD", "OBS_VALUE")]
ai_use <- ai_raw[ai_raw$REF_AREA == "DNK",
                 c("ACTIVITY", "TIME_PERIOD", "OBS_VALUE")]

names(employment) <- c("industry", "year", "employment")
names(ai_use) <- c("industry", "year", "ai_percent")

employment$year <- as.numeric(employment$year)
employment$employment <- as.numeric(employment$employment)
ai_use$year <- as.numeric(ai_use$year)
ai_use$ai_percent <- as.numeric(ai_use$ai_percent)

# Match the two datasets by industry and year
data <- merge(employment, ai_use, by = c("industry", "year"))

industry_codes <- c("C", "F", "G46", "G47", "H", "I", "J", "M", "N")
industry_names <- c("Manufacturing", "Construction", "Wholesale",
                    "Retail", "Transport", "Accommodation & food",
                    "Information & communication", "Professional & scientific",
                    "Administrative & support")
data$sector <- industry_names[match(data$industry, industry_codes)]

data$sector <- factor(data$sector, levels = industry_names)
data <- data[order(data$sector, data$year), ]

cat("Matched Denmark observations:", nrow(data), "\n")
cat("Industries:", length(unique(data$industry)), "\n")
cat("Years:", paste(sort(unique(data$year)), collapse = ", "), "\n\n")
print(data[, c("sector", "year", "ai_percent", "employment")])

employment_2023 <- employment[employment$year == 2023,
                              c("industry", "employment")]
employment_2024 <- employment[employment$year == 2024,
                              c("industry", "employment")]
employment_2025 <- employment[employment$year == 2025,
                              c("industry", "employment")]

change_2023_24 <- merge(employment_2023, employment_2024,
                        by = "industry", suffixes = c("_2023", "_2024"))
change_2023_24$growth_2023_24 <-
  (change_2023_24$employment_2024 - change_2023_24$employment_2023) /
  change_2023_24$employment_2023 * 100

change_2024_25 <- merge(employment_2024, employment_2025,
                        by = "industry", suffixes = c("_2024", "_2025"))
change_2024_25$growth_2024_25 <-
  (change_2024_25$employment_2025 - change_2024_25$employment_2024) /
  change_2024_25$employment_2024 * 100

employment_growth <- merge(
  change_2023_24[, c("industry", "growth_2023_24")],
  change_2024_25[, c("industry", "growth_2024_25")],
  by = "industry"
)
employment_growth$sector <- industry_names[
  match(employment_growth$industry, industry_codes)
]
employment_growth <- employment_growth[
  match(industry_codes, employment_growth$industry),
]

ai_2023 <- ai_use[ai_use$year == 2023, c("industry", "ai_percent")]
ai_2025 <- ai_use[ai_use$year == 2025, c("industry", "ai_percent")]
ai_change <- merge(ai_2023, ai_2025, by = "industry",
                   suffixes = c("_2023", "_2025"))
ai_change$ai_change_pp <- ai_change$ai_percent_2025 - ai_change$ai_percent_2023

emp_2023 <- employment[employment$year == 2023,
                       c("industry", "employment")]
emp_2025 <- employment[employment$year == 2025,
                       c("industry", "employment")]
emp_change <- merge(emp_2023, emp_2025, by = "industry",
                    suffixes = c("_2023", "_2025"))
emp_change$employment_change_percent <-
  (emp_change$employment_2025 - emp_change$employment_2023) /
  emp_change$employment_2023 * 100

comparison <- merge(ai_change[, c("industry", "ai_change_pp")],
                    emp_change[, c("industry", "employment_change_percent")],
                    by = "industry")
comparison$sector <- industry_names[match(comparison$industry, industry_codes)]
comparison <- comparison[match(industry_codes, comparison$industry), ]

# Figure 1: AI use by industry and year
par(mar = c(4.5, 18, 4, 2))
ai_matrix <- matrix(NA, nrow = length(industry_codes), ncol = 3)
for (i in 1:length(industry_codes)) {
  for (j in 1:3) {
    row <- ai_use[ai_use$industry == industry_codes[i] &
                  ai_use$year == 2022 + j, ]
    if (nrow(row) > 0) ai_matrix[i, j] <- row$ai_percent[1]
  }
}
rownames(ai_matrix) <- industry_names
colnames(ai_matrix) <- c("2023", "2024", "2025")

barplot(t(ai_matrix), beside = TRUE, horiz = TRUE,
        names.arg = industry_names, las = 1,
        col = c("#D6E6F3", "#8FB8D8", "#356F9F"),
        xlim = c(0, 100),
        main = "AI Use by Industry in Denmark",
        ylab = "",
        xlab = "Businesses using AI (%)")
mtext("Industry", side = 2, line = 16, las = 0)
legend("bottomright", legend = c("2023", "2024", "2025"),
       fill = c("#D6E6F3", "#8FB8D8", "#356F9F"),
       bty = "n", horiz = TRUE, cex = 0.85)

# Figure 2: employment growth in the two yearly periods
par(mar = c(4.5, 14, 4, 10), xpd = FALSE)
growth_matrix <- rbind(employment_growth$growth_2023_24,
                       employment_growth$growth_2024_25)
colnames(growth_matrix) <- industry_names
rownames(growth_matrix) <- c("2023-2024", "2024-2025")
growth_limit <- max(abs(growth_matrix), na.rm = TRUE) + 1

barplot(growth_matrix, beside = TRUE, horiz = TRUE,
        names.arg = industry_names, las = 1,
        col = c("#AFCBE2", "#356F9F"),
        xlim = c(-growth_limit, growth_limit),
        main = "Employment Change by Industry in Denmark",
        xlab = "Employment change (%)",
        ylab = "")
mtext("Industry", side = 2, line = 12, las = 0)
abline(v = 0, col = "gray40", lty = 2)
par(xpd = NA)
legend(x = growth_limit + 0.3, y = 5, xjust = 0, yjust = 0.5,
       legend = c("2023-2024", "2024-2025"),
       fill = c("#AFCBE2", "#356F9F"),
       bty = "n", cex = 0.85)

# Figure 3: compare change in AI use with employment change, 2023-2025
par(mar = c(5, 5, 4, 2), xpd = FALSE)
plot(comparison$ai_change_pp, comparison$employment_change_percent,
     pch = 21, bg = "#4A86B8", col = "#17466B", cex = 1.8,
     xlim = c(6, 48), ylim = c(-4.4, 4.8),
     xlab = "Change in AI use, 2023-2025 (percentage points)",
     ylab = "Employment change, 2023-2025 (%)",
     main = "AI Use and Employment Change by Industry")
abline(v = 0, h = 0, col = "gray50", lty = 2)
short_names <- c("Manufacturing", "Construction", "Wholesale", "Retail",
                 "Transport", "Accommodation/food", "Information/communication",
                 "Professional/scientific", "Administrative/support")
label_position <- c(2, 3, 3, 3, 4, 3, 3, 2, 3)
text(comparison$ai_change_pp, comparison$employment_change_percent,
     labels = short_names, pos = label_position, cex = 0.68, offset = 0.45)
