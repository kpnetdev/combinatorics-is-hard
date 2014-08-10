require './new_combo.rb'

describe Combo do

	before(:each) do
		@c = Combo.new(%w(A B C D E F), 2)
	end

	it "initializes the yet_to_pair hash correctly" do
		expect(@c.yet_to_pair["A"]).to eq(["B", "C", "D", "E", "F"])
	end

	it "correctly scores a zero-score prospective pairing" do
		@c.yet_to_pair["A"] = %w(C D E F)
		@c.yet_to_pair["B"] = %w(C D E F)
		team = ["A", "B"]

		expect(@c.prospective_score(team)).to eq(0)
	end

	it "correctly scores a two-score pairing" do
		@c.yet_to_pair["A"] = ["B"]
		@c.yet_to_pair["B"] = ["A"]
		team = ["A", "B"]

		expect(@c.prospective_score(team)).to eq(2)
	end

	it "initializes the default @sample variable correctly" do
		expect(@c.sample_size).to eq(3)
	end

	it "takes a @sample value from opts correctly" do
		@d = Combo.new(["A", "B"], 2, {sample: 4})

		expect(@d.sample_size).to eq(4)
	end

	describe "#look_ahead" do

		it "doesn't mess up @yet_to_pair" do
			pre = @c.yet_to_pair.dup
			group = [["A", "B"], ["C", "D"], ["E", "F"]]
			@c.look_ahead(group)

			expect(@c.yet_to_pair).to eq(pre)
		end
	end

	describe "maybe refactor score_teams" do
		it "works the way I think" do
			expect(@c.score_teams(["A", "B"])).to eq(10)
		end
	end


#	describe "#perfect_score" do
#
#		it "gives the top pairing score possible" do
#			expect(@c.perfect_score).to eq(6)
#		end
#
#		it "works for boots too" do
#			b = Combo.new((1..24).to_a, 6)
#			expect(b.perfect_score).to eq(120)
#		end
#	end


	# it "removes the teams from the master combo list" do
	# 	team = %w(A B)
	# 	expect(@c.master_combos.include?(team)).to eq(true)
	# 	@c.process_teams(team)
	# 	expect(@c.master_combos.include?(team)).to eq(false)
	# end

	# it "checks if the given list is a full pairing list" do
	# 	expect(@c.pairing_list_full?(@c.cohort)).to eq(true)
	# 	expect(@c.pairing_list_full?(["A"])).to eq(false)
	# end

	# it "gives all the full pass combos for a given first team" do
	# 	first_team = ["A", "B"]
	# 	expected_list = [[["A", "B"], ["C", "D"], ["E", "F"]], [["A", "B"], ["C", "E"], ["D", "F"]]]
	# 	expect(@c.all_week_lineups(first_team)).to eq(expected_list)
	# end

	# it "finds the common matches correctly" do
	# 	@d = Combo.new(%w(A B C D E F G H I), 3)
	# 	preselected = ["A", "B", "C"]
	# 	@d.yet_to_pair["A"] = ["D", "E", "G"]
	# 	@d.yet_to_pair["B"] = ["E", "G", "I"]
	# 	@d.yet_to_pair["C"] = ["Y", "G"]

	# 	expect(@d.common_matches(preselected)).to eq(["G"])
	# end

	# it "sorts students by yet_to_pair array length" do
	# 	students = %w(A B C)
	# 	@c.yet_to_pair["A"] = ["G"]
	# 	@c.yet_to_pair["B"] = ["J", "K", "L"]
	# 	@c.yet_to_pair["C"] = ["D", "T"]

	# 	expect(@c.sort_students(students)).to eq(["B", "C", "A"])
	# end

	# it "sorts unmatches by their incidence in the group" do
	# 	@c.yet_to_pair["A"] = %w(D F J)
	# 	@c.yet_to_pair["B"] = %w(D F X)
	# 	@c.yet_to_pair["C"] = %w(D F J)

	# 	expect(@c.rank_non_matches(%w(A B C))).to eq(["D", "F", "J", "X"])

	# end
end
