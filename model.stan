data {
  int<lower=1> N;                      // number of departments
  array[N] int<lower=0> y;             // infected fields observed
  array[N] int<lower=0> n;             // total fields
  real<lower=0> Se_a;                  // sensitivity alpha
  real<lower=0> Se_b;                  // sensitivity beta
  real<lower=0> Sp_a;                  // specificity alpha
  real<lower=0> Sp_b;                  // specificity beta
}

parameters {
  array[N] real<lower=0, upper=1> p_true;   // true incidence
  real<lower=0, upper=1> Se;                // sensitivity
  real<lower=0, upper=1> Sp;                // specificity
}

model {
  // Priors
  Se ~ beta(Se_a, Se_b);
  Sp ~ beta(Sp_a, Sp_b);
  p_true ~ beta(1, 1);

  // Likelihood with misclassification correction
  for (i in 1:N) {
    real p_obs = Se * p_true[i] + (1 - Sp) * (1 - p_true[i]);
    y[i] ~ binomial(n[i], p_obs);
  }
}

generated quantities {
  array[N] real p_true_pred;
  for (i in 1:N)
    p_true_pred[i] = p_true[i];
}
