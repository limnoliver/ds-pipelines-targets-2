source("2_process/src/process_and_style.R")

p2_targets_list <- list(
  tar_target(
    site_data_clean, 
    process_data(site_data_csv)
  ),
  tar_target(
    site_data_annotated,
    annotate_data(site_data_clean, site_filename = site_info)
  ),
  tar_target(
    site_data_styled,
    style_data(site_data_annotated)
  )
)