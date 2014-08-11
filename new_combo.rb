require 'pry'

class Combo
  attr_reader :yet_to_pair, :cohort, :sample_size

  def initialize(cohort, students_per_team, opts={})
    @cohort = cohort
    @per_team = students_per_team
    @score = nil                    # all my instance variables declared here for clarity's sake
    @bind = opts[:bind]             # for pry debugging - remove when code is perfect(!)
    @sample_size = opts[:sample] || 3   # number of top pairings to use when making groupings
    @yet_to_pair = Hash.new         # key is student, value is array of students they've yet to pair with
    @cohort.each do |student|
      @yet_to_pair[student] = @cohort - [student]
    end
  end

  def refresh_score                 # recalculate the memoized @score variable
    @score = @yet_to_pair.values.inject(:+).count
  end

  def easy_first_pass               # initial grouping is easy - nobody's paired with anybody yet
    students = @cohort.dup
    teams_list = []
    (@cohort.length / @per_team).times do
      team = students.slice!((0...@per_team))
      process_teams(team)
      teams_list << team
    end
    refresh_score
    score(1, teams_list)            # output 'score' for this round
  end

  def run
    counter = 1                     # counter is only used for assessing the round of groupings
    easy_first_pass
    until @score == 0 do            # main loop - keep going until unpaired students == 0
      counter += 1
      top_groupings = generate_potential_pairings
      rated_groupings = top_groupings.sort_by {|group| rate_pairings(group)}
      best_group = rated_groupings.last
      process_group(best_group)
      refresh_score
      score(counter, best_group)
    end
    puts "#{counter} iterations"
  end

  def process_group(group)
    group.each {|team| process_teams(team)}
  end

  def new_iterative(master_list)
    new_list = []
    if master_list.empty?
      get_top_teams(@cohort).each {|group| new_list << [group]}
    else
      master_list.each {|solution| new_list += next_set_of_teams(solution)}
    end
    new_list
  end

  def generate_potential_pairings
    master_list = []
    master_list = new_iterative(master_list) until fully_populated?(master_list)
    uniq_it(master_list)
  end

  def uniq_it(master_list)
    sorted = master_list.map do |arr|
      arr.sort_by {|sub| sub.first}
    end
    sorted.uniq
  end

  def rate_pairings(groups)
    groups.inject(0) {|cumulative_score, group| cumulative_score + prospective_score(group)}
  end

  def next_set_of_teams(groups_so_far)
    return_list = []
    students = @cohort - groups_so_far.flatten
    temp_hash = @yet_to_pair.dup
    groups_so_far.each do |group|
      temp_hash = process_teams(group, temp_hash)
    end
    next_best_set_of_teams = get_top_teams(students, temp_hash)
    next_best_set_of_teams.each do |next_team|
      return_list << groups_so_far + [next_team]
    end
    return_list
  end

  def fully_populated?(group_list)
    return false if group_list.empty?
    group_list.last.flatten.count == @cohort.count
  end


  def get_top_teams(students, hash_to_score=@yet_to_pair.dup)
    combos = students.combination(@per_team).to_a
    sorted_combos = combos.sort_by {|c| prospective_score(c)}
    top_teams = []
    @sample_size.times do
      top_teams << sorted_combos.pop
    end
    top_teams.compact
  end

  def prospective_score(team)
    team.inject(0) do |sum, boot|
      other_team_members = team - [boot]
      common_boots = @yet_to_pair[boot] & other_team_members
      sum + common_boots.count
    end
  end

  def process_teams(team, hash_to_process=@yet_to_pair)
    team.each do |element|
      others = [team - [element]].flatten
      others.each do |o|
        hash_to_process[element] -= [o]
      end
    end
    hash_to_process
  end

  def students_with_num_matches(number)
    @yet_to_pair.keys.select {|k| @yet_to_pair[k].length == number}
  end

 def score(counter, teams_list)
    puts "ROUND #{counter}"
    puts "*" * 10
    puts "score: #{@score}"
    puts "paired with everybody: #{(students_with_num_matches(0)).length}"
    puts "missed one pair: #{(students_with_num_matches(1)).length}"
    puts "missed more than one: #{(@yet_to_pair.keys.select {|k| @yet_to_pair[k].length > 1}).length}"
  end
end


def schoolgirls(opts={})
  schoolgirl_list = %w(A B C D E F G H I J K L M N O)
  group_size = 3
  sg = Combo.new(schoolgirl_list, group_size, opts)
  sg.run
end

def boots(opts={}) # sample of '3' gives 7 iterations
  boots_list = %w(A B C D E F G H I J K L M N O P Q R S T U V W X)
  group_size = opts[:per_team] || 6
  b = Combo.new(boots_list, group_size, opts)
  b.run
end
