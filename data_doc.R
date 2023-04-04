

# pkgs
library(dplyr)
library(tidyr)
library(ggplot2)
suppressPackageStartupMessages(library(kableExtra))

# if you need to download the fontawesome icons
# icons::download_fontawesome()

## # this is a code chunk to load all functions in {ggplot2}
## library(ggplot2)


wldf <- 
  tibble(person_id = LETTERS[1:4], 
         uses_phone = c("yes", "yes", "yes", "no"),
         uses_computer = c("no", "yes", "no", "yes")) 

wldf %>% 
  kbl(caption = "Tidy dataframe - wide format") %>% kable_styling()

wldf %>% 
  pivot_longer(cols = -person_id) %>% 
  ggplot(aes(x = name, fill = value)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = NULL, 
                     labels = scales::percent) +
  scale_fill_discrete(name = NULL) +
  labs(x = NULL) +
  theme_minimal()

tibble(person_id = c("A", "B", "C"), 
       age = c(22L, 34L, 45L), 
       prof_experience = c(11L, 12L, 24L)) %>% kbl() %>% kable_styling()

# create a sample-df with 100 rows and 
# 3 variables
set.seed(1234)

df_miss <- 
  tibble(id = 1:100,
         var1 = sample(
           c(1:4, NA_real_), 100, T),
         var2 = sample(
           c(1:4, NA_real_), 100, T))

# first 4 entries
head(df_miss, 4) 

# quick summary of proportional missings
naniar::miss_prop_summary(df_miss)



naniar::vis_miss(df_miss) %>% 
  ggsave(file = "vismiss.png", device = "png", height = 11)

## library(naniar)
## vis_miss(df_miss)

head(df_miss)
