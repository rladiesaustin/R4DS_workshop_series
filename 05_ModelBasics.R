##########################################


# R for Data Scicence 


# R Ladies Austin Meetup 1/24/18


# model basics with modelr


###########################################



# load the tidyverse and the modelr package

library(tidyverse)

# note modelr is a package to help investogate models
# we use R base functions for the actual model building 
library(modelr)
options(na.action = na.warn)



#lets start with a basic model with two continuous variables 
# the modelr package has a very sample datasets
# lets look at sim1 and use that to start 
head(sim1)


# a nice way to start with a model is to look at a plot of the data
ggplot(sim1, aes(x, y)) + 
  geom_point()


# interesting! appears to be a linear relationship between x and y
# as x increases, y increases

# lets try to build a model to approximate this relationship 
# the lm() function creates a linear model
# R4DS goes through another approach to understand the behind the scene workings of this if you are interested 
mod1<-lm(y~x, data=sim1)

#this gives us a summary of the model results
summary(mod1)

# this pulls out only the coefficients of the model
# we only have one term in the model, so we will see that term and the intercept
coef(mod1)



#the point of a model is to be able to make prediction.
# lets use modelr to look at the predicted values from our model 

# first lets create a grid of the values in our model
grid <- sim1 %>% 
  data_grid(x) 
grid


# now lets add the predicted values 
grid <- grid %>% 
  add_predictions(mod1) 
grid


#lets plot those predicted values
ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)


# the flip side of predictions are residuals--what leftover variation is there 
# that is unxplained, or residual, from the module?

sim1 <- sim1 %>% 
  add_residuals(mod1)
sim1


# ok now lets plot these residual values against the original x values
# Note that the average of the residual will always be 0.

ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point() 


#if you see a pattern in this type of plot, it may indicate you do not have a good model fit
# here it looks random, so we probably have a decent model!


# yay!



# Next we will cover the following topics using different sample datasets

# Categorical variables
# Interactions
  # Continuous and categorical
# Transformations
# Missing Values



#lets leook at sim2 which has a categorical var

head(sim2)

# and create a model....
mod2 <- lm(y ~ x, data = sim2)


# and add predictions...
grid <- sim2 %>% 
  data_grid(x) %>% 
  add_predictions(mod2)
grid


####################CATEGORICAL VARS



# which shows us the predicted value for each level of x (a,b,c,d)
# effectively the predicted value will be the mean value of each level
# we can visulaize if that is true here: 

ggplot(sim2, aes(x)) + 
  geom_point(aes(y = y)) +
  geom_point(data = grid, aes(y = pred), colour = "red", size = 4)



## looks like red points( predicted values) are similar ot the mean values 

means<-sim2%>%
  group_by(x)%>%
  summarise(mean=mean(y))
means

#indeed they are the same!!






####################  INTERACTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#LETS look at a dataset that has a categorical and continuous predictor

ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(colour = x2))

#x1 = cont
#x2 = categorical 

# you could create a model with both predctors independently as this: 
mod1 <- lm(y ~ x1 + x2, data = sim3)

# or if you want to indicate an interaction between x1 and x2, you could write the model as: 
mod2 <- lm(y ~ x1 * x2, data = sim3)
#Note that whenever you use *, both the interaction and the individual components are included in the model.


# lets get predictions for these, we need to include both vars in the grid statement
#To generate predictions from both models simultaneously, 
#we can use gather_predictions() which adds each prediction as a row.
grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid



# we can visually inspect and compare the results from both models using: 

ggplot(sim3, aes(x1, y, colour = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + 
  facet_wrap(~ model)

# which model appears to fit the data better?


# we can empirically investogate by looking at the residuals
# patterns in  residuals = worse fit



sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)


#visualize the residuals by x2 which makes it easier to see any potential patterns
ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)



# mod 1 has definiete patterns, whereas mod2 seems like random variation, mod1 seemed to miss something
# ub x2 that mod2 may have captured better. 




# interactions with continuous vars are a bit more complicated--check out the book for more info!!!



####################  TRANSFORMATIONS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# can be inside the model call eg log, exponential
# useful because you can use them to approximate non-linear functions


# a common transformation is a log 



# can transform predictor or response or both!


# for examples

modt <- lm(log(y) ~ x1 + x2, data = sim3)

summary(modt)

plot(modt)


ggplot(sim3, aes(x1, log(y), colour = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + 
  facet_wrap(~ model)




####################  MISSING VALUES  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# be on the look out for missing values!

# if a row has any missing values that are in the model, that row will be dropped

df <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,
  3, 3.5,
  4, 8.3,
  NA, 10
)

mod <- lm(y ~ x, data = df)

# here you get a warning that tells you this. 


# you can suppress the warning but i do not reccomend it!
mod <- lm(y ~ x, data = df, na.action = na.exclude)


# You can always see exactly how many observations were used with nobs()
nobs(mod)




####################  OTHER MODEL FAMILIES  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# there are many different types of models! check out more about the ones below in the book

# Generalised linear models, e.g. stats::glm()
# Generalised additive models, e.g. mgcv::gam()
# Penalised linear models, e.g. glmnet::glmnet()
# Robust linear models, e.g. MASS:rlm()

# work similarly from a programming perspective - fun!




####################################   //     END    \\   ##################################################################