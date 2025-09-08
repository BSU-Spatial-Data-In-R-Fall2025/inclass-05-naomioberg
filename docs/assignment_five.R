#load packages
library(tidyverse)

#read in data
simpson_receipts <- read_delim("data/original/simpson_fec_17_26.csv",
                               delim = ",")

fulcher_receipts <- read_delim("data/original/fulcher_fec_17_26.csv",
                               delim = ",")

crapo_receipts <- read_delim("data/original/crapo_fec_17_26.csv",
                             delim = ",")

risch_receipts <- read_delim("data/original/risch_fec_17_26.csv",
                             delim = ",")

#troubleshooting problems with risch dataset
problems(risch_receipts)
#there is a problem with the 17th column
#what is row 17? - recipient)_committee_org_type
names(risch_receipts)[17]

