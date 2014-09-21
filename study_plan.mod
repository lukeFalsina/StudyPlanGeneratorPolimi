# Study plan model to help students choosing courses for their Degree.
# Author: Luca Falsina

# SETS
# I := Set with courses codes
# J := Set with tables names
set I;
set J;

# PARAMS
param cr{I} >= 0, integer; # Number of credits for each course in I
param liking{I} >=1, <=5, integer; # Parameter representing interest of the student in attending course i in I

param belongs_to{I,J} binary; # 1 if course i in I belongs to table j in J; 0 otherwise
param english{I} binary; # 1 if course i in I is taught in English; 0 otherwise
param 1_sem{I} binary; # 1 if course i in I is provided in the first semester; 0 if it is provided in the second semester
param mandatory{I} binary; # 1 if course i in I is mandatory for the student;
param forbidden{I} binary; # 1 if course i In I can't be selected by the student;

param cr_min_table{J} >= 0, integer; # Minimum number of credits that must be picked from table j in J
param cr_max_table{J} >= 0, integer; # Maximum number of credits that could be selected from table j in J

param CR_MIN >= 0, integer; # Number of credits required to get the degree (Thesis credits are left out)
param CR_MAX >= CR_MIN, integer; # Maximum number of credits that can be selected by a student (Thesis credits are left out)

param CR_MIN_SEM1 >= 0, integer; # Minimum number of credits that should be selected by the student during the first semesters
param CR_MAX_SEM1 >= CR_MIN_SEM1, integer; # Maximum number of credits that should be selected by the student during the first semesters

param CR_MIN_SEM2 >= 0, integer; # Minimum number of credits that should be selected by the student during the second semesters
param CR_MAX_SEM2 >= CR_MIN_SEM2, integer; # Maximum number of credits that should be selected by the student during the second semesters

param CR_MIN_TABA_TABB >= 0, integer; # Minimum number of credits taken from TABA and TABB

# VARS
var x{I} binary; # 1 if course i in I is selected; 0 otherwise

# OBJECTIVE FUNCTION
# The objective is to maximize the student's liking of the study plan while respecting all the constraints..
maximize study_plan_liking: sum{i in I} cr[i] * liking[i] * x[i]; 

# CONSTRAINTS
subject to min_credits_study_plan: sum{i in I} cr[i] * x[i] >= CR_MIN; # A valid study plan has at least CR_MIN credits
subject to max_credits_study_plan: sum{i in I} cr[i] * x[i] <= CR_MAX; # A valid study plan has at most CR_MAX credits

subject to one_table_per_course {i in I}: sum{j in J} belongs_to[i,j] = 1; # Each course i must have been assigned only to one table j in J
subject to table_correctness {j in J}: cr_min_table[j] <= cr_max_table[j]; # Check correctness of tables constraints 

subject to min_credits_per_table {j in J}: sum{i in I} cr[i] * belongs_to[i,j] * x[i] >= cr_min_table[j]; # A different minimum number of credits must be picked from each table j in J
subject to max_credits_per_table {j in J}: sum{i in I} cr[i] * belongs_to[i,j] * x[i] <= cr_max_table[j]; # A different maximum number of credits could be picked from each table j in J

subject to all_mandatory_courses: sum{i in I} mandatory[i] * (1 - x[i]) = 0; # All mandatory courses must be selected
subject to no_forbidden_course: sum{i in I} forbidden[i] * x[i] = 0; # No forbidden course could be picked
subject to no_forbidden_and_mandatory_together {i in I}: mandatory[i] + forbidden[i] <= 1; # Constraint to check correctness of mandatory and forbidden vectors.

subject to min_credits_first_semesters: sum{i in I} 1_sem[i] * cr[i] * x[i] >= CR_MIN_SEM1; # A minimum number of courses to attend during first semesters
subject to max_credits_first_semesters: sum{i in I} 1_sem[i] * cr[i] * x[i] <= CR_MAX_SEM1; # A maximum number of courses to attend during first semesters
subject to min_credits_second_semesters: sum{i in I} (1 - 1_sem[i]) * cr[i] * x[i] >= CR_MIN_SEM2; # A minimum number of courses to attend during second semesters
subject to max_credits_second_semesters: sum{i in I} (1 - 1_sem[i]) * cr[i] * x[i] <= CR_MAX_SEM2; # A maximum number of courses to attend during second semesters

#subject to min_credits_TABA_TABB: sum{i in I} cr[i] * (belongs_to[i,TABA] + belongs_to[i,TABB]) * x[i] >= CR_MIN_TABA_TABB; # Constraint on the number of credits from TABA and TABB

### UNCOMMENT THE FOLLOWING LINE (FOR FOREIGN STUDENTS!)
#subject to only_english_taught_courses: sum{i in I} (1 - english[i]) * x[i] = 0; # Constraint for foreign students: any course not taught in English must be discarded
