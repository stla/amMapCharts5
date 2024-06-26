library(amMapCharts5)

dat <- structure(c(26.5936, 26.175, 25.8594, 25.5473, 24.7683, 23.4845,
                   23.37, 22.7663, 22.8311, 21.2358, 21.0462, 22.0845, 24.1206,
                   24.9032, 26.5936, 55.6676, 55.0033, 54.9192, 54.3317, 53.9746,
                   53.9398, 54.2005, 54.3568, 54.8384, 55.2641, 56.07, 56.4067,
                   56.2642, 56.3982, 55.6676), dim = c(15L, 2L))
colnames(dat) <- c("a", "b")
amMapChart() |> addPolygons(dat, color = "red")


