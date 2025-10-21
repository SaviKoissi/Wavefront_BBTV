data {
  int<lower=1> N;           // number of plant rows
  int<lower=1> P;           // number of covariates
  int<lower=1> K;           // number of fields
  array[N] int<lower=1, upper=K> field;
  matrix[N, P] X;
  array[N] int<lower=0, upper=1> y;  // <-- changed here

  real<lower=0> Se_a;
  real<lower=0> Se_b;
  real<lower=0> Sp_a;
  real<lower=0> Sp_b;
}

parameters {
  real alpha;
  vector[P] beta;
  vector[K] b_field;
  real<lower=0> sigma_field;

  real<lower=0,upper=1> Se;
  real<lower=0,upper=1> Sp;
}
transformed parameters {
  vector[N] logit_p;
  vector[N] p;
  vector[N] p_obs;
  for (n in 1:N) {
    logit_p[n] = alpha + X[n] * beta + b_field[field[n]];
    p[n] = inv_logit(logit_p[n]);
    p_obs[n] = Se * p[n] + (1 - Sp) * (1 - p[n]);
    // ensure p_obs in (0,1)
    p_obs[n] = fmin(fmax(p_obs[n], 1e-9), 1 - 1e-9);
  }
}
model {
  // Priors
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  b_field ~ normal(0, sigma_field);
  sigma_field ~ normal(0, 1);

  Se ~ beta(Se_a, Se_b);
  Sp ~ beta(Sp_a, Sp_b);

  // Likelihood
  y ~ bernoulli(p_obs);
}
generated quantities {
  // posterior predictive for p per row and per field aggregated
  vector[N] p_draw = p;
}
