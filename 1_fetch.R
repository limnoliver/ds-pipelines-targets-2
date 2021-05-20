source("1_fetch/src/get_nwis_data.R")

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

