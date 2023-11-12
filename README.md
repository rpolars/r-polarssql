
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

Polars is not an actual database, so does not support full `{DBI}`
functionality. Please check [the Polars User
Guide](https://pola-rs.github.io/polars/user-guide/sql/intro/) for
supported SQL features.

## Installation

The [`polars`](https://rpolars.github.io/) R package and `{polarssql}`
can be installed from [R-universe](https://rpolars.r-universe.dev/):

``` r
Sys.setenv(NOT_CRAN = "true") # for installing the polars package with pre-built binary
install.packages("polarssql", repos = c("https://rpolars.r-universe.dev", getOption("repos")))
```

## Example

``` r
library(DBI)

con <- dbConnect(polarssql::polarssql())
dbWriteTable(con, "mtcars", mtcars)

# We can fetch all results:
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

# We can use table functions to read files directly:
tf <- tempfile(fileext = ".parquet")
on.exit(unlink(tf))
polars::pl$LazyFrame(mtcars)$sink_parquet(tf)

dbGetQuery(con, paste0("SELECT * FROM read_parquet('", tf, "') ORDER BY mpg DESC LIMIT 3"))
#>    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> 1 33.9   4 71.1  65 4.22 1.835 19.90  1  1    4    1
#> 2 32.4   4 78.7  66 4.08 2.200 19.47  1  1    4    1
#> 3 30.4   4 95.1 113 3.77 1.513 16.90  1  1    5    2
```

`{polarssql}` also provides functions that are simpler to use, inspired
by the `{duckdb}` package,

``` r
library(polarssql)

# These functions use the built-in connection by default, so we don't need to specify connection
# Resgister a data.frame to the built-in connection
polarssql_register(df = mtcars)

# Get the query result as a polars DataFrame
polarssql_query("SELECT * FROM df WHERE cyl = 4", result_type = "polars_df")
#> shape: (11, 11)
#> ┌──────┬─────┬───────┬───────┬───┬─────┬─────┬──────┬──────┐
#> │ mpg  ┆ cyl ┆ disp  ┆ hp    ┆ … ┆ vs  ┆ am  ┆ gear ┆ carb │
#> │ ---  ┆ --- ┆ ---   ┆ ---   ┆   ┆ --- ┆ --- ┆ ---  ┆ ---  │
#> │ f64  ┆ f64 ┆ f64   ┆ f64   ┆   ┆ f64 ┆ f64 ┆ f64  ┆ f64  │
#> ╞══════╪═════╪═══════╪═══════╪═══╪═════╪═════╪══════╪══════╡
#> │ 22.8 ┆ 4.0 ┆ 108.0 ┆ 93.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 24.4 ┆ 4.0 ┆ 146.7 ┆ 62.0  ┆ … ┆ 1.0 ┆ 0.0 ┆ 4.0  ┆ 2.0  │
#> │ 22.8 ┆ 4.0 ┆ 140.8 ┆ 95.0  ┆ … ┆ 1.0 ┆ 0.0 ┆ 4.0  ┆ 2.0  │
#> │ 32.4 ┆ 4.0 ┆ 78.7  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ …    ┆ …   ┆ …     ┆ …     ┆ … ┆ …   ┆ …   ┆ …    ┆ …    │
#> │ 27.3 ┆ 4.0 ┆ 79.0  ┆ 66.0  ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 1.0  │
#> │ 26.0 ┆ 4.0 ┆ 120.3 ┆ 91.0  ┆ … ┆ 0.0 ┆ 1.0 ┆ 5.0  ┆ 2.0  │
#> │ 30.4 ┆ 4.0 ┆ 95.1  ┆ 113.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 5.0  ┆ 2.0  │
#> │ 21.4 ┆ 4.0 ┆ 121.0 ┆ 109.0 ┆ … ┆ 1.0 ┆ 1.0 ┆ 4.0  ┆ 2.0  │
#> └──────┴─────┴───────┴───────┴───┴─────┴─────┴──────┴──────┘

# Unregister the data.frame
polarssql_unregister("df")
```
