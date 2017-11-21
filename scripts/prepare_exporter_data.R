#Prepare exporter data from https://www.uktradeinfo.com/Statistics/Pages/Data-Downloads-Archive.aspx 
#download the files "Exporters" under Traders.  
#2017 data available here: https://www.uktradeinfo.com/Statistics/Pages/DataDownloads.aspx

#load required packages ----
library(readr) #makes importing data easier
library(tidyverse) #loads a suite of useful data manipulation packages

#chances are you'll need to install these packages.  Uncomment (i.e. delete #) and run this: 
#install.packages("tidyverse") #it also installs readr automatically. Ask me if you have trouble. 

#I saved my files in subfolders data and then uktradeinfo, i.e. "data/uktradeinfo/"
#the files are called exporters1601.txt - the last digit is the month, so there are 12 of them. 
#I checked earlier and noticed that the files are tab delimited and have no column names

#Import the data ----

#to import a single file use this: 
exporters1601 <- read_tsv(file = "data/uktradeinfo/exporters1601.txt", col_names = FALSE)


#to import them all at once, use this: 

#code pinched from here: 
#http://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R 

files <- dir(pattern = "exporters*.*", path = "data/uktradeinfo/", full.names = TRUE) #find all files containing 'exporters' and save into an object
files

  
exporters.raw <- files %>% # read in all the files individually, using
  map(read_tsv, col_names = FALSE, trim_ws = TRUE, quote = "") %>%  # the function map from the purrr                                                                           #package, and read_tsv() from readr 
  reduce(rbind) # reduce with rbind into one dataframe 

View(exporters.raw) # have a look

  #if you're confused about the %>% symbol, look here: http://magrittr.tidyverse.org/.  
  #It's called a 'pipe' and it means roughly: "and then..."


#note comcodes are currently in columns 10 to 59, with each line having up to 50 comcodes


# Clean the data ----

#gather into 'tidy' format -> one row per observation, one column per variable
#i.e. create a row for each unique combination of year.month, name, postcode and comcode
exporters <- gather(exporters.raw, # gather function from tidyr, does the above
                    key = "column",  #this is the column that will hold the column names
                    value = "comcode", #this will hold the column values 
                    10:59,            #index of the columns we want to 'gather'
                    na.rm = TRUE)     #don't gather empty cells

#rename columns (see https://www.uktradeinfo.com/Statistics/Documents/Tech_Spec_SIAa11.doc)
names(exporters) <- c("year.month", "month", "name", "address1", "address2", 
                      "address3", "address4", "address5", "postcode", "column", "comcode")


#get rid of the exporters.raw object because its very big
rm(exporters.raw)
rm(files) #also don't need this
rm(exporters1601, rich)

#I don't think we need all of the address fields, or the 'column' field
exporters <- exporters[,-c(4:8, 10)] #the numbers reference the columns

#Export data ----

#save as csv file
write_csv(exporters, "data/exporters2016.csv")


