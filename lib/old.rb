def random_pair array  #This is an edited version of Phillip 's code, that returns an array
	#of arrays of pairs of people, if there are odd number of people, one will get not included.
	array.shuffle!
	result = []
	if array.length.odd?
		array.pop
	end
	array.each_slice(2) do |b|
		array1 = []
	    array1 << b[0]
	    array1 << b[1]
	    result << array1
	end
	return result
end

#This is version1 of our code, in order to produce a new pairing that does not repeat any
#existing pairing given as an array of array pairs in the second argument 'paired_names'
#It works on the basis of running random_pair method above, see if the result has any
#conflict with paired_names, if there are, the run the version1 method again, if not then
#return the pairing given by random_pair method.
#Allowed for splat argument for paired_names.
$num_of_recurs = 0
def random_pairing_v1(names_array, *paired_names)
	paired_names = paired_names.flatten(1)

	original_people_array = []
	names_array.each do |name|
			original_people_array << name
	end
	original_paired_names = []
	paired_names.each do |pairs|
		original_paired_names << pairs
	end
	new_pair = random_pair(names_array)
	new_pair.each do |pair|
		pair.sort!
	end
	existing_pairs = paired_names.each do |pair|
		pair.sort!
	end
	for i in 0...new_pair.length do
		for j in 0...existing_pairs.length do
			if existing_pairs[j] == new_pair[i]
				$num_of_recurs +=1
				puts "#{$num_of_recurs} recursions took place."
				return random_pairing_v1(original_people_array,original_paired_names)
			end
		end
	end
	return new_pair
end

#The above version1 works, but it is rather inefficient.  Version2 aims to do the selection once,
#this can be achieved by when we are picking a person to pair with person x, before the random
#selection is made, remove those who have already paired with x, then we are guaranteed to select
#someone who has not paired with x.  (Working under assumption there will always be someone.)
#This is a copy of version2 with comments to help see it working in steps.
def random_pairing_v2_with_comments(names, *paired_list)
	pairs = paired_list.flatten(1)
	results = []; existing_pairs = {}
	pairs.each do |pairs|
		if existing_pairs.has_key?(pairs[0])
			existing_pairs[pairs[0]] << pairs[1]
		else
			existing_pairs[pairs[0]] = []
			existing_pairs[pairs[0]] << pairs[1]
		end
		if existing_pairs.has_key?(pairs[1])
			existing_pairs[pairs[1]] << pairs[0]
		else
			existing_pairs[pairs[1]] = []
			existing_pairs[pairs[1]] << pairs[0]
		end
	end
	p names
	puts 'Below are the people each person has paired with already:'
	p existing_pairs   #to comment out after testing
	puts ''
	while names.length >= 2
		name = names[0]

		pair_array = []
		pair_array << name

		if existing_pairs.has_key?(name)
			hat = names - existing_pairs[name]
		else
			hat = names - []  #seems - [] actually creates a DEEP copy of names!...interesting
		end
		hat.delete(name)
		puts "Now we have #{name}, we need to pick someone from #{hat}"
		index = rand(0..hat.length-1)
		pair_array << hat[index]
		names.delete(hat[index])
		names.delete(names[0])
		results << pair_array
		puts "We picked #{pair_array[1]}, so the new pair is #{pair_array}"
		puts "Now we have #{names} left to pair up."

		if existing_pairs.has_key?(pair_array[0]) == false
			existing_pairs[pair_array[0]] = []
		end
		existing_pairs[pair_array[0]] << pair_array[1]

		if existing_pairs.has_key?(pair_array[1]) == false
			existing_pairs[pair_array[1]] = []
		end
		existing_pairs[pair_array[1]] << pair_array[0]
		puts "Updating existing pairing to include this new pairing:"
		p existing_pairs
		p "Ready for the next person."
		puts ''

	end
	return results
end

#version2 without comments
def random_pairing_v2(names, *paired_list)
	pairs = paired_list.flatten(1)
	results = []; existing_pairs = {}
	pairs.each do |pairs|
		if existing_pairs.has_key?(pairs[0])
			existing_pairs[pairs[0]] << pairs[1]
		else
			existing_pairs[pairs[0]] = []
			existing_pairs[pairs[0]] << pairs[1]
		end
		if existing_pairs.has_key?(pairs[1])
			existing_pairs[pairs[1]] << pairs[0]
		else
			existing_pairs[pairs[1]] = []
			existing_pairs[pairs[1]] << pairs[0]
		end
	end

	while names.length >= 2

		name = names[0]
		pair_array = []
		pair_array << name
		if existing_pairs.has_key?(name)
			hat = names - existing_pairs[name]
		else
			hat = names - []  #seems - [] actually creates a DEEP copy of names!...interesting
		end
		hat.delete(name)
		index = rand(0..hat.length-1)
		pair_array << hat[index]
		names.delete(hat[index]); names.delete(names[0])
		results << pair_array

		if existing_pairs.has_key?(pair_array[0]) == false
			existing_pairs[pair_array[0]] = []
		end
		existing_pairs[pair_array[0]] << pair_array[1]

		if existing_pairs.has_key?(pair_array[1]) == false
			existing_pairs[pair_array[1]] = []
		end
		existing_pairs[pair_array[1]] << pair_array[0]

	end

	return results
end

def test1
	people = ['Yana','Harriet','Lucy','Joe','Tim','Sarah','Usman','Matt','Adrian']
	pairing1 = [["Yana", "Joe"],["Joe","Usman"]]
	pairing2 = [["Usman", "Matt"], ["Adrian", "Sarah"],
		["Lucy", "Tim"],["Sarah", "Yana"], ["Lucy", "Matt"], ["Tim", "Usman"],
		["Adrian", "Harriet"]]
	p random_pairing_v1(people,pairing1,pairing2) #for testing of version2
end

def test2
	people = ['Yana','Harriet','Lucy','Joe','Tim','Sarah','Usman','Matt','Adrian']
	pairing1 = [["Yana", "Joe"],["Joe","Usman"]]
	pairing2 = [["Usman", "Matt"], ["Adrian", "Sarah"],
		["Lucy", "Tim"],["Sarah", "Yana"], ["Lucy", "Matt"], ["Tim", "Usman"],
		["Adrian", "Harriet"]]
	p random_pairing_v2_with_comments(people,pairing1,pairing2) #for testing of version2
end

test2

def test3  #think of it as 10 football teams, and this is the LAST day of the league, so realy there is
	#no choice to make about who plays who...
	array1 = ['person1','person2','person3','person4','person5','person6','person7','person8','person9','person10']
	test1 = [["person8", "person6"], ["person7", "person10"], ["person9", "person1"], ["person4", "person5"], ["person2", "person3"]]
	test2 = [["person1", "person3"], ["person2", "person9"], ["person4", "person10"], ["person5", "person6"], ["person7", "person8"]]
	test3 = [["person1", "person7"], ["person2", "person8"], ["person3", "person4"], ["person5", "person9"], ["person6", "person10"]]
	test4 = [["person1", "person2"], ["person3", "person5"], ["person4", "person7"], ["person6", "person9"], ["person8", "person10"]]
	test5 = [["person1", "person4"], ["person2", "person10"], ["person3", "person6"], ["person5", "person7"], ["person8", "person9"]]
	test6 = [["person1", "person8"], ["person2", "person7"], ["person3", "person9"], ["person4", "person6"], ["person5", "person10"]]
	test7 = [["person1", "person10"], ["person2", "person6"], ["person3", "person7"], ["person4", "person9"], ["person5", "person8"]]
	test8 = [["person1", "person6"], ["person2", "person5"], ["person3", "person10"], ["person4", "person8"], ["person7", "person9"]]

	p random_pairing_v1(array1, test1, test2, test3, test4, test5, test6, test7, test8)
	p "let's try version 2..."
	p random_pairing_v2(array1, test1, test2, test3, test4, test5, test6, test7, test8)
end

#uncomment to run tests one at a time
#test2
#test1
#test3
