from gurobipy import *

for i in xrange(0,30):
	quarter = str(i)
	print('Iter:' + str(i))	
	m = read("ReadingPlan%s.mps" % str(quarter))
	m.write("ReadingPlan"+str(i)+".lp")
	
