.onLoad <- function(libname, pkgname) {
  s3_register("dbplyr::dbplyr_edition", "polarssql_connection")
}
