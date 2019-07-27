library(reticulate)


requests <- import("requests")

file_fetcher <- function(url){
  link_page <- requests$get(url = url, verify = FALSE)
  
  file_urls <- link_page$content %>%
    as.character() %>%
    read_html() %>%
    html_node("table") %>%
    html_node("tbody") %>%
    html_nodes("a") %>%
    html_attr("href")
  
  return(file_urls)
}


file_fetcher(url)

page_urls <- c('http://estadisticas.pr/en/estadisticas-mas-recientes?type=pr_hiv_aids_surveillance_summary&page=0',
               'http://estadisticas.pr/en/estadisticas-mas-recientes?type=pr_hiv_aids_surveillance_summary&page=1')

all_files <- c()

for (url in page_urls){
  all_files <- append(all_files, file_fetcher(url))
}


file_namer <- function(string, format = 'new'){
  
  if (format == 'new'){
      file_name <- string %>%
        stringr::str_remove_all(., 'https\\:\\/\\/estadisticas\\.pr\\/files\\/inventario\\/pr_hiv_aids_surveillance_summary\\/') %>%
        stringr::str_split(., '\\/') %>%
        .[[1]] %>%
        .[2]
  } else if (format == 'old'){
    file_name <- string %>%
      stringr::str_remove_all(., 'https\\:\\/\\/estadisticas\\.pr\\/files\\/Documentos\\/') %>%
      stringr::str_split(., '\\/') %>%
      .[[1]] %>%
      .[2]
  }
  
  return(file_name)
}


for (i in 1:length(all_files)){
  
  if (i < 24){
    file_name <- file_namer(all_files[i])
    
    file_path <- paste0('hiv/zip_files/', file_name)
    
    download.file(all_files[i], file_path, method = 'wget', extra = c('--no-check-certificate'))
  } else {
    file_name <- file_namer(all_files[i], format = 'old')
    
    file_path <- paste0('hiv/zip_files/', file_name)
    
    download.file(all_files[i], file_path, method = 'wget', extra = c('--no-check-certificate'))
  }
  
  
}