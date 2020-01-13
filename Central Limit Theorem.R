sample = rpois(1000, lambda = 0.5) #뿌아송 분포
hist(sample)

res = replicate(1000, expr = {
  n = 1000
  sample = rpois(n, lambda = 0.5)
  mean(sample)
})
hist(res, freq = FALSE)
lines(density(res), lty = 2, col = "blue")

sample = rbinom(1000, size = 1, prob = 0.5) #이항 분포
hist(sample)

res = replicate(1000, expr = {
  n = 1000
  sample = rbinom(n, size = 1, prob = 0.5)
  mean(sample)
})
hist(res, freq = FALSE)
lines(density(res), lty = 2, col = "blue")
