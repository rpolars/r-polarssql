#' Register data frames as tables
#'
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Name-value pairs of [data.frame] like objects to register.
#' @param conn A polarssql connection, created by [polarssql()]. Use the default connection by default.
#' @param names Names of the tables to unregister.
#' @param overwrite Should an existing registration be overwritten?
#' @return These functions are called for their side effect.
#' @export
#' @examplesIf polars::pl$polars_info()$features$sql
#' polarssql_register(df1 = mtcars, df2 = mtcars)
#' polarssql_default_connection()
#'
#' polarssql_unregister(c("df1", "df2"))
#' polarssql_default_connection()
polarssql_register <- function(..., conn = polarssql_default_connection(), overwrite = FALSE) {
  stopifnot(dbIsValid(conn))

  context <- conn@context
  dots <- list2(...)

  if (!isTRUE(overwrite)) {
    existing_tables <- context$tables()
    new_tables <- names(dots)
    if (any(new_tables %in% existing_tables)) {
      stop(
        "Some tables '",
        intersect(new_tables, existing_tables) |> paste0(collapse = "', '"),
        "' already exist.\n",
        "Set `overwrite = TRUE` if you want to remove the existing table."
      )
    }
  }

  exec(context$register_many, !!!dots)

  invisible(TRUE)
}


#' @rdname polarssql_register
#' @export
polarssql_unregister <- function(names, conn = polarssql_default_connection()) {
  stopifnot(dbIsValid(conn))

  context <- conn@context
  existing_tables <- context$tables()

  if (!all(names %in% existing_tables)) {
    message(
      "Some tables '",
      setdiff(names, existing_tables) |> paste0(collapse = "', '"),
      "' do not exist."
    )
  }

  context$unregister(names)
  invisible(TRUE)
}
