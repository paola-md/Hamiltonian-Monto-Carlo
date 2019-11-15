
library('rstan')
library('R2jags')


desastres <- read.table("http://allman.rhon.itam.mx/~lnieto/index_archivos/desastres.txt",header=TRUE)
N         <- nrow(desastres)
data      <- list("N" = N, "y" = desastres$No.Desastres, "x" = desastres$Anho)


# JAGS model --------------------------------------------------------------

initsa1 <- function() { list(alpha = 0, beta = 0) }
data    <- list("N" = N, "y" = desastres$No.Desastres, "x" = desastres$Anho)
pars    <- c("alpha", "beta")

t1 <- Sys.time()
jags_model <- jags(data, initsa1, pars, model.file = "negative_binomial.jags",
                   n.iter = 100000, n.chains = 3, n.burnin = 10000, n.thin = 5)
s1 <- Sys.time() - t1
s1

jags_model$BUGSoutput$summary
R2jags::traceplot(jags_model, ask = F, mfrow = c(2,1), varname = pars,
                  col = c('#b20012','#0024b2','#b2a900'))


# STAN model --------------------------------------------------------------

t2 <- Sys.time()
stan_model <- stan('negative_binomial.stan', chains = 3, 
                   pars = c('alpha', 'beta'), init = 0,
                   data = data, iter = 5000, warmup = 1000, thin = 5)
s2 <- Sys.time() - t2
s2

summary(stan_model)$summary
rstan::traceplot(stan_model, ncol = 1) +
  scale_color_manual(values = c('#b20012','#0024b2','#b2a900'))

ggsave('stan_traceplot.png', width = 20, height = 24, units = 'cm')




