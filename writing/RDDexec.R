library(knitr)
library(rmarkdown)
knitr::knit("rdd.Rmd")
rmarkdown::render("rdd.Rmd")

Sys.sleep(3)