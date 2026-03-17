# Monte Carlo Portfolio Risk Optimizer (R)

## Overview

This project implements a **Monte Carlo simulation framework** to estimate and minimize **portfolio risk** using Value-at-Risk (VaR).

Using historical price data of multiple equities, the model simulates correlated returns and identifies the **optimal portfolio allocation** that minimizes downside risk under realistic constraints.

---

## Key Features

* Uses log returns for accurate financial modeling
* Captures asset correlations via covariance matrix
* Generates 10,000 simulated return scenarios using multivariate normal distribution
* Optimizes portfolio weights using numerical optimization (Nelder–Mead)
* Enforces constraints:
  * No short selling
  * Full investment - weights sum to 1
* Estimates 95% VaR
* Visualizes return distribution and risk threshold

---

## Methodology

### 1. Data Preparation

* Historical price data is cleaned and converted to numeric format
* Log returns are computed:

### 2. Statistical Estimation

* Mean vector (μ) and covariance matrix (Σ) are calculated from historical returns
* These capture:

  * Expected returns
  * Volatility
  * Cross-asset correlations

---

### 3. Monte Carlo Simulation

* Simulate correlated returns:

  $R \sim \mathcal{N}(\mu, \Sigma)$

* Convert to simple returns:

  $R_{simple} = e^R - 14$

---

### 4. Portfolio Optimization

* Objective: Minimize 95% VaR

$VaR_{95} = \text{5th percentile of portfolio returns}$

* Optimization:

  * Algorithm: Nelder–Mead
  * Constraints enforced via penalty terms:

    *   $(\sum w_i = 1)$
    *   $(0 \leq w_i \leq 1)$

---

### 5. Risk Estimation

* Portfolio returns:

$R_p = R \cdot w$

* VaR computed as:

$VaR_{95} = \text{quantile}(R_p, 0.05)$

---

## Results

* Outputs optimal portfolio weights
* Computes 1-day 95% VaR
* Visualizes distribution of simulated returns

Example interpretation:

> A VaR of -0.0139 implies a 5% probability of losing more than 1.39% in one day.

---

## Project Structure

```id="projstruct"
├── QT_data.csv        # Historical price data
├── monte_carlo.R      # Main script
├── README.md          # Project documentation
```

---

## How to Run

1. Install required packages:

```r id="pkginstall"
install.packages(c("MASS", "ggplot2"))
```

2. Place dataset (`QT_data.csv`) in working directory

3. Run the script:

```r id="runscript"
source("monte_carlo.R")
```

---

## Visualization

The model produces a histogram of simulated portfolio returns with the VaR threshold marked.

* Histogram → distribution of returns
* Red line → 95% VaR cutoff

---

## Future Improvements

* Expected return vs risk optimization (Efficient Frontier)
* Conditional VaR (CVaR)
* Non-normal return distributions (fat tails)
* Multi-period VaR estimation
* Backtesting VaR accuracy

---

## Author

**Kavin Telkar**


* GitHub: [https://github.com/kavinTell](https://github.com/kavinTell)
* LinkedIn: [https://linkedin.com/in/kavintelkar](https://linkedin.com/in/kavintelkar)

---

