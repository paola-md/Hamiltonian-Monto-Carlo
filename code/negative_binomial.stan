data {
  int<lower=1> N;
  vector[N] x;
  int y[N];
}

parameters {
  real alpha;
  real beta;
}

transformed parameters {
  vector[N] eta;
  real p[N];
  real b[N];
  eta = alpha + x*beta;
  for (i in 1:N) { p[i] = 1/(1 + exp(eta[i])); }
  for (i in 1:N) { b[i] = p[i]/(1 - p[i]); }
}

model {
  real r;
  r = 10;
  for (i in 1:N) {
    y[i] ~ neg_binomial(r, b[i]);
  }
}

