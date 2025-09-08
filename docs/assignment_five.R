#load packages
library(tidyverse)

#read in data
simpson_receipts <- read_delim("data/original/simpson_fec_17_26.csv",
                               delim = ",")

fulcher_receipts <- read_delim("data/original/fulcher_fec_17_26.csv",
                               delim = ",")

