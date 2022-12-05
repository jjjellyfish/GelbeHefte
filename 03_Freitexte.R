library(tidyverse)
library(xlsx)

load('gh_clean.rda')

# Notizen der Eltern
tmp <- dat %>% select(GH_ID, contains('ausgefüllt'), contains('Elterninfo_Freitext')) %>%
  pivot_longer(contains('Elterninfo_Freitext'), names_to='u', values_to = "var") %>%
  pivot_longer(contains('ausgefüllt'), names_to='u_data', values_to = "data") %>%
  mutate(u=str_extract(u, "[^_]+"),
         u_data=str_extract(u_data, "[^_]+")) %>%
  filter(u==u_data & data==1) %>%
  naniar::replace_with_na(replace = list(var = 99)) %>%
  select(-u_data, -data) %>% 
  na.omit()

notizen <- tmp

write.csv(notizen, '02_freitext_data/Freitexte_NotizenEltern.csv', row.names = FALSE)
write.xlsx(notizen, file='02_freitext_data/Freitexte_NotizenEltern.xlsx')


# Auffälligkeiten
tmp <- dat %>% select(GH_ID, contains('ausgefüllt'), contains('Auffaelligkeiten_Freitext')) %>%
  pivot_longer(contains('Auffaelligkeiten_Freitext'), names_to='u', values_to = "var") %>%
  pivot_longer(contains('ausgefüllt'), names_to='u_data', values_to = "data") %>%
  mutate(u=str_extract(u, "[^_]+"),
         u_data=str_extract(u_data, "[^_]+")) %>%
  filter(u==u_data & data==1) %>%
  naniar::replace_with_na(replace = list(var = 99)) %>%
  select(-u_data, -data) %>% 
  na.omit()

auff <- tmp

write.csv(auff, '02_freitext_data/Freitexte_Auffaelligkeiten.csv', row.names = FALSE)
write.xlsx(auff, file='02_freitext_data/Freitexte_Auffaelligkeiten.xlsx')