# Setting up environment

library(ggplot2)
library(MASS)

data <- read.csv("QT_data.csv")
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# Prepare data

prices <- data[, -1]

prices[] <- lapply(prices, function(x) as.numeric(gsub(",", "", x)))

# Return calculations

# Log returns (preferred for GBM)
log_returns <- diff(log(as.matrix(prices)))

# Mean vector and covariance matrix
mu <- colMeans(log_returns)
cov_matrix <- cov(log_returns)

# Number of assets
n_assets <- ncol(log_returns)

# Latest prices
current_prices <- as.numeric(prices[nrow(prices), ])

# Monte Carlo Simulation

n_sim <- 10000

sim_returns <- mvrnorm(
  n = n_sim,
  mu = mu,
  Sigma = cov_matrix
)

# Convert to price returns
sim_returns <- exp(sim_returns) - 1

# Portfolio Optimisation

obj_fun <- function(w, sim_returns) {

  # Portfolio simulated returns
  port_returns <- sim_returns %*% w

  # 95% VaR
  port_VaR <- quantile(port_returns, 0.05)

  # Penalties
  penalty_sum <- 1e5 * abs(sum(w) - 1)
  penalty_bounds <- 1e5 * sum(pmax(0, -w) + pmax(0, w - 1))

  return(-port_VaR + penalty_sum + penalty_bounds)
}

# Initial weights
w_init <- rep(1/n_assets, n_assets)

# Optimization
opt <- optim(
  par = w_init,
  fn = obj_fun,
  sim_returns = sim_returns,
  method = "Nelder-Mead",
  control = list(maxit = 5000)
)

# Normalize weights
optimal_weights <- opt$par / sum(opt$par)

names(optimal_weights) <- colnames(prices)

# Portfolio VaR

portfolio_returns_opt <- sim_returns %*% optimal_weights

portfolio_VaR_95_opt <- quantile(portfolio_returns_opt, 0.05)

# Output

cat("Optimal portfolio weights:\n")
print(round(optimal_weights,4))

cat("\nOptimal portfolio 95% VaR:", round(portfolio_VaR_95_opt,6), "\n")

ggplot(data.frame(portfolio_returns_opt), aes(x = portfolio_returns_opt)) +
  geom_histogram(bins = 60) +
  geom_vline(xintercept = portfolio_VaR_95_opt, color="red", linewidth=1) +
  labs(title="Monte Carlo Portfolio Return Distribution",
       x="Simulated Portfolio Return",
       y="Frequency")




