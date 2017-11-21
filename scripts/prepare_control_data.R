#Prepare control data from https://www.uktradeinfo.com/Statistics/Pages/Data-Downloads-Archive.aspx 
#download the files "SMKA12****" under Traders.  

#load required packages ----
library(readr) #makes importing data easier
library(tidyverse) #loads a suite of useful data manipulation packages


#import the data ----
files <- dir(pattern = "SMKA", path = "data/uktradeinfo/", full.names = TRUE) #find all files containing 'exporters' and save into an object
files

control.raw <- files %>% # read in all the files individually, using
  map(read_delim, col_names = FALSE, skip = 1, delim = "|", trim_ws = TRUE, quote = "") %>% 
  head(-1) %>% #remove last row
  reduce(rbind) # reduce with rbind into one dataframe 

summary(control.raw) # have a closer look

length(unique(as.numeric(control.raw$X1)))

nrow(unique(control.raw))
#ok, so most of these are repeats.  So we save just the unique rows. 

control <- unique(control.raw)


names(control) <- c("COMCODE", "INTRA_EXTRA_IND", "INTRA_MMYY_ON", "INTRA_MMYY_OFF",
                    "EXTRA_MMYY_ON", "EXTRA_MMYY_OFF", "NON_TRADE_ID", "SITC_NO",
                    "SITC_IND", "SITC_CONV_A", "SITC_CONV_B", "CN_Q2", "SUPP_ARRIVALS",
                    "SUPP_DESPATCHES", "SUPP_IMPORTS", "SUPP_EXPORTS", "SUB_GROUP_ARR",
                    "ITEM_ARR", "ITEM_DESP", "SUB_GROUP_IMP", "ITEM_IMP", "SUB_GROUP_DESP",
                    "SUB_GROUP_EXP", "ITEM_EXP", "QTY1_ALPHA", "QTY2_ALPHA", "COMMODITY_ALPHA_1")

summary(control) #

apply(control, 2, function(x)length(unique(x)))


#tidy up
rm(control.raw, files)

#export data ---
write_csv(control, "data/control2016data.csv")

