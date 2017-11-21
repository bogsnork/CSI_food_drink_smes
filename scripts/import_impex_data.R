#trying to work out how to import different files from uktradeinfo.com

library(readr)
#read data

#non-EU export data
SMKE191601 <- read_delim("data/uktradeinfo/SMKE191601", "|", skip = 1, col_names = FALSE)

names(SMKE191601) <- c("COMCODE", "SITC", "RECORD-TYPE", "COD.SEQUENCE", 
                       "COD.ALPHA", "ACCOUNT.MONTH.YEAR", "PORT.SEQUENCE")

#exporter details ----
exporters <- read_delim("data/uktradeinfo/exporters1601.txt", "\t", col_names = FALSE)
  #note comcodes are currently in columns 10 to 59, with each line having up to 50 comcodes

  #gather into tidy format 
  #i.e. create a row for each unique combination of year.month, name, postcode and comcode
exporters.t <- gather(exporters, key = "column",  value = "comcode", 10:59, na.rm = TRUE)

  #rename columns
names(exporters) <- c("year.month", "month", "name", "address1", "address2", 
                      "address3", "address4", "address5", "postcode", "column", "comcode")


#control data
control <- read_delim("data/uktradeinfo/SMKA121601", 
                         "|", col_names = FALSE, skip = 1)
View(SMKA121601)


