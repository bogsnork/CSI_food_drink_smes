#Scoping and data exploration

#packages
library(readxl)
library(tidyverse)
library(ggridges)

#Import data
BRES_n_employees <- read_excel("data/business_register_employment_survey_oa.xlsx", 
                               sheet = "2015; Employees; Count", 
                               skip = 7)


#tidy data

BRES_n_employees <- select(BRES_n_employees, seq(1, 125, by = 2)) #remove even numbered cols 
BRES_n_employees <- BRES_n_employees[-c(1, 13), ] #remove non-data row and summary row

BRES_n_employees_g <- BRES_n_employees %>% 
  gather(key = "type", value = "count", -region) %>% #gather to 'tidy' format
  mutate(count = as.numeric(count))


#ridgeplto by region
ggplot(BRES_n_employees_g, aes(x = count, y = region)) +
  geom_density_ridges() +
  theme(legend.position = "none")

#ridgeplot by industry
BRES_n_employees_g %>% 
  group_by(type_broad = substr(type, 1, 2)) %>% 
  ggplot(aes(x = count, y = type_broad)) +
  geom_density_ridges() 
  

#ridgeplot by region for selected industries



ggplot(aes(x = count, y = region)) +
  geom_density_ridges() +
  theme(legend.position = "none")

