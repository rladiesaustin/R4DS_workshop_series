##################################

# R ladies R4DS

# ggplot2

# created 9/27/2017


################################



#lets start by loading ggplot
# can do tidyverse package or ggplot2 package (need to installed first!)


# load package 
library(tidyverse)

# lets take a look at the mpg dataset included with ggplot2
# this shows us the first few rows
head(mpg)

# start with a basic plot
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))

      # shows us  engine size (displ) compared with fuel eff. (hwy)


# SELECT EXERCISES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# P 12 # 1

# whats wrong with the following code?

ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, colour="blue"))




#p 12 #2

# how can we learn more about the var types in mpg dataset?


?mpg

str(mpg)



# p 12 # 3


# map a continuous var to color, size and shape 

ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, colour= cty))


ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, size= cty))

# watch out....
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, shape= cty))

# try this
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, shape= fl))




#12 what happens if you map the same var to multiple aes?

ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, color= displ))


ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=displ, color= displ))




#p 21. # 6 


ggplot(data = mpg, mapping = aes(x=displ, y=hwy))+
  geom_point()+
  geom_smooth(se= FALSE)



#geom_point(mapping = aes(color= drv))+

#geom_smooth(se= FALSE, aes(colour=drv))






# p 33 # 

# what does labs() do?


?labs()

 # xlab()
#ylab()
#ggtitle()




# p 33 # 4

# what does geom_abline do?
# why is coord_fixed() important?

ggplot(data= mpg, mapping=aes(x=cty, y=hwy))+
  geom_point()+
  geom_abline()+
  coord_fixed()


?coord_fixed()
