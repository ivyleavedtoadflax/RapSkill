# demo — Analysis
#
# RAP principle: Analysis code produces intermediate outputs (summary
# tables, model objects) that are passed to the output stage. Keep
# analysis logic separate from formatting so that results can be
# validated independently of their presentation.

#' Run statistical analysis
#'
#' @description Performs the core analysis on processed data. Returns
#'   summary statistics or model results as a named list.
#'
#' @param processed_data A tibble of cleaned data from [process_data()].
#'
#' @return A named list containing analysis results. At minimum:
#'   \describe{
#'     \item{summary_table}{A tibble of summary statistics}
#'   }
#'
#' @examples
#' \dontrun{
#'   raw <- read_source_data()
#'   processed <- process_data(raw)
#'   results <- analyse_data(processed)
#' }
#'
#' @export
analyse_data <- function(processed_data) {

  logger::log_info("Analysing {nrow(processed_data)} rows")

  # TODO: Replace with your actual analysis.
  #
  # Common RAP analysis patterns:
  # - Group-level summaries: dplyr::group_by() |> dplyr::summarise()
  # - Time series aggregation: dplyr::summarise(.by = period)
  # - Percentage calculations: dplyr::mutate(pct = n / sum(n) * 100)
  # - Year-on-year change: dplyr::mutate(change = value - dplyr::lag(value))

  summary_table <- processed_data |>
    dplyr::summarise(
      n = dplyr::n(),
      .groups = "drop"
    )

  logger::log_info("Analysis complete")

  list(
    summary_table = summary_table
  )
}
