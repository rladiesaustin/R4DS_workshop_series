# Let's explore the babynames dataset

# Install and load babynames package and dplyr
install.packages("babynames")
library(babynames)
library(dplyr)

# First, let's use filter() to get a dataframe of just your name.
# Note: capitalization matters here
caitlin_df <- babynames %>%
  filter(name == "Caitlin")

# In my case, I'm also going to filter so that we're just looking at 
# Caitlins who are female. Add multiple filters by using a comma:
caitlin_df <- babynames %>%
  filter(name == "Caitlin", sex == "F")

# Since we don't need the "sex" variable anymore, let's select the other
# variables that we do care about:
caitlin_df <- caitlin_df %>% select(year, n, prop)

# Here's a more 'advanced' (or shortcut) version of that same filter
# using a magrittr operator, '%<>%'
# (this next line is resetting the dataset)
caitlin_df <- babynames %>%
  filter(name == "Caitlin", sex == "F")

library(magrittr)
caitlin_df %<>% select(-(sex:name))

# Let's look at data for the earliest years, then the most recent years

caitlin_df %>% arrange(year)
caitlin_df %>% arrange(desc(year))

# Let's create a new variable, decade, using mutate, and use
# group_by() and summarise() to figure out the decade with the most "caitlins"
caitlin_df %>% 
  mutate(decade = substr(year, 3, 3)) %>%
  group_by(decade) %>%
  summarise(total_caitlins = sum(n))



