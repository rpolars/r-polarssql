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
      "disconnect_invalid_connection"
    )
  )
}
