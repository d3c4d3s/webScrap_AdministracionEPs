library(rvest)
library(tidyverse)

base_url <- "http://www.sepchile.cl/"

pag1 <- read_html(paste(base_url, "empresas-sep/portuario/", sep = ""))


urls <- paste(base_url, pag1 %>% html_nodes(".title > a") %>% html_attr("href"),
              sep = "")

tabla_dir <- data_frame()

for (url in urls) {
  pe <- read_html(url)
  nom_ep <- pe %>% html_node(".title") %>% html_text()
  t_dir <- pe %>% html_nodes(".contenttable") %>% html_table()
  t_dir <- as_tibble(t_dir[[1]])
  t_dir <- t_dir %>% mutate("Empresa Portuaria" = nom_ep)
  
  tabla_dir <- bind_rows(tabla_dir,t_dir)
}

names(tabla_dir)[1] <- "Cargo"
names(tabla_dir)[2] <- "Nombre"

tabla_dir <- tabla_dir %>% filter(Cargo != "Directorio" & Cargo != "Ejecutivos")

write.csv(tabla_dir, file="directorio.csv", row.names = FALSE)