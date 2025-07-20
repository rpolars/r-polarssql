.onLoad <- function(libname, pkgname) {
  s3_register("dplyr::compute", "tbl_polarssql_connection")
  s3_register("dplyr::collect", "tbl_polarssql_connection")
  s3_register("tibble::as_tibble", "tbl_polarssql_connection")
  s3_register("dbplyr::dbplyr_edition", "polarssql_connection")

  invisible()
}
