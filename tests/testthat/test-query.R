patrick::with_parameters_test_that(
  "result type",
  {
    query <- "SELECT * FROM mtcars LIMIT 5"
    polarssql_register(mtcars = mtcars, .overwrite = TRUE)
    out <- polarssql_query(query, result_type = result_type)
    expect_s3_class(out, expect_type)
    polarssql_unregister("mtcars")
  },
  patrick::cases(
    pl_lf = list(result_type = "polars_lf", expect_type = "LazyFrame"),
    pl_df = list(result_type = "polars_df", expect_type = "DataFrame"),
    df = list(result_type = "data_frame", expect_type = "data.frame"),
    nanoarrow = list(result_type = "nanoarrow_array_stream", expect_type = "nanoarrow_array_stream")
  )
)
