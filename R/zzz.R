.onLoad <- function(libname, pkgname) {
  s3_register("dplyr::compute", "tbl_polarssql_connection")
  s3_register("dbplyr::dbplyr_edition", "polarssql_connection")
  s3_register("dbplyr::sql_query_join", "polarssql_connection")

  invisible()
}
