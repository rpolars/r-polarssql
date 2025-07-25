% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/default_connection.R
\name{polarssql_default_connection}
\alias{polarssql_default_connection}
\title{Get the default connection}
\usage{
polarssql_default_connection()
}
\value{
A polarssql connection object
}
\description{
Get the default built-in connection.
}
\examples{
# Clean up
DBI::dbDisconnect(polarssql_default_connection())

polarssql_default_connection()

# Register a Table
polarssql_register(mtcars = mtcars)

polarssql_default_connection()

# Clean up
polarssql_unregister("mtcars")

polarssql_default_connection()
}
