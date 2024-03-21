cities <- jsonlite::fromJSON("cities.json")
colnames(cities)[1] <- "name"

usethis::use_data(cities, overwrite = TRUE)
