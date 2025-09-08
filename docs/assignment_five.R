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

# Selecting the variables of interest
select_vars <- c("is_individual", "contributor_name", "contribution_receipt_amount",
                 "committee_name", "report_year")

simpson_subset <- simpson_receipts %>% 
  select(all_of(select_vars)) %>% 
  filter(is_individual == TRUE)

fulcher_subset <- fulcher_receipts %>% 
  select(all_of(select_vars)) %>% 
  filter(is_individual == TRUE)

crapo_subset <- crapo_receipts %>% 
  select(all_of(select_vars)) %>% 
  filter(is_individual == TRUE)

risch_subset <- risch_receipts %>% 
  select(all_of(select_vars)) %>% 
  filter(is_individual == TRUE)

glimpse(simpson_subset)

# grouping by contributor and looking for the top 5 donors
simpson_top5 <- simpson_subset %>% 
  group_by(contributor_name) %>% 
  summarise(total_given = sum(contribution_receipt_amount, 
                              na.rm = TRUE)) %>% 
  slice_max(order_by = total_given, n = 5) %>% 
  mutate(recipient = "Simpson")

fulcher_top5 <- fulcher_subset %>% 
  group_by(contributor_name) %>% 
  summarise(total_given = sum(contribution_receipt_amount, 
                              na.rm = TRUE)) %>% 
  slice_max(order_by = total_given, n = 5) %>% 
  mutate(recipient = "Fulcher")

crapo_top5 <- crapo_subset %>% 
  group_by(contributor_name) %>% 
  summarise(total_given = sum(contribution_receipt_amount, 
                              na.rm = TRUE)) %>% 
  slice_max(order_by = total_given, n = 5) %>% 
  mutate(recipient = "Crapo")

risch_top5 <- risch_subset %>% 
  group_by(contributor_name) %>% 
  summarise(total_given = sum(contribution_receipt_amount, 
                              na.rm = TRUE)) %>% 
  slice_max(order_by = total_given, n = 5) %>% 
  mutate(recipient = "Risch")

glimpse(simpson_top5)
  
  
  