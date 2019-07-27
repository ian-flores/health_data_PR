library(fs)
library(tidyverse)

all_files <- dir_ls('hiv/zip_files')

for (i in 1:length(all_files)){
  unzip(all_files[i], exdir = 'hiv/raw_files/', junkpaths = T)
}

raw_files <- dir_ls('hiv/raw_files')


maps <- map_lgl(raw_files, ~str_detect(.x, 'MAPA'))

maps_to_move <- raw_files[maps]

dir_create('hiv/raw_files/maps')

for (i in 1:length(maps_to_move)){
  file_move(maps_to_move[i], paste0(path_dir(maps_to_move[i]), '/maps'))
}

reports_to_move <- raw_files[!maps]

dir_create('hiv/raw_files/reports')

for (i in 1:length(reports_to_move)){
  file_move(reports_to_move[i], paste0(path_dir(reports_to_move[i]), '/reports'))
}

reports_path <- dir_ls('hiv/raw_files/reports/')


dir_create('hiv/raw_files/reports/aids')
dir_create('hiv/raw_files/reports/hiv')
dir_create('hiv/raw_files/reports/hiv_aids')

for (i in 1:length(reports_path)){
  aids_only <- reports_path[i] %>%
    str_to_lower() %>%
    str_detect('puerto rico aids surveillance')
  
  hiv_only <- reports_path[i] %>%
    str_to_lower() %>%
    str_detect('puerto rico hiv not aids surveillance')
  
  hiv_aids <- reports_path[i] %>%
    str_to_lower() %>%
    str_detect('puerto rico hivaids surveillance')
  
  if (aids_only){
    file_move(reports_path[i], paste0(path_dir(reports_path[i]), '/aids'))
  } else if (hiv_only){
    file_move(reports_path[i], paste0(path_dir(reports_path[i]), '/hiv'))
  } else if (hiv_aids){
    file_move(reports_path[i], paste0(path_dir(reports_path[i]), '/hiv_aids'))
  }
}

file_move('hiv/raw_files/reports/Puerto Rico HIV not AIDS UDI Surveillance Summary.pdf', 'hiv/raw_files/reports/hiv/')
file_move('hiv/raw_files/reports/Puerto Rico HIV AIDS Surveillance Summary diciembre 2012.pdf', 'hiv/raw_files/reports/hiv_aids/')
file_move('hiv/raw_files/reports/Puerto Rico HIV AIDS Surveillance Summary julio 2013.pdf', 'hiv/raw_files/reports/hiv_aids/')
file_move('hiv/raw_files/reports/Puerto Rico HIV AIDS Surveillance Summary junio 2013.pdf', 'hiv/raw_files/reports/hiv_aids/')

## Need to modularize and add maps