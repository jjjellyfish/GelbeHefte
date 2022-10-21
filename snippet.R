## absolut
tmp <- dat %>% 
  select(GH_ID, contains('ausgefüllt'), contains('Sehschwaeche_links')) %>% 
  pivot_longer(., contains('Sehschwaeche_links'), names_to='u', values_to = "var") %>% 
  pivot_longer(., contains('ausgefüllt'), names_to='u_data', values_to = "data") %>% 
  mutate(u=str_extract(u, "[^_]+"), 
         u_data=str_extract(u_data, "[^_]+")) %>% 
  filter(u==u_data & data==1) %>% 
  naniar::replace_with_na(replace = list(var = 99)) %>% 
  select(-u_data, -data) %>% 
  mutate(cat=case_when(as.numeric(var)>=3 ~ '3+', TRUE ~ as.character(var))) %>% 
  group_by(u, cat) %>%
  tally() %>%
  pivot_wider(., names_from = u, values_from = n) %>%
  janitor::adorn_totals(c('row', 'col'), name = c('Ges.','Ges.'), na.rm=TRUE) %>%
  untabyl() %>% 
  rbind(., c('valide', colSums(.[1:(nrow(.)-2),2:length(.)], na.rm = TRUE))) %>% 
  mutate_at(vars(-cat), as.numeric)


## relativ
tmp2 <- tmp %>% 
  slice_head(n=-3) %>% 
  janitor::adorn_percentages('col') %>% 
  untabyl() %>% 
  janitor::adorn_totals('row', name='valides n') %>% 
  janitor::adorn_pct_formatting(digits = 1, affix_sign = FALSE) #%>% 