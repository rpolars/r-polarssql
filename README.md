
<!-- README.md is generated from README.Rmd. Please edit that file -->

# polarssql

<!-- badges: start -->

[![polarssql status
badge](https://rpolars.r-universe.dev/badges/polarssql)](https://rpolars.r-universe.dev)
[![CRAN
status](https://www.r-pkg.org/badges/version/polarssql)](https://CRAN.R-project.org/package=polarssql)
<!-- badges: end -->

`{polarssql}` is an experimental DBI-compliant interface to
[Polars](https://www.pola.rs/).

## Installation

The [`polars`](https://rpolars.github.io/) R package and `{polarssql}`
can be installed from [r-universe](https://rpolars.r-universe.dev/):

``` r
Sys.setenv(NOT_CRAN = "true") # for installing the polars package with pre-built binary
install.packages("polarssql", repos = c("https://rpolars.r-universe.dev", getOption("repos")))
```

## Example

``` r
library(DBI)

con <- dbConnect(polarssql::polarssql())
dbWriteTable(con, "mtcars", mtcars)

# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 2  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 3  22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 4  32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 5  30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 6  33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 7  21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 8  27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 9  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 10 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 11 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

# Clear the result
dbClearResult(res)

# Or a chunk at a time
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
while (!dbHasCompleted(res)) {
  chunk <- dbFetch(res, n = 5)
  print(nrow(chunk))
}
#> [1] 5
#> [1] 5
#> [1] 1

# Clear the result
dbClearResult(res)
```
