#	GenerateStudyPlan.py
#	This small Python script takes as an input the solution provided
#	by AMPL on the study_plan.mod and saves in an outfile file
#	the corresponding study plan table using courses information 
#	stored in the auxiliary file "course_info.txt"
#
#	Author: Luca Falsina
#

from tabulate import tabulate
from operator import itemgetter
import sys

def main(argv):
	if (len(sys.argv) != 1):
		sys.exit('Usage: GenerateStudyPlan.py')

	# Initialize dictionaries. 
	isInEnglish = {}
	credits = {}
	semester = {}
	group = {}
	name = {}

	# Collect all courses info from an auxiliary file
	# and store them into proper dictionaries.
	with open('course_info.txt') as courseFile:
		for line in courseFile:
			course_info_list = list(line.split('#'))
			# First attribute is the unique code for the course..
			course_code = int(course_info_list[0])
			# Then it follows the language used to teach it..
			if int(course_info_list[1]) == 1:
				isInEnglish[course_code] = "English"
			else:
				isInEnglish[course_code] = "Italian"
			# Then its number of credits..
			credits[course_code] = int(course_info_list[2])
			# Then the semester in which it's held..
			semester[course_code] = int(course_info_list[3])
			# Then its group..
			group[course_code] = course_info_list[4].replace(" ","")
			# And finally the full course name
			name[course_code] = course_info_list[5].strip()
	
	# Initialize study plan table with first row used for the headers
	studyPlanTable = []

	with open('temp.txt') as studyPlanFile:
		# Skip first three lines since they are headers
		for _ in xrange(3):
			next(studyPlanFile)
		for line in studyPlanFile:
			if len(line) > 6:
				# Remove multiple blank spaces
				purgedLine = " ".join(line.split())
				counter = 0
				currCourseCode = 0

				for value in purgedLine.split():
					if counter % 2 == 0:
						# This value should be a course code..
						currCourseCode = int(value)
					else:
						# This value tells if the previous course 
						# should be added to the study plan..
						if int(value) == 1:
							# The tuple of this course is added..
							studyPlanTable.append([currCourseCode, name[currCourseCode], group[currCourseCode], isInEnglish[currCourseCode], semester[currCourseCode], credits[currCourseCode]])
					counter = counter + 1

	# Sort elements in the table by their name
	studyPlanTable = sorted(studyPlanTable, key=itemgetter(1))
	# Define headers for the table
	headers_tuple = ["Code", "Course Name", "Group", "Teaching Language", "Semester", "Credits (CFU)"]

	print tabulate(studyPlanTable, headers = headers_tuple, tablefmt="grid")


if __name__ == "__main__":
	main(sys.argv[1:])