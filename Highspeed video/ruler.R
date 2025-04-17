```{r}
# === Step 1: Read and extract data ===
lines <- readLines("acclight2.txt")

# Extract x, y, z values from each line
extract_xyz <- function(line) {
  matches <- regmatches(line, gregexpr("-?\\d+\\.\\d+", line))
  as.numeric(unlist(matches))
}

xyz_data <- t(sapply(lines, extract_xyz))
colnames(xyz_data) <- c("x", "y", "z")
df <- as.data.frame(xyz_data)

# === Step 2: Add time column (sampled every 0.1 second) ===
dt <- 0.02
df$time <- seq(0, by = dt, length.out = nrow(df))

# === Step 3: Peak detection function ===
find_peaks <- function(signal) {
  which(diff(sign(diff(signal))) == -2) + 1
}

# === Step 4: Frequency and damping estimation ===
z <- df$x
time <- df$time
peaks_idx <- find_peaks(z)
peak_times <- time[peaks_idx]
peak_values <- z[peaks_idx]

# Frequency estimation
periods <- diff(peak_times)
est_freq <- 1 / mean(periods)

# Damping estimation (log decrement method)
log_decrements <- log(peak_values[-length(peak_values)] / peak_values[-1])
est_damping <- mean(log_decrements) / mean(periods)

# === Step 5: Visualization ===
plot(time, z, type = 'l', col = 'steelblue', lwd = 1,
     main = 'Signal z(t) with Peaks and Damping Fit',
     xlab = 'Time (s)', ylab = 'z')
points(peak_times, peak_values, col = 'red', pch = 19, cex = 0.6)

# Fit exponential decay envelope
fit_env <- lm(log(peak_values) ~ peak_times)
a <- exp(coef(fit_env)[1])
b <- -coef(fit_env)[2]
lines(peak_times, a * exp(-b * peak_times), col = "darkgreen", lty = 2)

legend("topright",
       legend = c("z(t)", "Peaks", "Exponential Fit"),
       col = c("steelblue", "red", "darkgreen"),
       lty = c(1, NA, 2), pch = c(NA, 19, NA), lwd = 2)

# === Step 6: Output results ===
cat("Estimated Frequency:", round(est_freq, 3), "Hz\n")
cat("Estimated Damping Coefficient:", round(est_damping, 4), "\n")


```
