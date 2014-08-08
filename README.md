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
Optimize each individual week's groupings and call it a day. As this does not optimize for the set of weeks as a whole, it will necessarily fall short of the optimal solution. To measure how far off of optimal we are, I include the `#schoolgirls` method, which runs the [Kirkman's schoolgirl problem](http://en.wikipedia.org/wiki/Kirkman's_schoolgirl_problem) scenario, a classic combinatorics problem with a known solution.

###Progress:
Kirkman's (perfect) solution takes seven iterations. My algorithm currently takes eight. Not bad!

###Instructions:
I'm still playing around with it, so it's set up to run in a pry REPL session, with ultimately unnecessary `attr_accessors` and other cruft still in there. Just require it and run `#boots` ('boots' is the nickname for Dev Bootcamp students) for a 24 person, 6 person per team example, or go ahead and instantiate your own `Combo` instance and `#run` it.

```sh
pry -r ./new_combo.rb
```
```ruby
# runs Kirkman's schoolgirls problem
pry(main)> schoolgirls

# runs a basic, 24 person, 6 per-team scenario
pry(main)> boots

# same, but with only 4 people per-team
pry(main)> boots(per_team: 4)

# custom scenario
pry(main)> group = ["Drake", "Rihanna", "Chris Brown", "Rihanna's Best Friend"]
pry(main)> members_per_group = 2
pry(main)> combo = Combo.new(group, members_per_group)
pry(main)> combo.run
```
##TODO
- currently the code is a typical [Spherical cows](http://en.wikipedia.org/wiki/Spherical_cow) solution, as the number of students per team must divide evenly into the total number of students; refactor to allow for uneven group totals
- it doesn't actually print out the groupings yet(!), as I'm still trying to optimize the algorithm and didn't want to look at screens and screens of results - easy fix
