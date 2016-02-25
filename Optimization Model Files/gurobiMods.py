import timeit
from gurobipy import *

MIPFoci = [0,1,2,3]
GapTol  = [1e-10, 1e-5, 1]
Heur    = [0.05, 0.1]
NumFoci = [0, 3]

comma = ", "
times = "time"+comma+"NumFocus"+comma+ "Heuristics"+comma+ "MIPGap"+comma+"MIPFocus"+"\n"
print(times)
logfile = open('paramruntimes.csv','a')
logfile.write(times)
logfile.close()  

for mip in MIPFoci:
 for gap in GapTol:
  for h in Heur:
   for n in NumFoci:	
	for i in xrange(0,30):
		quarter = str(i)
	        print('Iter:' + str(i))	
		m = read("ReadingPlan%s.mps" % str(quarter))
		m.params.NumericFocus = n
		m.params.Heuristics = h
		m.params.MIPGAPABS = gap
		m.params.MIPFOCUS = mip
		start = timeit.default_timer()		
		m.optimize()
		gurobitime=(timeit.default_timer() - start)
		times = str(gurobitime) + comma + str(n) + comma + str(h) + comma + str(gap) + comma+ str(mip) + "\n"
		print(times)
		logfile = open('paramruntimes.csv','a')
		logfile.write(times)
		logfile.close()        
		


