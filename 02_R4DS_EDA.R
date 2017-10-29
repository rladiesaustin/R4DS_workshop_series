##################################

# R ladies R4DS

# ggplot2

# created 10/29/2017

################################



# for EDA, load the tidyverse!
# common to use both ggplot2 and dplyr when exploring data
library(tidyverse)


##########VISUALIZE DISTRIBUTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#lets visualize some data from the diamonds dataset included with ggplot2

# for CATEGORICAL VAR
ggplot(data = diamonds)+
  geom_bar(mapping = aes(x=cut))  # remember, default geom, default stat. for bar it is count


# for CONTINUOUS VAR
ggplot(data=diamonds)+
  geom_histogram(mapping = aes(x=carat), binwidth = 0.5) # try adjusting the bindwidth here, what does it do?





##########TYPICAL VALUES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#lets first look at smaller diamond sizes 

small<-diamonds%>%
  filter(carat < 3)


ggplot(data = small, aes(carat))+
  geom_histogram(binwidth = 0.01)    # what do you notice with this plot? any clustering??






##########UNUSUAL VALUES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# a big clue to outliers ----very wide x axis: 


ggplot(diamonds)+
  geom_histogram(aes(x=y), binwidth=0.5)

# looks like nothing is there,but there is! lets zoom in 


ggplot(diamonds)+
  geom_histogram(aes(x=y), binwidth = 0.5)+
  coord_cartesian(ylim=c(0,50))
#there they are!!!


# P . 91 exercise 4
# try above with xlim and ylim---what happens?


# P.91 exercise 2 --what is up with price?

ggplot(diamonds, aes(price))+
  geom_histogram()
# try different bin widths here!!





# how could we look at these unusual values with dplyr??? TRY THAT HERE:













##########MISSING VALUES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# for unusual values, dont delete them, ghost them with NA!

diamonds2<-diamonds%>%
  mutate(y = ifelse(y<3 | y>20, NA, y))
  
#look at the ones that are NA

look<-filter(diamonds2, is.na(y))
#notice any patterns with these?





##########COVARIATION - BOXPLOT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#good for comparing a continuous variable across a categorical var

ggplot(data=diamonds, aes(x=cut, y=price))+
  geom_boxplot()

#notice any odd patterns??


# P 99 # 5 lets check out different plots

ggplot(data=diamonds, aes(x=cut, y=price))+
  geom_violin()


ggplot(data=diamonds, aes(x=price, color=cut))+
  geom_freqpoly()





##########COVARIATION - TWO CATEGORICAL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


ggplot(data=diamonds)+
  geom_count(aes(x=cut, y=color))


# vs


diamonds%>%
  count(color, cut)%>%
  ggplot(aes(x=color, y=cut))+
  geom_tile(aes(fill=n))

# this is also known as a heat map


# P. 101 exercise 3

# why is the above plot slightly better than the one below??

diamonds%>%
  count(color, cut)%>%
  ggplot(aes(y=color, x=cut))+
  geom_tile(aes(fill=n))






##########COVARIATION - TWO CONTINUOUS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# out good friend the scatter plot!!

ggplot(data=diamonds)+
  geom_point(aes(x=carat, y=price))

# whats up with the 5 carat diamond that is as expensive as many 1-3 carat diamonds?
# what could we add to the above plot to help figure this out?


# bin a continuous variable to behave like a categorical.....

ggplot(data=small, aes(x=carat, y=price))+
  geom_boxplot(aes(group=cut_width(carat, 0.1)))



# but this is somewhat misleading---we know the Ns are very different for these groups

# enter varwidth = TRUE!

ggplot(data=small, aes(x=carat, y=price))+
  geom_boxplot(aes(group=cut_width(carat, 0.1)), varwidth = T)







































