patrick::with_parameters_test_that(
  "result type",
  {
    query <- "SELECT * FROM mtcars LIMIT 5"
    polarssql_register(mtcars = mtcars, .overwrite = TRUE)
    out <- polarssql_query(query)
    expect_s3_class(out, expect_type)
    polarssql_unregister("mtcars")
  },
  patrick::cases(
    pl_lf = list(expect_type = "LazyFrame")
  )
)
