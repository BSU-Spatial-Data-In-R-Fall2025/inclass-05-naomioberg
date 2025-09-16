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

# combine all dataframes into a single top 5 donors dataframe using bind_rows
top5_donors <- bind_rows(simpson_top5,fulcher_top5,crapo_top5,risch_top5)

# create a single receipts dataframe with all of our individual donations and
# select the variables that contributor, filter using distinct and then join them
# back with the top 5 donors list
all_contributors <- bind_rows(
  select(simpson_receipts, contains("contributor")),
  select(fulcher_receipts, contains("contributor")),
  select(crapo_receipts, contains("contributor")),
  select(risch_receipts, contains ("contributor"))) %>%
  select(all_of(c("contributor_name","contributor_city", "contributor_state",
                  "contributor_employer"))) %>%
distinct()

(top5_donors_location <- top5_donors %>%
  left_join(all_contributors, by = join_by(contributor_name)))

# identify overlapping data
crapo_risch_shared <- crapo_top5 %>%
  inner_join(risch_top5, by = "contributor_name")

crapo_risch_shared

# identify non overlapping data
crapo_risch_not_shared <- crapo_top5 %>%
  anti_join(risch_top5, by = "contributor_name")

crapo_risch_not_shared  

# donations through time
overall_top10_names <- top5_donors %>%
  arrange(desc(total_given)) %>%
  slice_max(order_by = total_given, n = 10) %>%
  pull(contributor_name) # pull = takes the variable you give it and returns a vector with all the values in that variable

overall_top10_names  

# combine individual donor data with years that we created earlier
individual_receipts <- bind_rows(
  simpson_subset %>% mutate(recipient = "Simpson"),
  fulcher_subset %>% mutate(recipient = "Fulcher"),
  crapo_subset %>% mutate(recipient = "Crapo"),
  risch_subset %>% mutate(recipient = "Risch")
)

# filter for contributors in our top 10 list
top10_receipts <- individual_receipts %>%
  filter(contributor_name %in% overall_top10_names) %>%
  group_by(report_year, recipient, contributor_name) %>%
  summarize(total_given = sum(contribution_receipt_amount, na.rm = TRUE)) %>%
  ungroup()

top10_receipts #long format data

ggplot(data = top10_receipts, 
       mapping = aes(x = report_year, y = total_given, color = recipient))+
  geom_line() + 
  geom_point() +
  facet_wrap(vars(contributor_name), scales = "free_y")+
  labs(title = "Top 5 Donors Over Time by Representative",
       x= "Year",
       y = "Total Contributions ($)") +
  theme_minimal()

# save manipulated dataset to the processed folder
write_csv(top10_receipts, "data/processed/id_fec_top10.csv")










