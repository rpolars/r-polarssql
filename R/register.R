#' Register data frames as tables
#'
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Name-value pairs of [data.frame] like objects to register.
#' @param .conn,conn A polarssql connection, created by [polarssql()].
#' Use the default built-in connection by default.
#' @param names Names of the tables to unregister.
#' @param .overwrite Should an existing registration be overwritten?
#' @return The polarssql connection invisibly.
#' @export
#' @examplesIf polars::pl$polars_info()$features$sql
#' con <- dbConnect(polarssql())
#'
#' polarssql_register(df1 = mtcars, df2 = mtcars, .conn = con)
#' con
#'
#' polarssql_unregister(c("df1", "df2"), conn = con)
#' con
polarssql_register <- function(..., .conn = polarssql_default_connection(), .overwrite = FALSE) {
  stopifnot(dbIsValid(.conn))

  context <- .conn@env$context
  dots <- list2(...)

  if (!isTRUE(.overwrite)) {
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

  invisible(.conn)
}


#' @rdname polarssql_register
#' @export
polarssql_unregister <- function(names, conn = polarssql_default_connection()) {
  stopifnot(dbIsValid(conn))

  context <- conn@env$context
  existing_tables <- context$tables()

  if (!all(names %in% existing_tables)) {
    message(
      "Some tables '",
      setdiff(names, existing_tables) |> paste0(collapse = "', '"),
      "' do not exist."
    )
  }

  context$unregister(names)
  invisible(conn)
}
