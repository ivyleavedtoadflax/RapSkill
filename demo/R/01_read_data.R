# demo — Data Ingestion
#
# RAP principle: Data ingestion is separated from processing so that
# the raw-to-tidy boundary is explicit and auditable. Use {readr} or
# {readxl} for reproducible file parsing with column type specifications.

#' Read source data
#'
#' @description Reads raw data from the `data/` directory. Column types
#'   are specified explicitly to prevent silent type coercion.
#'
#' @param data_dir Character. Path to the data directory.
#'   Defaults to `here::here("data")`.
#'
#' @return A tibble of raw source data, unmodified from its original form.
#'
#' @examples
#' \dontrun{
#'   raw_data <- read_source_data()
#' }
#'
#' @export
read_source_data <- function(data_dir = here::here("data")) {

  logger::log_info("Reading source data from {data_dir}")

  # TODO: Replace with your actual data source.

  # Example: read a CSV with explicit column types
  # raw <- readr::read_csv(
  #   file.path(data_dir, "input.csv"),
  #   col_types = readr::cols(
  #     id     = readr::col_integer(),
  #     date   = readr::col_date(format = "%Y-%m-%d"),
  #     value  = readr::col_double(),
  #     region = readr::col_character()
  #   )
  # )

  # Placeholder: return an empty tibble

  raw <- tibble::tibble()

  logger::log_info("Read {nrow(raw)} rows from source data")

  raw
}
