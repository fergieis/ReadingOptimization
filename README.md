# ReadingOptimization

This project is separated across the following folders:

*Project write-up file (pdf and odt)
*This Markdown file
* Analysis
	* Image Files with Plots
	* R Script for statistical analysis
* Optimization Model Files
	* Python Script to generate and solve 30 instances
	* MPS files with random generated parameters
	* Gurobi Python script (to call with gurobi.sh) with changed parameters
	* Goodreads csv file contraining base data
	* Modified CSV file for use with R (Solver as factors)
	* Misc
		* Python script to convert MPS to LP files
		* LP model files
		* R script for running GLPK and LP Solve
		* a thousand tears of saddness

To do list:
- [x] Need to fork over toy instance (NA)
- [x] Include personal use case (NA)
- [x] Iterate over 30 large instances
- [x] Implement Solver Options for Gurobi
- [x] Descriptive Stats on basic solns
- [x] Stats on DOE for sol w/ Options
- [x] MPS file upload to NEOS (Not doing)
- [x] Port to R for LPSolve comparison
- [x] Modify scripts to use R input format (mps instance, time, Solver) done enough
- [x] Write up complete!  Mission accomplished.

