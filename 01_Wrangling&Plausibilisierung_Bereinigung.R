#### Prüfung Testdatenlieferungen ####

library(tidyverse) #alle tidy-packages auf einmal
library(psych)
library(openxlsx)

setwd('O:/U4951/Consulimus_Abschlussdatenlieferung/01_GelbeHefte')


# Trimfunktion
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
trim_data <- function(x){
  for(idx_trim in 1:dim(x)[2]){
    if(is.character(x[,idx_trim])){
      x[,idx_trim] <- trim(x[,idx_trim])
    }
    x[x[,idx_trim] %in% "",idx_trim] <- NA
  }
  return(x)
}


#### Gelbe Hefte ####
dat <- read.xlsx('Gelbe_Hefte_Gesamt_20211019_bearbeitet.xlsx')

dat <- dat[2:nrow(dat),]
dat <- select(dat, 'X5', 'X9':length(dat))
dat <- as.data.frame(t(dat))

colnames(dat) <- dat[1,]
dat <- dat[2:nrow(dat),]
rownames(dat) <- 1:nrow(dat)
names(dat)


# zwischenspeichern (zum in Excel angucken) 
gh <- dat
write.xlsx(gh, file='GelbeHefte_unbereinigt.xlsx')

# trimmen: Leerzeichen raus
dat <- trim_data(dat)


# ID ok? 
dat$GH_ID
# komische ID '20210204-007_U6'


# U-Heft-Kopien liegen vor
# minimale Unreinheiten: NAs werden durch 'nein'(2) ersetzt
table(dat$U2_Kopien, useNA='always')
table(dat$U2_ausgefüllt, useNA='always')

table(dat$U3_Kopien, useNA='always')
table(dat$U3_ausgefüllt, useNA='always')
dat[is.na(dat$U3_Kopien), 'U3_Kopien'] <- '2'
dat[is.na(dat$U3_ausgefüllt), 'U3_ausgefüllt'] <- '2'

table(dat$U4_Kopien, useNA='always')
table(dat$U4_ausgefüllt, useNA='always')

table(dat$U5_Kopien, useNA='always')
table(dat$U5_ausgefüllt, useNA='always')
dat[is.na(dat$U5_Kopien), 'U5_Kopien'] <- '2'
dat[is.na(dat$U5_ausgefüllt), 'U5_ausgefüllt'] <- '2'

table(dat$U6_Kopien, useNA='always')
table(dat$U6_ausgefüllt, useNA='always')
dat[is.na(dat$U6_Kopien), 'U6_Kopien'] <- '2'
dat[is.na(dat$U6_ausgefüllt), 'U6_ausgefüllt'] <- '2'

table(dat$U7_Kopien, useNA='always')
table(dat$U7_ausgefüllt, useNA='always')
dat[is.na(dat$U7_Kopien), 'U7_Kopien'] <- '2'
dat[is.na(dat$U7_ausgefüllt), 'U7_ausgefüllt'] <- '2'

table(dat$U7a_Kopien, useNA='always')
table(dat$U7a_ausgefüllt, useNA='always')
dat[is.na(dat$U7a_Kopien), 'U7a_Kopien'] <- '2'
dat[is.na(dat$U7a_ausgefüllt), 'U7a_ausgefüllt'] <- '2'

table(dat$U8_Kopien, useNA='always')
table(dat$U8_ausgefüllt, useNA='always')
dat[is.na(dat$U8_Kopien), 'U8_Kopien'] <- '2'
dat[is.na(dat$U8_ausgefüllt), 'U8_ausgefüllt'] <- '2'

table(dat$U9_Kopien, useNA='always')
table(dat$U9_ausgefüllt, useNA='always')
dat[is.na(dat$U9_Kopien), 'U9_Kopien'] <- '2'
dat[is.na(dat$U9_ausgefüllt), 'U9_ausgefüllt'] <- '2'


# check IDs
sum(is.na(dat$GH_ID)) # OK



#### U2 ####
table(dat$U2_Kopien, useNA='always') # 263 mal keine U2 vorliegend
table(dat$U2_ausgefüllt, useNA='always') #276 mal nicht ausgefüllt

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U2_Kopien==2 & U2_ausgefüllt==2) #OK

# U2 Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U2_Kopien==1 & U2_ausgefüllt==1)


table(tmp$U2_Elterninfo, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U2_Elterninfo))
dat[is.na(dat$U2_Elterninfo), 'U2_Elterninfo'] <- '2'


# Untersuchung
# 99 und NA werden äquivalent verwendet, NA durch 99 ersetzen
table(tmp$U2_Untersuchung, useNA='always')

table(tmp$U2_morphologische_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U2_morphologische_Auffaelligkeiten))
dat[is.na(dat$U2_morphologische_Auffaelligkeiten), 'U2_morphologische_Auffaelligkeiten'] <- '99'

table(tmp$U2_Transillumination, useNA='always')

# Beratung
table(tmp$U2_Beratung, useNA='always')

# Ergebnisse
table(tmp$U2_Anamnese, useNA='always')
#table(tmp$U2_Anamnese_Freitext, useNA='always') 

# ungültige Kombinationen prüfen
tmp2 <- filter(tmp, U2_Anamnese=='1' & is.na(U2_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U2_Anamnese=='2' & !is.na(U2_Anamnese_Freitext)) 
dat[dat$U2_Anamnese=='2' & !is.na(dat$U2_Anamnese_Freitext), 'U2_Anamnese'] <- 1

table(tmp$U2_KGewicht, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U2_KGewicht))
dat[is.na(dat$U2_KGewicht), 'U2_KGewicht'] <- '2'
dat[dat$GH_ID=='20210312-038', 'U2_KGewicht'] <- '1'
dat[dat$GH_ID=='20210512-028', 'U2_KGewicht'] <- '1'

table(tmp$U2_KLaenge, useNA='always')
dat[is.na(dat$U2_KLaenge), 'U2_KLaenge'] <- '2'
dat[dat$GH_ID=='20210312-038', 'U2_KLaenge'] <- '1'
dat[dat$GH_ID=='20210512-028', 'U2_KLaenge'] <- '1'

table(tmp$U2_Kopfumfang, useNA='always')
dat[is.na(dat$U2_Kopfumfang), 'U2_Kopfumfang'] <- '2'
dat[dat$GH_ID=='20210312-038', 'U2_Kopfumfang'] <- '1'
dat[dat$GH_ID=='20210512-028', 'U2_Kopfumfang'] <- '1'


table(tmp$U2_keineAuffaelligkeiten, useNA='always') # passt nicht zusammen
tmp2 <- filter(tmp, is.na(tmp$U2_keineAuffaelligkeiten))
dat[is.na(dat$U2_keineAuffaelligkeiten), 'U2_keineAuffaelligkeiten'] <- '2'

table(tmp$U2_Auffaelligkeiten, useNA='always')
#table(tmp$U2_Auffaelligkeiten_Freitext, useNA='always')



#***************************************
### Prüfung & Bereinigung von Auffälligkeiten
tmp2 <- select(tmp, GH_ID, U2_keineAuffaelligkeiten:U2_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U2_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U2_Auffaelligkeiten==1 & is.na(U2_Auffaelligkeiten_Freitext))

# Erfassungsfehler bereinigen
dat[dat$GH_ID=='20210216-048', 'U2_Auffaelligkeiten_Freitext'] <- 'H?ftzone verziehen'
dat[dat$GH_ID=='20210218-007', 'U2_Auffaelligkeiten'] <- '2'
dat[dat$GH_ID=='20210519-023', 'U2_Auffaelligkeiten_Freitext'] <- 'dezenter respiratorischer Stridor, H?matom rechts parreto-occipital (r?ckl?ufig), verz?gerte lichtreagible Augen'



# gibt es Kombi aus Eintrag liegt nicht vor (U2_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U2_Auffaelligkeiten==2 & !is.na(U2_Auffaelligkeiten_Freitext))
# tritt neunmal auf, davon aber einmal nur Leerzeichen (0,47%)

# Erfassungsfehler bereinigen
dat[dat$GH_ID=='2021018-003', 'U2_Auffaelligkeiten_Freitext'] <- NA

tmp_ids <- tmp3$GH_ID[2:nrow(tmp3)]
dat[dat$GH_ID %in% tmp_ids, 'U2_Auffaelligkeiten'] <- '1'


# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U2_Auffaelligkeiten==1 & 
                             is.na(tmp2$U2_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U2_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U2_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U2_keineAuffaelligkeiten==1 & 
                             tmp2$U2_Auffaelligkeiten==2 & 
                             is.na(tmp2$U2_Auffaelligkeiten_Freitext), 
                             'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U2_keineAuffaelligkeiten==2 & 
                              tmp2$U2_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U2_keineAuffaelligkeiten==2 & 
                              tmp2$U2_Auffaelligkeiten==2 &
                              is.na(tmp2$U2_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U2_keineAuffaelligkeiten==99 | tmp2$U2_Auffaelligkeiten==99)

# Erfassungsfehler bereinigen
tmp_ids <- c('20210312-020', '20210312-055', '20210312-061')
dat[dat$GH_ID %in% tmp_ids, 'U2_keineAuffaelligkeiten'] <- '2'


tmp2$auff_status <-  ifelse(tmp2$U2_keineAuffaelligkeiten==99 & 
                              tmp2$U2_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U2_keineAuffaelligkeiten==99 & tmp2$U2_Auffaelligkeiten!=99) |
                            (tmp2$U2_keineAuffaelligkeiten!=99 & tmp2$U2_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U2_keineAuffaelligkeiten==1 & 
                              tmp2$U2_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt ?brig? 
tmp3 <- filter(tmp2, is.na(auff_status))



#*****************************************************
table(tmp$U2_VitaminK_ja, useNA='always')
table(tmp$U2_VitaminK_Dosis_2mg, useNA='always')
table(tmp$U2_VitaminK_abwDosis, useNA='always')
table(tmp$U2_VitaminK_nein, useNA='always')
# hier nochmal kl?ren, was die Auspr?gungen bedeuten
# aus meiner Erinnerung: 
# ja == 1
# nein (= ja nicht angekreuzt) == 2
# 99 == gesamter Bereich nicht angekreuzt


# Erfassungsfehler bereinigen: NAs
tmp2 <- filter(tmp, is.na(U2_VitaminK_nein))
dat[is.na(dat$U2_VitaminK_nein), 'U2_VitaminK_nein'] <- '2'

# Erfassungsfehler bereinigen: '99' falsch verwendet
tmp2 <- filter(tmp, U2_VitaminK_ja==99)
dat[dat$GH_ID=='20210312-020', 'U2_VitaminK_ja'] <- '2'
dat[dat$GH_ID=='20210312-020', 'U2_VitaminK_Dosis_2mg'] <- '2'



#*****************************************************************************
#### U3 ####
table(dat$U3_Kopien, useNA='always') 
table(dat$U3_ausgefüllt, useNA='always')

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U3_Kopien==2 & U3_ausgefüllt==2) %>%
  select(GH_ID, contains('U3'))


# U3 Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U3_Kopien==1 & U3_ausgefüllt==1) %>%
  select(GH_ID, contains('U3'))


table(tmp$U3_Elterninfo, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U3_Elterninfo))
dat[is.na(dat$U3_Elterninfo), 'U3_Elterninfo'] <- '2'


# Untersuchung
# 99 und NA werden ?quivalent verwendet, NA durch 99 ersetzen
table(tmp$U3_Untersuchung, useNA='always')

table(dat$U3_morphologische_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, tmp$U3_morphologische_Auffaelligkeiten=='0')
dat$U3_morphologische_Auffaelligkeiten[dat$U3_morphologische_Auffaelligkeiten=='0'] <- '1'

table(dat$U3_Transillumination, useNA='always')
dat$U3_Transillumination[dat$U3_Transillumination=='0'] <- '1'

# Beratung
table(tmp$U3_Beratung, useNA='always')

# Ergebnisse
table(tmp$U3_Anamnese, useNA='always')
#table(tmp$U3_Anamnese_Freitext, useNA='always') 

# ung?ltige Kombinationen pr?fen
tmp2 <- filter(tmp, U3_Anamnese=='1' & is.na(U3_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U3_Anamnese=='2' & !is.na(U3_Anamnese_Freitext)) 
dat$U3_Anamnese_Freitext[dat$U3_Anamnese=='2' & !is.na(dat$U3_Anamnese_Freitext)] <- NA

table(dat$U3_KGewicht, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U3_KGewicht))
dat[is.na(dat$U3_KGewicht), 'U3_KGewicht'] <- '2'

table(tmp$U3_KLaenge, useNA='always')
dat[is.na(dat$U3_KLaenge), 'U3_KLaenge'] <- '2'

table(tmp$U3_Kopfumfang, useNA='always')
dat[is.na(dat$U3_Kopfumfang), 'U3_Kopfumfang'] <- '2'


table(tmp$U3_keineAuffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U3_keineAuffaelligkeiten))
dat[is.na(dat$U3_keineAuffaelligkeiten), 'U3_keineAuffaelligkeiten'] <- '2'

table(dat$U3_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U3_Auffaelligkeiten))
dat$U3_Auffaelligkeiten[is.na(dat$U3_keineAuffaelligkeiten)] <- '2'

#table(tmp$U3_Auffaelligkeiten_Freitext, useNA='always')



#***************************************
### Prüfung & Bereinigung von Auffälligkeiten
tmp2 <- select(tmp, GH_ID, U3_keineAuffaelligkeiten:U3_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U3_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U3_Auffaelligkeiten==1 & is.na(U3_Auffaelligkeiten_Freitext))

# Erfassungsfehler bereinigen
dat[dat$GH_ID=='20210222-008', 'U3_Auffaelligkeiten_Freitext'] <- 'Systolkurve [unlesbar]'
dat[dat$GH_ID=='20210526-003', 'U3_Auffaelligkeiten_Freitext'] <- '[unlesbar]'


# gibt es Kombi aus Eintrag liegt nicht vor (U3_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U3_Auffaelligkeiten==2 & !is.na(U3_Auffaelligkeiten_Freitext))
# tritt neunmal auf, davon aber einmal nur Leerzeichen (0,47%)



tmp_ids <- tmp3$GH_ID[2:nrow(tmp3)]
dat[dat$GH_ID %in% tmp_ids, 'U3_Auffaelligkeiten'] <- '1'
dat[dat$GH_ID %in% '20210115-047#', 'U3_Auffaelligkeiten'] <- '1'

# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U3_Auffaelligkeiten==1 & 
                             is.na(tmp2$U3_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U3_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U3_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U3_keineAuffaelligkeiten==1 & 
                             tmp2$U3_Auffaelligkeiten==2 & 
                             is.na(tmp2$U3_Auffaelligkeiten_Freitext), 
                           'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U3_keineAuffaelligkeiten==2 & 
                              tmp2$U3_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U3_keineAuffaelligkeiten==2 & 
                              tmp2$U3_Auffaelligkeiten==2 &
                              is.na(tmp2$U3_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U3_keineAuffaelligkeiten==99 | tmp2$U3_Auffaelligkeiten==99)

# Erfassungsfehler bereinigen
tmp_ids <- c('20210226-007#', '20210408-012', '20210517-004', '20210517-008')
dat$U3_keineAuffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '2'


tmp2$auff_status <-  ifelse(tmp2$U3_keineAuffaelligkeiten==99 & 
                              tmp2$U3_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U3_keineAuffaelligkeiten==99 & tmp2$U3_Auffaelligkeiten!=99) |
                              (tmp2$U3_keineAuffaelligkeiten!=99 & tmp2$U3_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U3_keineAuffaelligkeiten==1 & 
                              tmp2$U3_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt übrig? 
tmp3 <- filter(tmp2, is.na(auff_status))
tmp_ids <- c('20210510-003', '20210510-016#')
dat[dat$GH_ID %in% tmp_ids, 'U3_Auffaelligkeiten'] <- '2'



#*****************************************************
table(tmp$U3_VitaminK_ja, useNA='always')
table(tmp$U3_VitaminK_Dosis_2mg, useNA='always')
table(tmp$U3_VitaminK_abwDosis, useNA='always')
table(tmp$U3_VitaminK_nein, useNA='always')
# hier nochmal kl?ren, was die Auspr?gungen bedeuten
# aus meiner Erinnerung: 
# ja == 1
# nein (= ja nicht angekreuzt) == 2
# 99 == gesamter Bereich nicht angekreuzt

tmp2 <- filter(tmp, U3_VitaminK_ja==99)


# Erfassungsfehler bereinigen: '99' falsch verwendet
tmp2 <- filter(tmp, U3_VitaminK_ja==99)
dat$U3_VitaminK_ja[dat$GH_ID=='20210312-020'] <- '2'
dat$U3_VitaminK_Dosis_2mg[dat$GH_ID=='20210312-020'] <- '2'


#*****************************************************************************
#### U4 ####
table(dat$U4_Kopien, useNA='always') 
table(dat$U4_ausgefüllt, useNA='always')

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U4_Kopien==2 & U4_ausgefüllt==2) %>%
  select(GH_ID, contains('U4'))

# U4 Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U4_Kopien==1 & U4_ausgefüllt==1) %>%
  select(GH_ID, contains('U4'))

table(dat$U4_Elterninfo, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U4_Elterninfo))
dat[is.na(dat$U4_Elterninfo), 'U4_Elterninfo'] <- '99'


# Untersuchung
# 99 und NA werden ?quivalent verwendet, NA durch 99 ersetzen
table(tmp$U4_Untersuchung, useNA='always')

table(tmp$U4_Brueckner, useNA='always')
tmp2 <- filter(tmp, tmp$U4_Brueckner=='0')
dat[dat$U4_Brueckner %in% '0', 'U4_Brueckner'] <- '2'

# Beratung
table(tmp$U4_Beratung, useNA='always')

# Ergebnisse
table(tmp$U4_Anamnese, useNA='always')
#table(tmp$U4_Anamnese_Freitext, useNA='always') 

# ung?ltige Kombinationen pr?fen
tmp2 <- filter(tmp, U4_Anamnese=='1' & is.na(U4_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U4_Anamnese=='2' & !is.na(U4_Anamnese_Freitext)) 
dat$U4_Anamnese[dat$U4_Anamnese=='2' & !is.na(dat$U4_Anamnese_Freitext)] <- '1'

table(tmp$U4_OBE_altersgem, useNA='always')


table(tmp$U4_KGewicht, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U4_KGewicht))
dat$U4_KGewicht[is.na(dat$U4_KGewicht)] <- '2'

tmp2 <- filter(tmp, tmp$U4_KGewicht=='99' | tmp$U4_KLaenge=='99' | tmp$U4_Kopfumfang=='99')

dat$U4_OBE_altersgem[dat$GH_ID=='20210312-038'] <- '1'
dat$U4_Kopfumfang[dat$GH_ID=='20210312-038'] <- '1'

table(tmp$U4_KLaenge, useNA='always')
dat$U4_KLaenge[is.na(dat$U4_KLaenge)] <- '2'

table(tmp$U4_Kopfumfang, useNA='always')
dat$U4_Kopfumfang[is.na(dat$U4_Kopfumfang)] <- '2'

table(tmp$U4_keineAuffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U4_keineAuffaelligkeiten))
dat$U4_keineAuffaelligkeiten[is.na(dat$U4_keineAuffaelligkeiten)] <- '2'

table(tmp$U4_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U4_Auffaelligkeiten))
dat$U4_Auffaelligkeiten[is.na(dat$U4_keineAuffaelligkeiten)] <- '2'


#***************************************
### Pr?fung & Bereinigung von Auff?lligkeiten
tmp2 <- select(tmp, GH_ID, U4_keineAuffaelligkeiten:U4_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U4_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U4_Auffaelligkeiten==1 & is.na(U4_Auffaelligkeiten_Freitext))

# Erfassungsfehler bereinigen
dat$U4_Auffaelligkeiten_Freitext[dat$GH_ID=='20210203-011j'] <- 'phys. Phimose S?R'
dat$U4_Auffaelligkeiten_Freitext[dat$GH_ID=='20210216-067'] <- '[unlesbar]'
dat$U4_Auffaelligkeiten[dat$GH_ID=='20210310-008j'] <- '2'

# gibt es Kombi aus Eintrag liegt nicht vor (U4_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U4_Auffaelligkeiten==2 & !is.na(U4_Auffaelligkeiten_Freitext))

dat$U4_Auffaelligkeiten[dat$GH_ID %in% '20210115-061'] <- '1'

# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U4_Auffaelligkeiten==1 & 
                             is.na(tmp2$U4_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U4_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U4_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U4_keineAuffaelligkeiten==1 & 
                             tmp2$U4_Auffaelligkeiten==2 & 
                             is.na(tmp2$U4_Auffaelligkeiten_Freitext), 
                           'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U4_keineAuffaelligkeiten==2 & 
                              tmp2$U4_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U4_keineAuffaelligkeiten==2 & 
                              tmp2$U4_Auffaelligkeiten==2 &
                              is.na(tmp2$U4_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U4_keineAuffaelligkeiten==99 | tmp2$U4_Auffaelligkeiten==99)

# Erfassungsfehler bereinigen
tmp_ids <- c('20210216-066#', '20210222-015', '20210312-066', '20210416-016', '20210517-004')
dat$U4_keineAuffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '2'

dat$U4_keineAuffaelligkeiten[dat$U4_keineAuffaelligkeiten %in% '99'] <- NA


tmp2$auff_status <-  ifelse(tmp2$U4_keineAuffaelligkeiten==99 & 
                              tmp2$U4_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U4_keineAuffaelligkeiten==99 & tmp2$U4_Auffaelligkeiten!=99) |
                              (tmp2$U4_keineAuffaelligkeiten!=99 & tmp2$U4_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U4_keineAuffaelligkeiten==1 & 
                              tmp2$U4_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt ?brig? 
tmp3 <- filter(tmp2, is.na(auff_status))
tmp_ids <- c('20210325-018', '20210512-030')
dat$U4_Auffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '2'
dat$U4_Auffaelligkeiten[dat$GH_ID == '20210329-005#'] <- '1'




#*****************************************************
table(tmp$U4_Impfstatus_ja, useNA='always')
table(tmp$U4_Impfstatus_nein, useNA='always')
table(tmp$U4_Impfstatus_fehlend, useNA='always')
# hier nochmal kl?ren, was die Auspr?gungen bedeuten
# aus meiner Erinnerung: 
# ja == 1
# nein (= ja nicht angekreuzt) == 2
# 99 == gesamter Bereich nicht angekreuzt

tmp2 <- filter(tmp, U4_Impfstatus_ja==99 | U4_Impfstatus_nein==99 | U4_Impfstatus_fehlend==99)


# Erfassungsfehler bereinigen: '99' falsch verwendet
dat$U4_Impfstatus_ja[dat$GH_ID=='20210312-020'] <- '2'
dat$U4_Impfstatus_nein[dat$GH_ID=='20210312-020'] <- '2'

dat$U4_Impfstatus_nein[dat$GH_ID=='20210317-009j'] <- '2'
dat$U4_Impfstatus_fehlend[dat$GH_ID=='20210317-009j'] <- '2'

dat$U4_Impfstatus_ja[dat$GH_ID=='20210514-002'] <- '1'
dat$U4_Impfstatus_fehlend[dat$GH_ID=='20210514-002'] <- '1'

dat$U4_Impfstatus_ja[dat$GH_ID=='20210517-004'] <- '1'

#*****************************************************************************
#### U5 ####
table(dat$U5_Kopien, useNA='always') 
table(dat$U5_ausgefüllt, useNA='always')

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U5_Kopien==2 & U5_ausgefüllt==2) %>%
  select(GH_ID, contains('U5'))

# U5 Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U5_Kopien==1 & U5_ausgefüllt==1) %>%
  select(GH_ID, contains('U5'))

table(tmp$U5_Elterninfo, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U5_Elterninfo))
dat$U5_Elterninfo[is.na(dat$U5_Elterninfo)] <- '99'

table(tmp$U5_OBE_Sprache, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U5_OBE_Sprache))
dat$U5_OBE_Sprache[is.na(dat$U5_OBE_Sprache)] <- '99'
dat$U5_OBE_Sprache[dat$U5_OBE_Sprache %in% c('0', '92')] <- '99'
table(dat$U5_OBE_Sprache, useNA='always')


# Untersuchung
# 99 und NA werden ?quivalent verwendet, NA durch 99 ersetzen
table(tmp$U5_Untersuchung, useNA='always')

table(tmp$U5_Brueckner, useNA='always')
tmp2 <- filter(tmp, tmp$U5_Brueckner=='0')
dat$U5_Brueckner[dat$U5_Brueckner %in% '0'] <- '2'

# Beratung
table(tmp$U5_Beratung, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U5_Beratung))
dat$U5_Beratung[is.na(dat$U5_Beratung)] <- '99'

table(tmp$U5_Beratung_Sprache, useNA='always')

# Ergebnisse
table(tmp$U5_Anamnese, useNA='always')
#table(tmp$U5_Anamnese_Freitext, useNA='always') 

# ung?ltige Kombinationen pr?fen
tmp2 <- filter(tmp, U5_Anamnese=='1' & is.na(U5_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U5_Anamnese=='2' & !is.na(U5_Anamnese_Freitext)) 
dat$U5_Anamnese[dat$U5_Anamnese=='2' & !is.na(dat$U5_Anamnese_Freitext)] <- '1'


table(tmp$U5_OBE_altersgem, useNA='always')

table(tmp$U5_KGewicht, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U5_KGewicht))
dat$U5_KGewicht[is.na(dat$U5_KGewicht)] <- '2'

tmp2 <- filter(tmp, tmp$U5_KGewicht=='99' | tmp$U5_KLaenge=='99' | tmp$U5_Kopfumfang=='99')

table(tmp$U5_KLaenge, useNA='always')
dat$U5_KLaenge[is.na(dat$U5_KLaenge)] <- '2'

table(tmp$U5_Kopfumfang, useNA='always')
dat$U5_Kopfumfang[is.na(dat$U5_Kopfumfang)] <- '2'

table(tmp$U5_keineAuffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U5_keineAuffaelligkeiten))
dat$U5_keineAuffaelligkeiten[is.na(dat$U5_keineAuffaelligkeiten)] <- '2'

table(tmp$U5_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U5_Auffaelligkeiten))
dat$U5_Auffaelligkeiten[is.na(dat$U5_keineAuffaelligkeiten)] <- '2'


#***************************************
### Pr?fung & Bereinigung von Auff?lligkeiten
tmp2 <- select(tmp, GH_ID, U5_keineAuffaelligkeiten:U5_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U5_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U5_Auffaelligkeiten==1 & is.na(U5_Auffaelligkeiten_Freitext))

# Erfassungsfehler bereinigen
dat$U5_Auffaelligkeiten[dat$GH_ID=='20210901-006'] <- '2'

# gibt es Kombi aus Eintrag liegt nicht vor (U5_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U5_Auffaelligkeiten==2 & !is.na(U5_Auffaelligkeiten_Freitext))

tmp_ids <- tmp3$GH_ID
dat$U5_Auffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '1'


# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U5_Auffaelligkeiten==1 & 
                             is.na(tmp2$U5_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U5_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U5_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U5_keineAuffaelligkeiten==1 & 
                             tmp2$U5_Auffaelligkeiten==2 & 
                             is.na(tmp2$U5_Auffaelligkeiten_Freitext), 
                           'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U5_keineAuffaelligkeiten==2 & 
                              tmp2$U5_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U5_keineAuffaelligkeiten==2 & 
                              tmp2$U5_Auffaelligkeiten==2 &
                              is.na(tmp2$U5_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U5_keineAuffaelligkeiten==99 | tmp2$U5_Auffaelligkeiten==99)

# Erfassungsfehler bereinigen
tmp_ids <- c('20210218-012#', '20210517-004')
dat$U5_keineAuffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '2'

tmp2$auff_status <-  ifelse(tmp2$U5_keineAuffaelligkeiten==99 & 
                              tmp2$U5_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U5_keineAuffaelligkeiten==99 & tmp2$U5_Auffaelligkeiten!=99) |
                              (tmp2$U5_keineAuffaelligkeiten!=99 & tmp2$U5_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U5_keineAuffaelligkeiten==1 & 
                              tmp2$U5_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt ?brig? 
tmp3 <- filter(tmp2, is.na(auff_status))




#*****************************************************
table(tmp$U5_Impfstatus_ja, useNA='always')
table(tmp$U5_Impfstatus_nein, useNA='always')
table(tmp$U5_Impfstatus_fehlend, useNA='always')
# hier nochmal kl?ren, was die Auspr?gungen bedeuten
# aus meiner Erinnerung: 
# ja == 1
# nein (= ja nicht angekreuzt) == 2
# 99 == gesamter Bereich nicht angekreuzt

tmp2 <- filter(tmp, U5_Impfstatus_ja==99 | U5_Impfstatus_nein==99 | U5_Impfstatus_fehlend==99)


# Erfassungsfehler bereinigen: '99' falsch verwendet
dat$U5_Impfstatus_ja[dat$GH_ID=='20210312-020'] <- '2'
dat$U5_Impfstatus_nein[dat$GH_ID=='20210312-020'] <- '2'

dat$U5_Impfstatus_ja[dat$GH_ID=='20210517-004'] <- '1'

dat$U5_Impfstatus_nein[dat$GH_ID=='20210517-008'] <- '1'





#*****************************************************************************
#### U6 ####
table(dat$U6_Kopien, useNA='always') #1.070 mal keine U6 vorliegend
table(dat$U6_ausgefüllt, useNA='always') #1.079 mal nicht ausgefüllt

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U6_Kopien==2 & U6_ausgefüllt==2) %>% select(GH_ID, starts_with('U6'))

# U6 Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U6_Kopien==1 & U6_ausgefüllt==1) %>% select(GH_ID, starts_with('U6'))


table(tmp$U6_Elterninfo, useNA='always')
#table(tmp$U6_Elterninfo_Freitext, useNA='always')

table(tmp$U6_OBE_Sprache, useNA='always')
tmp2 <- filter(tmp, tmp$U6_OBE_Sprache=='0')
dat$U6_OBE_Sprache[dat$U6_OBE_Sprache %in% '0'] <- '2'

# Untersuchung
table(tmp$U6_Untersuchung, useNA='always') # Ausprägung 'ß' = Erfassungsfehler
tmp2 <- filter(tmp, tmp$U6_Untersuchung=='?')
dat$U6_Untersuchung[dat$U6_Untersuchung %in% c('ß')] <- '0'

table(tmp$U6_Zaehne, useNA='always')
table(tmp$U6_Brueckner, useNA='always')


# Beratung
table(tmp$U6_Beratung, useNA='always')
table(tmp$U6_Beratung_Sprache, useNA='always')
table(tmp$U6_Beratung_Zahnarzt, useNA='always')


# Ergebnisse
table(tmp$U6_Anamnese, useNA='always')
dat$U6_Anamnese[dat$U6_Anamnese == 0] <- '99'

#table(tmp$U6_Anamnese_Freitext, useNA='always') 

# ung?ltige Kombinationen pr?fen
tmp2 <- filter(tmp, U6_Anamnese=='1' & is.na(U6_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U6_Anamnese=='2' & !is.na(U6_Anamnese_Freitext)) 
dat$U6_Anamnese[dat$U6_Anamnese=='2' & !is.na(dat$U6_Anamnese_Freitext)] <- '1'

table(tmp$U6_OBE_altersgem, useNA='always')

table(tmp$U6_KGewicht, useNA='always')
table(tmp$U6_KLaenge, useNA='always')
table(tmp$U6_Kopfumfang, useNA='always')

tmp2 <- filter(tmp, tmp$U6_KGewicht=='99' | tmp$U6_KLaenge=='99' | tmp$U6_Kopfumfang=='99')



table(tmp$U6_keineAuffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U6_keineAuffaelligkeiten))
dat$U6_keineAuffaelligkeiten[is.na(dat$U6_keineAuffaelligkeiten)] <- '2'

table(tmp$U6_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U6_Auffaelligkeiten))
dat$U6_Auffaelligkeiten[is.na(dat$U6_keineAuffaelligkeiten)] <- '2'


#***************************************
### Pr?fung & Bereinigung von Auff?lligkeiten
tmp2 <- select(tmp, GH_ID, U6_keineAuffaelligkeiten:U6_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U6_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U6_Auffaelligkeiten==1 & is.na(U6_Auffaelligkeiten_Freitext))

# Erfassungsfehler bereinigen
dat$U6_Auffaelligkeiten_Freitext[dat$GH_ID=='20210203-017j'] <- 'intern(istischer) und neurol(ogischer) Status unauff?llig, [unlesbar] Hoden, [unlesbar] unauff?llig'
dat$U6_Auffaelligkeiten_Freitext[dat$GH_ID=='20210414-006j'] <- '[unlesbar]'

dat$U6_Auffaelligkeiten[dat$GH_ID=='20210309-008e'] <- '2'

dat$U6_keineAuffaelligkeiten[dat$GH_ID=='20210510-084'] <- '1'
dat$U6_Auffaelligkeiten[dat$GH_ID=='20210510-084'] <- '2'
	

# gibt es Kombi aus Eintrag liegt nicht vor (U6_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U6_Auffaelligkeiten==2 & !is.na(U6_Auffaelligkeiten_Freitext))

tmp_ids <- tmp3$GH_ID
dat$U6_Auffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '1'


# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U6_Auffaelligkeiten==1 & 
                             is.na(tmp2$U6_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U6_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U6_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U6_keineAuffaelligkeiten==1 & 
                             tmp2$U6_Auffaelligkeiten==2 & 
                             is.na(tmp2$U6_Auffaelligkeiten_Freitext), 
                           'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U6_keineAuffaelligkeiten==2 & 
                              tmp2$U6_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U6_keineAuffaelligkeiten==2 & 
                              tmp2$U6_Auffaelligkeiten==2 &
                              is.na(tmp2$U6_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U6_keineAuffaelligkeiten==99 | tmp2$U6_Auffaelligkeiten==99)

# Erfassungsfehler bereinigen
tmp_ids <- c('20210226-007#', '20210517-004', '20210517-008')
dat$U6_keineAuffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '2'

tmp2$auff_status <-  ifelse(tmp2$U6_keineAuffaelligkeiten==99 & 
                              tmp2$U6_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U6_keineAuffaelligkeiten==99 & tmp2$U6_Auffaelligkeiten!=99) |
                              (tmp2$U6_keineAuffaelligkeiten!=99 & tmp2$U6_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U6_keineAuffaelligkeiten==1 & 
                              tmp2$U6_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt ?brig? 
tmp3 <- filter(tmp2, is.na(auff_status))

dat$U6_Auffaelligkeiten[dat$GH_ID %in% '20210115-085#'] <- '1'
dat$U6_Auffaelligkeiten_Freitext[dat$GH_ID %in% '20210115-085#'] <- '[unlesbar]'



#****************************

table(tmp$U6_Verweis_Zahnarzt, useNA='always')


table(tmp$U6_Impfstatus_ja, useNA='always')
table(tmp$U6_Impfstatus_nein, useNA='always')
table(tmp$U6_Impfstatus_fehlend, useNA='always')


tmp2 <- filter(tmp, U6_Impfstatus_ja==99 | U6_Impfstatus_nein==99 | U6_Impfstatus_fehlend==99)

# Erfassungsfehler bereinigen: '99' falsch verwendet
dat$U6_Impfstatus_ja[dat$GH_ID=='20210226-007#'] <- '1'
dat$U6_Impfstatus_ja[dat$GH_ID=='20210517-004'] <- '1'
dat$U6_Impfstatus_ja[dat$GH_ID=='20210517-008'] <- '1'

dat$U6_Impfstatus_nein[dat$GH_ID=='20210317-009j'] <- '2'
dat$U6_Impfstatus_fehlend[dat$GH_ID=='20210317-009j'] <- '2'



#*****************************************************************************
#### U7 ####
table(dat$U7_Kopien, useNA='always')
table(dat$U7_ausgefüllt, useNA='always')

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U7_Kopien==2 & U7_ausgefüllt==2) %>%
  select(GH_ID, contains('U7'))

# U7 Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U7_Kopien==1 & U7_ausgefüllt==1) %>%
  select(GH_ID, contains('U7'))

table(tmp$U7_Elterninfo, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7_Elterninfo))
dat$U7_Elterninfo[is.na(dat$U7_Elterninfo)] <- '99'

table(tmp$U7_OBE_Sprache, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7_OBE_Sprache) | tmp$U7_OBE_Sprache=='0')
dat$U7_OBE_Sprache[is.na(dat$U7_OBE_Sprache)] <- '2'
dat$U7_OBE_Sprache[dat$U7_OBE_Sprache=='0'] <- '2'

# Untersuchung
# 99 und NA werden ?quivalent verwendet, NA durch 99 ersetzen
table(tmp$U7_Untersuchung, useNA='always')

table(tmp$U7_Brueckner, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7_Brueckner))

dat$U7_Brueckner[dat$GH_ID %in% tmp2$GH_ID] <- '99'


# Beratung
table(tmp$U7_Beratung, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7_Beratung))
dat$U7_Beratung[is.na(dat$U7_Beratung)] <- '99'

table(tmp$U7_Beratung_Sprache, useNA='always')
tmp2 <- filter(tmp, tmp$U7_Beratung_Sprache=='0')
dat$U7_Beratung_Sprache[dat$U7_Beratung_Sprache %in% '0'] <- '99'


# Ergebnisse
table(tmp$U7_Anamnese, useNA='always')
tmp2 <- filter(tmp, tmp$U7_Anamnese=='0')
dat$U7_Anamnese[dat$U7_Anamnese %in% '0'] <- '2'

#table(tmp$U7_Anamnese_Freitext, useNA='always') 

# ung?ltige Kombinationen pr?fen
tmp2 <- filter(tmp, U7_Anamnese=='1' & is.na(U7_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U7_Anamnese=='2' & !is.na(U7_Anamnese_Freitext)) 
dat$U7_Anamnese[dat$U7_Anamnese=='2' & !is.na(dat$U7_Anamnese_Freitext)] <- '1'

table(tmp$U7_OBE_altersgem, useNA='always')

table(tmp$U7_KGewicht, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7_KGewicht))
dat$U7_KGewicht[is.na(dat$U7_KGewicht)] <- '2'

tmp2 <- filter(tmp, tmp$U7_KGewicht=='99' | tmp$U7_KLaenge=='99' | 
                 tmp$U7_Kopfumfang=='99' | tmp$U7_BMI=='99')

table(tmp$U7_KLaenge, useNA='always')
dat$U7_KLaenge[is.na(dat$U7_KLaenge)] <- '2'

table(tmp$U7_Kopfumfang, useNA='always')
dat$U7_Kopfumfang[is.na(dat$U7_Kopfumfang)] <- '2'

table(tmp$U7_BMI, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7_BMI))
dat$U7_BMI[is.na(dat$U7_BMI)] <- '2'
dat$U7_BMI[dat$U7_BMI == '9'] <- '99'


table(tmp$U7_keineAuffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7_keineAuffaelligkeiten))
dat$U7_keineAuffaelligkeiten[is.na(dat$U7_keineAuffaelligkeiten)] <- '2'

table(tmp$U7_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7_Auffaelligkeiten))
dat$U7_Auffaelligkeiten[is.na(dat$U7_Auffaelligkeiten)] <- '1'


#***************************************
### Pr?fung & Bereinigung von Auff?lligkeiten
tmp2 <- select(tmp, GH_ID, U7_keineAuffaelligkeiten:U7_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U7_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U7_Auffaelligkeiten==1 & is.na(U7_Auffaelligkeiten_Freitext))

# gibt es Kombi aus Eintrag liegt nicht vor (U7_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U7_Auffaelligkeiten==2 & !is.na(U7_Auffaelligkeiten_Freitext))


# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U7_Auffaelligkeiten==1 & 
                             is.na(tmp2$U7_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U7_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U7_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U7_keineAuffaelligkeiten==1 & 
                             tmp2$U7_Auffaelligkeiten==2 & 
                             is.na(tmp2$U7_Auffaelligkeiten_Freitext), 
                           'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U7_keineAuffaelligkeiten==2 & 
                              tmp2$U7_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U7_keineAuffaelligkeiten==2 & 
                              tmp2$U7_Auffaelligkeiten==2 &
                              is.na(tmp2$U7_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U7_keineAuffaelligkeiten==99 | tmp2$U7_Auffaelligkeiten==99)

# Erfassungsfehler bereinigen
tmp_ids <- c('20210517-004')
dat$U7_keineAuffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '2'

tmp2$auff_status <-  ifelse(tmp2$U7_keineAuffaelligkeiten==99 & 
                              tmp2$U7_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U7_keineAuffaelligkeiten==99 & tmp2$U7_Auffaelligkeiten!=99) |
                              (tmp2$U7_keineAuffaelligkeiten!=99 & tmp2$U7_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U7_keineAuffaelligkeiten==1 & 
                              tmp2$U7_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt ?brig? 
tmp3 <- filter(tmp2, is.na(auff_status))

tmp_ids <- c('20210317-006j#')
dat$U7_keineAuffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '1'



#*****************************************************
table(tmp$U7_Impfstatus_ja, useNA='always')
table(tmp$U7_Impfstatus_nein, useNA='always')
table(tmp$U7_Impfstatus_fehlend, useNA='always')
# hier nochmal kl?ren, was die Auspr?gungen bedeuten
# aus meiner Erinnerung: 
# ja == 1
# nein (= ja nicht angekreuzt) == 2
# 99 == gesamter Bereich nicht angekreuzt

tmp2 <- filter(tmp, U7_Impfstatus_ja==99 | U7_Impfstatus_nein==99 | U7_Impfstatus_fehlend==99)


# Erfassungsfehler bereinigen: '99' falsch verwendet
dat$U7_Impfstatus_ja[dat$GH_ID=='20210312-035'] <- '2'
dat$U7_Impfstatus_nein[dat$GH_ID=='20210312-035'] <- '2'

dat$U7_Impfstatus_ja[dat$GH_ID=='20210517-004'] <- '1'




#*****************************************************************************
#### U7a ####
table(dat$U7a_Kopien, useNA='always')
table(dat$U7a_ausgefüllt, useNA='always')

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U7a_Kopien==2 & U7a_ausgefüllt==2) %>%
  select(GH_ID, contains('U7a'))

# U7a Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U7a_Kopien==1 & U7a_ausgefüllt==1) %>%
  select(GH_ID, contains('U7a'))

table(tmp$U7a_Elterninfo, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7a_Elterninfo))
dat$U7a_Elterninfo[is.na(dat$U7a_Elterninfo)] <- '99'

table(tmp$U7a_OBE_Sprache, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7a_OBE_Sprache) | tmp$U7a_OBE_Sprache=='0')
dat$U7a_OBE_Sprache[is.na(dat$U7a_OBE_Sprache)] <- '2'
dat$U7a_OBE_Sprache[dat$U7a_OBE_Sprache=='0'] <- '2'

# Untersuchung
# 99 und NA werden ?quivalent verwendet, NA durch 99 ersetzen
table(tmp$U7a_Untersuchung, useNA='always')


table(tmp$U7a_morphologische_Auffaelligkeiten, useNA='always')
table(tmp$U7a_Nystagmus, useNA='always')

table(tmp$U7a_Kopffehlhaltung, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7a_Kopffehlhaltung))
dat$U7a_Kopffehlhaltung[dat$GH_ID %in% tmp2$GH_ID] <- '2'

table(tmp$U7a_Pupillenstatus, useNA='always')
table(tmp$U7a_Hornhaut, useNA='always')
table(tmp$U7a_Stereo, useNA='always')
table(tmp$U7a_Sehschwaeche_rechts, useNA='always')
table(tmp$U7a_Sehschwaeche_links, useNA='always')
table(tmp$U7a_Sehschwaeche_Differenz, useNA='always')


### Beratung
table(tmp$U7a_Beratung, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7a_Beratung))
dat$U7a_Beratung[is.na(dat$U7a_Beratung)] <- '99'

table(tmp$U7a_Beratung_Sprache, useNA='always')
tmp2 <- filter(tmp, tmp$U7a_Beratung_Sprache=='0')
dat$U7a_Beratung_Sprache[dat$U7a_Beratung_Sprache %in% '0'] <- '99'


# Ergebnisse
table(tmp$U7a_Anamnese, useNA='always')
tmp2 <- filter(tmp, tmp$U7a_Anamnese=='0')
dat$U7a_Anamnese[dat$U7a_Anamnese %in% '0'] <- '2'
#table(tmp$U7a_Anamnese_Freitext, useNA='always') 

# ung?ltige Kombinationen pr?fen
tmp2 <- filter(tmp, U7a_Anamnese=='1' & is.na(U7a_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U7a_Anamnese=='2' & !is.na(U7a_Anamnese_Freitext)) 

table(tmp$U7a_OBE_altersgem, useNA='always')

table(tmp$U7a_KGewicht, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7a_KGewicht))
dat$U7a_KGewicht[is.na(dat$U7a_KGewicht)] <- '2'

tmp2 <- filter(tmp, tmp$U7a_KGewicht=='99' | tmp$U7a_KLaenge=='99' | tmp$U7a_BMI=='99')

table(tmp$U7a_KLaenge, useNA='always')
dat$U7a_KLaenge[is.na(dat$U7a_KLaenge)] <- '2'

table(tmp$U7a_BMI, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7a_BMI))
dat$U7a_BMI[is.na(dat$U7a_BMI)] <- '2'

tmp_ids <- c('20210312-043', '20210512-011')
dat$U7a_BMI[dat$GH_ID %in% tmp_ids] <- '2'


table(tmp$U7a_keineAuffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7a_keineAuffaelligkeiten))
dat$U7a_keineAuffaelligkeiten[is.na(dat$U7a_keineAuffaelligkeiten)] <- '2'

table(tmp$U7a_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U7a_Auffaelligkeiten))
dat$U7a_Auffaelligkeiten[is.na(dat$U7a_Auffaelligkeiten)] <- '1'


#***************************************
### Pr?fung & Bereinigung von Auff?lligkeiten
tmp2 <- select(tmp, GH_ID, U7a_keineAuffaelligkeiten:U7a_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U7a_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U7a_Auffaelligkeiten==1 & is.na(U7a_Auffaelligkeiten_Freitext))

# gibt es Kombi aus Eintrag liegt nicht vor (U7a_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U7a_Auffaelligkeiten==2 & !is.na(U7a_Auffaelligkeiten_Freitext))
dat$U7a_Auffaelligkeiten[dat$GH_ID == '20210211-002e'] <- '1'


# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U7a_Auffaelligkeiten==1 & 
                             is.na(tmp2$U7a_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U7a_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U7a_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U7a_keineAuffaelligkeiten==1 & 
                             tmp2$U7a_Auffaelligkeiten==2 & 
                             is.na(tmp2$U7a_Auffaelligkeiten_Freitext), 
                           'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U7a_keineAuffaelligkeiten==2 & 
                              tmp2$U7a_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U7a_keineAuffaelligkeiten==2 & 
                              tmp2$U7a_Auffaelligkeiten==2 &
                              is.na(tmp2$U7a_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U7a_keineAuffaelligkeiten==99 | tmp2$U7a_Auffaelligkeiten==99)

# Erfassungsfehler bereinigen
# keine

tmp2$auff_status <-  ifelse(tmp2$U7a_keineAuffaelligkeiten==99 & 
                              tmp2$U7a_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U7a_keineAuffaelligkeiten==99 & tmp2$U7a_Auffaelligkeiten!=99) |
                              (tmp2$U7a_keineAuffaelligkeiten!=99 & tmp2$U7a_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U7a_keineAuffaelligkeiten==1 & 
                              tmp2$U7a_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt ?brig? 
tmp3 <- filter(tmp2, is.na(auff_status))
# nichts



#*****************************************************
table(tmp$U7a_Impfstatus_ja, useNA='always')
table(tmp$U7a_Impfstatus_nein, useNA='always')
table(tmp$U7a_Impfstatus_fehlend, useNA='always')
# hier nochmal kl?ren, was die Auspr?gungen bedeuten
# aus meiner Erinnerung: 
# ja == 1
# nein (= ja nicht angekreuzt) == 2
# 99 == gesamter Bereich nicht angekreuzt

tmp2 <- filter(tmp, U7a_Impfstatus_ja==99 | U7a_Impfstatus_nein==99 | U7a_Impfstatus_fehlend==99)


# Erfassungsfehler bereinigen: '99' falsch verwendet
dat$U7a_Impfstatus_ja[dat$GH_ID=='20210312-035'] <- '2'
dat$U7a_Impfstatus_nein[dat$GH_ID=='20210312-035'] <- '2'

dat$U7a_Impfstatus_ja[dat$GH_ID=='20210517-004'] <- '1'

dat$U7a_Impfstatus_fehlend[dat$GH_ID=='20210325-064'] <- '2'



#*****************************************************************************
#### U8 ####
table(dat$U8_Kopien, useNA='always') #1.679 mal keine U8 vorliegend
table(dat$U8_ausgefüllt, useNA='always') #1.682 mal nicht ausgefüllt

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U8_Kopien==2 & U8_ausgefüllt==2) %>% select(GH_ID, starts_with('U8'))

# U8 Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U8_Kopien==1 & U8_ausgefüllt==1) %>% select(GH_ID, starts_with('U8'))


table(tmp$U8_Elterninfo, useNA='always')
#table(tmp$U8_Elterninfo_Freitext, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U8_Elterninfo))
dat$U8_Elterninfo[is.na(dat$U8_Elterninfo)] <- '99'
dat$U8_Elterninfo[dat$U8_Elterninfo == 0] <- '99'

table(tmp$U8_OBE_Sprache, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U8_OBE_Sprache) | tmp$U8_OBE_Sprache=='0')
dat$U8_OBE_Sprache[is.na(dat$U8_OBE_Sprache)] <- '99'
dat$U8_OBE_Sprache[dat$U8_OBE_Sprache %in% '0'] <- '2'

# Untersuchung
table(tmp$U8_Untersuchung, useNA='always')

table(tmp$U8_morphologische_Auffaelligkeiten, useNA='always')
tmp2 <- filter(tmp, tmp$U8_morphologische_Auffaelligkeiten=='0')
dat$U8_morphologische_Auffaelligkeiten[dat$U8_morphologische_Auffaelligkeiten %in% '0'] <- '2'

table(tmp$U8_Nystagmus, useNA='always')
tmp2 <- filter(tmp, tmp$U8_Nystagmus=='0')
dat$U8_Nystagmus[dat$U8_Nystagmus %in% '0'] <- '2'

table(tmp$U8_Kopffehlhaltung, useNA='always')
tmp2 <- filter(tmp, tmp$U8_Kopffehlhaltung=='0')
dat$U8_Kopffehlhaltung[dat$U8_Kopffehlhaltung %in% '0'] <- '2'

table(tmp$U8_Pupillenstatus, useNA='always')
tmp2 <- filter(tmp, tmp$U8_Pupillenstatus=='0')
dat$U8_Pupillenstatus[dat$U8_Pupillenstatus %in% '0'] <- '2'

table(tmp$U8_Hornhaut, useNA='always')
tmp2 <- filter(tmp, tmp$U8_Hornhaut=='0')
dat$U8_Hornhaut[dat$U8_Hornhaut %in% '0'] <- '2'

table(tmp$U8_Stereo, useNA='always')
tmp2 <- filter(tmp, tmp$U8_Stereo=='0' | is.na(tmp$U8_Stereo))
dat$U8_Stereo[dat$U8_Stereo %in% '0' | is.na(dat$U8_Stereo) ] <- '2'

table(tmp$U8_Sehschwaeche_rechts, useNA='always')
tmp2 <- filter(tmp, tmp$U8_Sehschwaeche_rechts=='0')
dat$U8_Sehschwaeche_rechts[dat$U8_Sehschwaeche_rechts %in% '0'] <- '2'

table(tmp$U8_Sehschwaeche_links, useNA='always')
tmp2 <- filter(tmp, tmp$U8_Sehschwaeche_links=='0')
dat$U8_Sehschwaeche_links[dat$U8_Sehschwaeche_links %in% '0'] <- '2'

table(tmp$U8_Sehschwaeche_Differenz, useNA='always')
tmp2 <- filter(tmp, tmp$U8_Sehschwaeche_Differenz=='0')
dat$U8_Sehschwaeche_Differenz[dat$U8_Sehschwaeche_Differenz %in% '0'] <- '2'

# Beratung
table(tmp$U8_Beratung, useNA='always')
table(tmp$U8_Beratung_Sprache, useNA='always')

# Ergebnisse
table(tmp$U8_Anamnese, useNA='always')
#table(tmp$U8_Anamnese_Freitext, useNA='always') 

# ung?ltige Kombinationen pr?fen
tmp2 <- filter(tmp, U8_Anamnese=='1' & is.na(U8_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U8_Anamnese=='2' & !is.na(U8_Anamnese_Freitext)) 
dat$U8_Anamnese[dat$U8_Anamnese=='2' & !is.na(dat$U8_Anamnese_Freitext)] <- '1'

table(tmp$U8_OBE_altersgem, useNA='always')

table(tmp$U8_KGewicht, useNA='always')
table(tmp$U8_KLaenge, useNA='always')
table(tmp$U8_BMI, useNA='always')

tmp2 <- filter(tmp, tmp$U8_KGewicht=='99' | tmp$U8_KLaenge=='99' | tmp$U8_BMI=='99')


table(tmp$U8_keineAuffaelligkeiten, useNA='always')
#tmp2 <- filter(tmp, is.na(tmp$U8_keineAuffaelligkeiten))
#dat[is.na(dat$U8_keineAuffaelligkeiten), 'U8_keineAuffaelligkeiten'] <- '2'

table(tmp$U8_Auffaelligkeiten, useNA='always')
#tmp2 <- filter(tmp, is.na(tmp$U8_Auffaelligkeiten))
#dat[is.na(dat$U8_Auffaelligkeiten), 'U8_Auffaelligkeiten'] <- '1'


#***************************************
### Pr?fung & Bereinigung von Auff?lligkeiten
tmp2 <- select(tmp, GH_ID, U8_keineAuffaelligkeiten:U8_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U8_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U8_Auffaelligkeiten==1 & is.na(U8_Auffaelligkeiten_Freitext))
dat$U8_Auffaelligkeiten_Freitext[dat$GH_ID == '20210115-013#'] <- 's.o'

# gibt es Kombi aus Eintrag liegt nicht vor (U8_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U8_Auffaelligkeiten==2 & !is.na(U8_Auffaelligkeiten_Freitext))


# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U8_Auffaelligkeiten==1 & 
                             is.na(tmp2$U8_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U8_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U8_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U8_keineAuffaelligkeiten==1 & 
                             tmp2$U8_Auffaelligkeiten==2 & 
                             is.na(tmp2$U8_Auffaelligkeiten_Freitext), 
                           'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U8_keineAuffaelligkeiten==2 & 
                              tmp2$U8_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U8_keineAuffaelligkeiten==2 & 
                              tmp2$U8_Auffaelligkeiten==2 &
                              is.na(tmp2$U8_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U8_keineAuffaelligkeiten==99 | tmp2$U8_Auffaelligkeiten==99)


# Erfassungsfehler bereinigen
tmp_ids <- c('20210218-025', '20210504-007#')
dat$U8_keineAuffaelligkeiten[dat$GH_ID %in% tmp_ids] <- '2'


tmp2$auff_status <-  ifelse(tmp2$U8_keineAuffaelligkeiten==99 & 
                              tmp2$U8_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U8_keineAuffaelligkeiten==99 & tmp2$U8_Auffaelligkeiten!=99) |
                              (tmp2$U8_keineAuffaelligkeiten!=99 & tmp2$U8_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U8_keineAuffaelligkeiten==1 & 
                              tmp2$U8_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt ?brig? 
tmp3 <- filter(tmp2, is.na(auff_status))
# nichts


#********************************
table(tmp$U8_Impfstatus_ja, useNA='always')
table(tmp$U8_Impfstatus_nein, useNA='always')
table(tmp$U8_Impfstatus_fehlend, useNA='always')

tmp2 <- filter(tmp, U8_Impfstatus_ja==99 | U8_Impfstatus_nein==99 | U8_Impfstatus_fehlend==99)


#*****************************************************************************
#### U9 ####
table(dat$U9_Kopien, useNA='always') #1.679 mal keine U9 vorliegend
table(dat$U9_ausgefüllt, useNA='always') #1.682 mal nicht ausgefüllt

# pr?fen, ob trotz == Nein ausgefüllt
tmp <- dat %>% filter(U9_Kopien==2 & U9_ausgefüllt==2) %>% select(GH_ID, starts_with('U9'))

# U9 Ergebnisse nur dann ausgeben, wenn Kopien vorliegen == ja & ausgefüllt == ja
tmp <- dat %>% filter(U9_Kopien==1 & U9_ausgefüllt==1) %>% select(GH_ID, starts_with('U9'))


table(tmp$U9_Elterninfo, useNA='always')
#table(tmp$U9_Elterninfo_Freitext, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U9_Elterninfo))

table(tmp$U9_OBE_Sprache, useNA='always')
tmp2 <- filter(tmp, is.na(tmp$U9_OBE_Sprache))
dat$U9_OBE_Sprache[is.na(dat$U9_OBE_Sprache)] <- '2'

# Untersuchung
table(tmp$U9_Untersuchung, useNA='always')

table(tmp$U9_morphologische_Auffaelligkeiten, useNA='always')

table(tmp$U9_Nystagmus, useNA='always')

table(tmp$U9_Kopffehlhaltung, useNA='always')
tmp2 <- filter(tmp, is.na(U9_Kopffehlhaltung))
dat$U9_Kopffehlhaltung[is.na(dat$U9_Kopffehlhaltung)] <- '2'

table(tmp$U9_Pupillenstatus, useNA='always')
table(tmp$U9_Hornhaut, useNA='always')
table(tmp$U9_Stereo, useNA='always')
table(tmp$U9_Sehschwaeche_rechts, useNA='always')
table(tmp$U9_Sehschwaeche_links, useNA='always')
table(tmp$U9_Sehschwaeche_Differenz, useNA='always')


# Beratung
table(tmp$U9_Beratung, useNA='always')
table(tmp$U9_Beratung_Sprache, useNA='always')

# Ergebnisse
table(tmp$U9_Anamnese, useNA='always')
#table(tmp$U9_Anamnese_Freitext, useNA='always') 

# ung?ltige Kombinationen pr?fen
tmp2 <- filter(tmp, U9_Anamnese=='1' & is.na(U9_Anamnese_Freitext)) #ggf. nacherfassen
tmp2 <- filter(tmp, U9_Anamnese=='2' & !is.na(U9_Anamnese_Freitext)) 

table(tmp$U9_OBE_altersgem, useNA='always')

table(tmp$U9_KGewicht, useNA='always')
table(tmp$U9_KLaenge, useNA='always')
table(tmp$U9_BMI, useNA='always')

tmp2 <- filter(tmp, tmp$U9_KGewicht=='99' | tmp$U9_KLaenge=='99' | tmp$U9_BMI=='99')

table(tmp$U9_keineAuffaelligkeiten, useNA='always')
table(tmp$U9_Auffaelligkeiten, useNA='always')


#***************************************
### Pr?fung & Bereinigung von Auff?lligkeiten
tmp2 <- select(tmp, GH_ID, U9_keineAuffaelligkeiten:U9_Auffaelligkeiten_Freitext)

# gibt es Kombi aus Eintrag liegt vor (U9_Auffaelligkeiten==1) & Text fehlt (NA) -> darf es nicht geben
tmp3 <- filter(tmp2, U9_Auffaelligkeiten==1 & is.na(U9_Auffaelligkeiten_Freitext))

# gibt es Kombi aus Eintrag liegt nicht vor (U9_Auffaelligkeiten==2) & Text fehlt nicht bzw. Text vorhanden
# --> darf es auch nicht geben, da Felder so definiert
tmp3 <- filter(tmp2, U9_Auffaelligkeiten==2 & !is.na(U9_Auffaelligkeiten_Freitext))


# alle Varianten kodieren
tmp2$auff_status <- ifelse(tmp2$U9_Auffaelligkeiten==1 & 
                             is.na(tmp2$U9_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=ja, aber kein Text', NA)

tmp2$auff_status <- ifelse(tmp2$U9_Auffaelligkeiten==2 & 
                             !is.na(tmp2$U9_Auffaelligkeiten_Freitext), 
                           'Erfassungsfehler: A_vorhanden=nein, aber Text erfasst', tmp2$auff_status)

tmp2$auff_status <- ifelse(tmp2$U9_keineAuffaelligkeiten==1 & 
                             tmp2$U9_Auffaelligkeiten==2 & 
                             is.na(tmp2$U9_Auffaelligkeiten_Freitext), 
                           'plausibel: keine Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U9_keineAuffaelligkeiten==2 & 
                              tmp2$U9_Auffaelligkeiten==1, 
                            'plausibel: Auff?lligkeiten', tmp2$auff_status)

tmp2$auff_status <-  ifelse(tmp2$U9_keineAuffaelligkeiten==2 & 
                              tmp2$U9_Auffaelligkeiten==2 &
                              is.na(tmp2$U9_Auffaelligkeiten_Freitext), 
                            'keine Dokumentation', tmp2$auff_status)


# bei 99 m?sste die Seite fehlen, bei drei Eintr?gen ist jedoch nur eine Variable mit 99 kodiert
# Pr?fung einzelner Hefte
tmp3 <- filter(tmp2, tmp2$U9_keineAuffaelligkeiten==99 | tmp2$U9_Auffaelligkeiten==99)


# Erfassungsfehler bereinigen
# keine


tmp2$auff_status <-  ifelse(tmp2$U9_keineAuffaelligkeiten==99 & 
                              tmp2$U9_Auffaelligkeiten==99, 
                            'plausibel: Seite fehlt', tmp2$auff_status)

tmp2$auff_status <-  ifelse((tmp2$U9_keineAuffaelligkeiten==99 & tmp2$U9_Auffaelligkeiten!=99) |
                              (tmp2$U9_keineAuffaelligkeiten!=99 & tmp2$U9_Auffaelligkeiten==99) , 
                            'Erfassungsfehler: 99 falsch kodiert', tmp2$auff_status)


tmp2$auff_status <-  ifelse(tmp2$U9_keineAuffaelligkeiten==1 & 
                              tmp2$U9_Auffaelligkeiten==1, 
                            'Dokumentationsfehler: keineA=ja, aber A angegeben', tmp2$auff_status)

table(tmp2$auff_status, useNA='always')


# Dokumentationsfehler
tmp3 <- filter(tmp2, auff_status=='Dokumentationsfehler: keineA=ja, aber A angegeben')


# was bleibt ?brig? 
tmp3 <- filter(tmp2, is.na(auff_status))
# nichts


#********************************
table(tmp$U9_Impfstatus_ja, useNA='always')
table(tmp$U9_Impfstatus_nein, useNA='always')
table(tmp$U9_Impfstatus_fehlend, useNA='always')

tmp2 <- filter(tmp, U9_Impfstatus_ja==99 | U9_Impfstatus_nein==99 | U9_Impfstatus_fehlend==99)
#alles gut



#*****************************************************************************
#### abspeichern ####
save(dat, file='gh_clean.rda')

OUT <- createWorkbook()
addWorksheet(OUT, 'GelbeHefte_bereinigt')
writeData(OUT, 'GelbeHefte_bereinigt', dat)
saveWorkbook(OUT, file = "GelbeHefte_bereinigt.xlsx", overwrite = TRUE)






