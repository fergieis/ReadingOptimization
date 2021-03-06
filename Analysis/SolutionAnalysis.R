library(agricolae)
#Manually edited CSV file... I should have thought ahead...
A <- read.csv("~/Desktop/Reading/runtimes-stats.csv")

Solver <-factor(A$solver)
time <- as.numeric(A$time)
iter <- factor(A$iter)

time.mean <- tapply.stat(A$time, A$solver, stat="mean")
pairwise.t.test(time, Solver, p.adj = 'hochberg', pool.sd=F)
#         COIN GLPK-R GNU  GUROBI
# GLPK-R  0.99 -      -    -     
# GNU     0.99 0.99   -    -     
# GUROBI  0.50 0.47   0.50 -     
# LPSolve 0.99 0.99   0.99 <2e-16

#Single Factor ANOVAs
model <- aov(time~Solver, data=A)
model2 <- aov(time~iter, data=A)

#no sig diff between iterations alone
#no sig diff between solvers alone
scheffe.test(model2,"iter", alpha= .1, console=TRUE)
TukeyHSD(model, ordered = FALSE, conf.level = .9)
scheffe.test(model,"Solver", alpha= .1, console=TRUE)

#2-Factor ANOVA (Solver and Iteration)
#Statistical significance
model3 = aov(time~Solver+iter)
l<- matrix(c(1,2,3,4), 2, 2, byrow = TRUE)
layout(l)
#Heavytailed... leverage graph between solvers...
plot(model3)
anova(model3)
scheffe.test(model3,"Solver", alpha = .1, console = TRUE)
#Gurobi is definitely better than running GLPK from R.
# Groups, Treatments and means
# a 	 GLPK-R  	 3.587 
# ab 	 GNU     	 2.682 
# ab 	 COIN    	 2.665 
# ab 	 LPSolve 	 2.498 
# b 	 GUROBI  	 0.09812 

TukeyHSD(model3, ordered = FALSE, conf.level = .9)
#Tukey agrees, Gurobi is better than GLPK in both R and Python.
#We also have results approaching practical significance re: GNU and COIN

# $Solver
#                 diff        lwr      upr       p adj
# GLPK-R-COIN    0.92255209 -1.776513  3.6216175 0.8565078
# GNU-COIN       0.01740923 -2.681656  2.7164746 0.9999988
# GUROBI-COIN   -2.56649774 -5.265563  0.1325676 0.1281220
# GNU-GLPK-R    -0.90514286 -3.604208  1.7939225 0.8633026
# GUROBI-GLPK-R -3.48904983 -6.188115 -0.7899845 0.0178133
# GUROBI-GNU    -2.58390697 -5.282972  0.1151584 0.1241103


boxcolors <-c("firebrick","dodgerblue", "forestgreen")
plotcolors <- rainbow(6,s=.8, v=.8)
par(mfrow=c(2,2))
#m <- matrix(c=(1,2,3,4,3,4),3,2, byrow=TRUE)
#layout(m)
barplot(time.mean[,2], names.arg = time.mean[,1], col = boxcolors, main = "Average Solution Time\nBy Solver")
#boxplot(time~A$solver, col = boxcolors, ylab="Time(sec)", main="Boxplot of\nSolver Times")
boxplot(time~Solver, ylim = c(0,3),ylab="Time(sec)",col = boxcolors, main="Enlarged Boxplot of\nSolver Times")
interaction.plot(Solver, iter, time, type="l", col = plotcolors,
                 legend = FALSE,
                 xlab="Solver Used",
                 ylab="Time (sec)",
                 main="Interaction Plot of\nSolvers by Iteration")
interaction.plot(Solver, iter, time, type="l", ylim=c(0,3), col = plotcolors,
                 legend = FALSE,
                 xlab="Solver Used",
                 ylab="Time (secs) --Zoomed axis",
                 main="Enlarged Interaction Plot of\nSolvers by Iteration")
par(mfrow=c(1,1))
interaction.plot(iter, Solver, time, type="l", ylim=c(0,.5), col = c(1,2,3,4),
                 legend = TRUE,
                 lty=1,
                 xlab="Iteration",
                 ylab="Time (secs) -- Zoomed axis",
                 main="Enlarged Interaction Plot of\nInterations by Solver")

#Thought ahead this time... properly formatted csv
P <- read.csv("~/Desktop/Reading/Optimization Model Files/paramruntimes.csv")
P$NumFocus <- factor(P$NumFocus)
P$Heuristics <- factor(P$Heuristics)
P$MIPGap <- factor(P$MIPGap)
P$MIPFocus <- factor(P$MIPFocus)

#Straight to Multi-Factor ANOVA
model4 <- aov(time ~ NumFocus + Heuristics + MIPGap + MIPFocus, data = P)
#Three significant results
scheffe.test(model4,"MIPGap", alpha = .1, console = TRUE)
# time          std   r         Min         Max
# 1     0.004870669 0.0002618505 480 0.004640818 0.007847071
# 1e-05 0.004946781 0.0004987483 480 0.004634142 0.010416031
# 1e-10 0.004950456 0.0005741082 480 0.004647017 0.010485888
# 
# alpha: 0.1 ; Df Error: 1432 
# Critical Value of F: 2.306292 
# 
# Minimum Significant Difference: 6.356314e-05 

# Groups, Treatments and means
# a 	 1e-10 	 0.00495 
# a 	 1e-05 	 0.004947 
# b 	 1     	 0.004871 

scheffe.test(model4,"MIPFocus", alpha = .1, console = TRUE)
# Groups, Treatments and means
# a 	 0 	 0.005032 
# b 	 1 	 0.004944 
# bc 	 2 	 0.004862 
# c 	 3 	 0.004851 
scheffe.test(model4,"Heuristics", alpha = .1, console = TRUE)
# Groups, Treatments and means
# a 	 0.05 	 0.004946 
# b 	 0.1  	 0.004899 
TukeyHSD(model4, ordered = FALSE, conf.level = .9)

ParamData <- cbind(P$time,P$NumFocus,P$Heuristics,P$MIPGap,P$MIPFocus)
colnames(ParamData) <- c("time", "NumFocus", "Heur", "Gap", "MIPFocus")
P.mr <- glm(time ~ NumFocus + Heuristics + MIPGap + MIPFocus, data = P)
 # summary(P.mr)
par(mfrow=c(1,1))
plot(P.mr)

#Heteroscedasticity in the Residuals vs. Fitted suggests a non-constant variance
#Since we are changing the problem structure each iteration it is again 
#apparent that, in simple terms, some iterations are just "harder".  
#The Normal QQ plot suggests that this phenomena is one-sided, there aren't problems that
#one setting found much "easier" than others.


# A curious result is that the "MIPFocus" default parameter of "automatic" is slower 
# than all other settings, including those that theorhetically sacrifice speed.
par(mfrow=c(1,1))

boxplot(P$time~P$NumFocus, ylim = c(0.004,.0105),ylab="Time(sec)",col = boxcolors, main="Numerical Focus")
boxplot(P$time~P$Heuristics, ylim = c(0.004,.0105),ylab="Time(sec)",col = boxcolors, main="%Time in Heuristics")
boxplot(P$time~P$MIPGap, ylim = c(0.004,.0105),ylab="Time(sec)",col = boxcolors, main="Absolute Tolerance")
boxplot(P$time~P$MIPFocus, ylim = c(0.004,.0105),ylab="Time(sec)",col = boxcolors, main="MIP Focus")

tapply(P$time, P$MIPFocus, mean)
# 0           1           2           3 
# 0.005032170 0.004944490 0.004862443 0.004851437 


##Doesn't really make sense here, just playing...  
#library(corrplot)
#Param.cor <- cor(ParamData)
# corrplot.mixed(Param.cor, lower = "number", upper="ellipse", tl.col = "black", order = "AOE")

#Running mps or lp files directly through the 

times <- cbind(0:29,P$time[1:30], time[61:90])
colnames(times)<- c("Iteration", "Gurobi\nPython 2.7", "Anaconda Python 2.7\n w\\ PuLP")
boxplot(times[,2:3], col=boxcolors)

#write.csv(times,"ABC.csv")
#Manual edit..
timediff<- read.csv("~/ABC.csv")

#Statistically Significant Difference between PuLP and
#the Gurobi Command Line Python environment
timediff$Environment <- factor(timediff$Environment)
model5 = aov(Time~Environment, data=timediff)
TukeyHSD(model5, ordered = TRUE, conf.level = .9)

