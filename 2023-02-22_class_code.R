
# 1. Prefix ---------------------------------------------------------------

# necessary packages
library(tidyverse)
library(naniar)


# Import data -------------------------------------------------------------

zz_dataset <- read_csv("data/2023-02-20_QoC_sample_dataset.csv")

# check the import
head(zz_dataset, n = 5)

# change the relevant variables into factors
dataset <- zz_dataset %>% mutate(sex = as.factor(sex), 
                                 unit = as.factor(unit))

# 2. Count the unit of analysis -------------------------------------------

# using sort = TRUE arranges the dataframe with the most often occurence on top
count(dataset, patient_ids, sort = TRUE)

# you see that you get 96 rows whereas you would expect 100 rows...
# obviously, some patient_ids are present > 1


# 3. Check missings -------------------------------------------------------

# visualize the missings - this does not give you any hint if the 
# present values are of good quality, juts how many values are absent
vis_miss(dataset)

# this does not look to bad in terms of missings


# 4. Further check the duplicates -----------------------------------------

# ---- identify the weird cases ----

# create dataset with the counted-frequencies of each row occurence
aa <- count(dataset, patient_ids, sort = TRUE)

# programmatically extract the patient ids that are present > 1 and
# store them in a vector called "stored_weird_ids"
stored_weird_ids <- aa %>% filter(n > 1) %>% pull(patient_ids)


# manual approach: look the number up in 'aa' and copy paste them
# this is not recommended if you have > 5/10 cases that are odd 
# as this is an errorprone approach
weird_ids <- c("10119", "12335", "16839", "18098")

# ---- filter the weird cases and decide on an action ----

# tidyverse approach to filter the weird_ids / it gives the same appraoch
# with stored_weird_ids as with weird_ids
dataset %>% filter(patient_ids %in% weird_ids)

# base approach to filter the weird_ids
dataset[dataset$patient_ids %in% weird_ids, ]


# look at the cases using %>% view()
dataset %>% filter(patient_ids %in% weird_ids) %>% view()


# ---- check the full duplicated cases ----
table(duplicated(dataset))


# ---- write the decision down for each case (narratively)

# 10119: fully duplicated - remove 1 row with the distinct()-function

# 12335: unclear - if access to raw data try to verify and use the correct case
# in case of doubt: remove both rows

# 16839: mismatch in almost all variables - remove both rows

# 18098: probably databse-issue with duplication - remove the row with the empty discharge date



# ---- translate this decision back into data cleaning

final_sample <-
  dataset %>% 
    distinct()  %>% # distinct is the inverse of duplicated() - as we have exactly 1 fully duplicated entry, this will drop one line 
    filter(patient_ids != 12335) %>% # remove the 12335 (both as we do not have access to raw data)
    filter(patient_ids != 16839) %>% # remove both cases - mismatch in almost all variables
    filter(!(patient_ids == 18098 & is.na(los))) # the ! negates the whole operation - so I drop the case with the patient_id and a missing in los

