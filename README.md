combinatorics-is-hard
=====================
Dev Bootcamp is a nine-week course with roughly 20-25 students (called a "cohort").
Each week the cohort is divided into different 4-6 person teams.
Within each team the students pair program, switching partners every day, so that by the end of each week every student has paired with every other student on their team.

###Problem:
How to divide up the teams so that every student has paired with every other student in the cohort in the fewest number of weeks.

###Optimal Solution:
Recursion. Recursively explore every possible combination of groups, selecting the most efficient set of groupings.

###Problem with that solution:
I do not own a computer with 5TB of RAM to handle the call stack that many combinations would generate! So until I can work out some kind of branch and bound algorithm (TODO) to cut down on the number of combinations under consideration, I have to take a different tack.

###Current Solution:
Optimize each individual week's groupings and call it a day. As this does not optimize for the set of weeks as a whole, it will necessarily fall short of the optimal solution. To measure how far off of optimal we are, I include the #schoolgirls method, which runs the [Kirkman's schoolgirl problem](http://en.wikipedia.org/wiki/Kirkman's_schoolgirl_problem) scenario, a classic combinatorics problem with a known solution.

###Progress:
Kirkman's (perfect) solution takes seven iterations. My algorithm currently takes eight. Not bad!

###Instructions:
I'm still playing around with it, so it's set up to run in a pry REPL session, with ultimately unecessary attr_accessors and other cruft still in there. Just require it and run #boots ('boots' is the nickname for Dev Bootcamp students) for a 24 person, 6 person per team example, or go ahead and instantiate your own Combo instance and #run it.
