library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

# define universal objects
p_width <- 12
p_height <- 7
p_units <- "in"

p1_targets_list <- list(
  tar_target(
    site_data_01427207,
    download_nwis_data(site_nums = '01427207'),
  ),
  tar_target(
    site_data_01432160,
    download_nwis_data(site_nums = '01432160'),
  ),
  tar_target(
    site_data_01435000,
    download_nwis_data(site_nums = '01435000'),
  ),
  tar_target(
    site_data_01436690,
    download_nwis_data(site_nums = '01436690'),
  ),
  tar_target(
    site_data_01466500,
    download_nwis_data(site_nums = '01466500'),
  ),
  tar_target(
    site_data_csv,
    {
      out_file <- '1_fetch/out/site_data.csv'
      bind_rows(site_data_01427207, site_data_01432160, site_data_01435000, site_data_01436690, site_data_01466500) %>%
        readr::write_csv(file = out_file)
      return(out_file)
    },
    format = 'file'
    
  ),
  tar_target(
    site_info,
    nwis_site_info(site_data_csv),
  )
)

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

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_styled,
                         width = p_width, height = p_height, units = p_units),    
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
