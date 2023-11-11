if (requireNamespace("DBItest", quietly = TRUE)) {
  DBItest::make_context(
    polarssql(),
    list(),
    tweaks = suppressWarnings(DBItest::tweaks(
      dbitest_version = "1.7.3"
    )),
    name = "polarssql",
    default_skip = c(
      "package_name", # It requires the package name starts with "R"
      # TODO: Remove when dbDataType() is implemented
      "data_type_driver",
      # TODO: Remove when dbDisconnect() is implemented
      "can_disconnect",
      "disconnect_closed_connection",
      "disconnect_invalid_connection",
      # TODO: fix segfault when calling `pl$SQLcontext()$execute("show tables")` to check the connection
      "send_query_invalid_connection",
      "get_query_invalid_connection",
      "send_statement_invalid_connection",
      "execute_invalid_connection",
      "read_table_invalid_connection",
      "create_table_invalid_connection",
      "append_table_invalid_connection",
      "write_table_invalid_connection",
      "list_fields_invalid_connection",
      "is_valid_stale_connection",
      "temporary_table",
      "create_temporary_table"
    )
  )
}
