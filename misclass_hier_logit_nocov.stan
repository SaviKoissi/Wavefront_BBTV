data {
  int<lower=1> N;                     // number of observations
  int<lower=1> K;                     // number of fields
  array[N] int<lower=1, upper=K> field;  // field index for each observation
  array[N] int<lower=0, upper=1> y;      // observed disease state (0/1)

  // Priors for Se and Sp
  real<lower=0> Se_a;
  real<lower=0> Se_b;
  real<lower=0> Sp_a;
  real<lower=0> Sp_b;
}

parameters {
  real mu;                            // population-level intercept
  real<lower=0> sigma_field;          // random effect SD
  vector[K] alpha_field;              // field-level random intercepts
  real<lower=0, upper=1> Se;          // sensitivity
  real<lower=0, upper=1> Sp;          // specificity
}

transformed parameters {
  vector[N] p_true;                   // true infection probability per observation
  vector[N] p_obs;                    // probability of observed positive (misclassified)

  for (n in 1:N) {
    p_true[n] = inv_logit(mu + alpha_field[field[n]]);
    p_obs[n] = Se * p_true[n] + (1 - Sp) * (1 - p_true[n]);
  }
}

model {
  // Priors
  mu ~ normal(0, 2);
  sigma_field ~ normal(0, 1);
  alpha_field ~ normal(0, sigma_field);

  Se ~ beta(Se_a, Se_b);
  Sp ~ beta(Sp_a, Sp_b);

  // Likelihood
  y ~ bernoulli(p_obs);
}

generated quantities {
  vector[N] p = p_true;               // store posterior samples of true infection probability
}
