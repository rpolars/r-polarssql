if (requireNamespace("DBItest", quietly = TRUE) && identical(Sys.getenv("NOT_CRAN"), "true")) {
  DBItest::test_all()
}
