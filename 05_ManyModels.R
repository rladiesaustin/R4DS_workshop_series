library(modelr)
library(tidyverse)
library(gapminder)

# this is the gapminder dataset
gapminder

# let's visualize life expectancy by year
gapminder %>% 
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(alpha = 1/3)


# single country example : new zealand
nz <- filter(gapminder, country == "New Zealand")

# visualize data
nz %>% 
  ggplot(aes(year, lifeExp)) + 
  geom_line() + 
  ggtitle("Full data = ")

# create life expectancy model
nz_mod <- lm(lifeExp ~ year, data = nz)

# add predictions and visualize
nz %>% 
  add_predictions(nz_mod) %>%
  ggplot(aes(year, pred)) + 
  geom_line() + 
  ggtitle("Linear trend + ")

# add residuals and visualize
nz %>% 
  add_residuals(nz_mod) %>% 
  ggplot(aes(year, resid)) + 
  geom_hline(yintercept = 0, colour = "white", size = 3) + 
  geom_line() + 
  ggtitle("Remaining pattern")

##########################################################

# multiple models

# first, create a nested dataframe
by_country <- gapminder %>% 
  group_by(country, continent) %>% 
  nest()

# let's look at it
by_country

# here's what an entry in the data column looks like
by_country$data[[1]]

# function to create a model
country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}

# use purrr::map to apply model function for all countries
models <- map(by_country$data, country_model)

# note we can also do this in the dataset to keep data together
by_country <- by_country %>% 
  mutate(model = map(data, country_model))
by_country

# and add residuals to the dataset
by_country <- by_country %>% 
  mutate(
    resids = map2(data, model, add_residuals)
  )

resids <- unnest(by_country, resids)
resids

# let's visualize the residuals
resids %>% 
  ggplot(aes(year, resid)) +
  geom_line(aes(group = country), alpha = 1 / 3) + 
  geom_smooth(se = FALSE)

resids %>% 
  ggplot(aes(year, resid, group = country)) +
  geom_line(alpha = 1 / 3) + 
  facet_wrap(~continent)