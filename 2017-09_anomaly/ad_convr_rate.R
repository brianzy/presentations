library('tidyverse')
cr_hour <- read_csv('crh.csv')
cr_hour <- cr_hour %>% 
  mutate(ds = as.POSIXct(timestamp), cr_scaled = cr*100000) %>%
  filter(month == 8) %>% 
  select(ds,cr_scaled)

cr_day <- read_csv('cr.csv')
cr_day <- cr_day %>% 
  mutate(d = as.POSIXct(d), cr = gsub('\t','',cr)) %>%
  mutate(cr_scaled = as.numeric(cr)*100000) %>% 
  select(d,cr_scaled)

library(AnomalyDetection)
res = AnomalyDetectionTs(cr_hour, max_anoms=0.02, direction='both', plot=TRUE, e_value = TRUE,
                         xlabel = 'day', ylabel='Conversion Rate')
res$anoms
res$plot