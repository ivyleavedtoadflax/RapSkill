# demo — Output Generation
#
# RAP principle: Outputs are generated programmatically, never by
# manual copy-paste into spreadsheets or documents. Use {a11ytables}
# for accessible spreadsheets and {rmarkdown} for reports so that
# outputs meet Government Analysis Function accessibility standards.

#' Create publication outputs
#'
#' @description Generates all outputs from analysis results, writing
#'   them to the `output/` directory. Outputs are reproducible — running
#'   this function always overwrites previous outputs with fresh versions.
#'
#' @param results A named list of analysis results from [analyse_data()].
#' @param output_dir Character. Path to the output directory.
#'   Defaults to `here::here("output")`.
#'
#' @return Invisibly returns the output directory path.
#'
#' @examples
#' \dontrun{
#'   raw <- read_source_data()
#'   processed <- process_data(raw)
#'   results <- analyse_data(processed)
#'   create_output(results)
#' }
#'
#' @export
create_output <- function(results, output_dir = here::here("output")) {

  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  logger::log_info("Writing outputs to {output_dir}")

  # TODO: Replace with your actual output generation.
  #
  # Common RAP output patterns:
  #
  # 1. Accessible spreadsheet (ODS) via {a11ytables}:
  #    workbook <- a11ytables::create_a11ytable(...) |>
  #      a11ytables::generate_workbook()
  #    openxlsx::saveWorkbook(workbook, file.path(output_dir, "tables.xlsx"))
  #
  # 2. CSV summary:
  #    readr::write_csv(results$summary_table,
  #      file.path(output_dir, "summary.csv"))
  #
  # 3. R Markdown report:
  #    rmarkdown::render("report.Rmd",
  #      output_dir = output_dir,
  #      params = list(results = results))

  # Placeholder: write summary table as CSV
  readr::write_csv(
    results$summary_table,
    file.path(output_dir, "summary.csv")
  )

  logger::log_info("Outputs written to {output_dir}")

  invisible(output_dir)
}
