library(agricolae)
#Manually edited CSV file... I should have thought ahead...
A <- read.csv("~/Desktop/Reading/runtimes-stats.csv")

fSolver <-factor(A$solver)
time <- as.numeric(A$time)

#boxplot(time~fSolver)

time.mean <- mean(time)
pairwise.t.test(time, fSolver, p.adj = 'hochberg', pool.sd=F)
model <- aov(time~fSolver, data=A)
#summary(model)
TukeyHSD(model, ordered = FALSE, conf.level = .8)
scheffe.test(model,"fSolver", alpha= .2, console=TRUE)
#Tukey and Scheffe both show that, overall, there is not
#a statistically significant difference between the Solvers
#However, upon visual inspection, there appears to be some
#iterations with a large difference between COIN/GNU LPK
#and GUROBI.

iter <- A$iter
iter <- factor(iter)

boxcolors <-c("firebrick","dodgerblue", "forestgreen")
plotcolors <- rainbow(6,s=.8, v=.8)
#plotcolors <- plotcolors[-2] #nobody likes yellow
par(mfrow=c(2,2))
#m <- matrix(c=(1,2,3,4,3,4),3,2, byrow=TRUE)
#layout(m)
boxplot(time~A$solver, col = boxcolors, ylab="Time(sec)", main="Boxplot of Solver Times")
boxplot(time~fSolver, ylim = c(0,2),ylab="Time(sec)",col = boxcolors, main="Zoomed Boxplot of Solver Times")
interaction.plot(fSolver, iter, time, type="l", col = plotcolors,
                 legend = FALSE,
                 xlab="Solver Used",
                 ylab="Time (sec)",
                 main="Interaction Plot of Solvers by Iteration")
interaction.plot(fSolver, iter, time, type="l", ylim=c(0,3), col = plotcolors,
                 legend = FALSE,
                 xlab="Solver Used",
                 ylab="Time (secs) --Zoomed axis",
                 main="Zoomed Interaction Plot of Solvers by Iter")


