module RandomPairing

  def random_pairing(*past_pairings)
    original_self = self.dup
    names_to_use = self.dup
    existing_pairs = current_pairing(*past_pairings)
    random_pairs = []
  	while names_to_use.length >= 2
      new_pair = names_to_use.new_random_pair(existing_pairs)
      random_pairs << new_pair unless new_pair == nil
      existing_pairs.update_with(new_pair)
    end
    random_pairs + add_solo_persons(random_pairs, original_self)
  end

  def current_pairing(*paired_list)
    pairs = paired_list.flatten(1)
    existing_pairs = {}
    pairs.each do |pair|
  	   existing_pairs.update_with(pair)
  	end
    existing_pairs
  end

  def new_random_pair(existing_pairs)
    first_person = self.delete_at(0)
    hat_of_names = existing_pairs.has_key?(first_person) ?
    self - existing_pairs[first_person] : self.dup
    return nil if hat_of_names == []
    selected_index = rand(0...hat_of_names.length)
    second_person = self.delete(hat_of_names[selected_index])
    [first_person,second_person]
  end

  def update_with(pair)
    return nil if pair == nil || pair.count == 1
    self.update_with_first_person(pair)
    self.update_with_second_person(pair)
  end

  def add_solo_persons(random_pairs, original_self)
    original_self - random_pairs.flatten
  end

  def update_with_first_person(pair)
    self[pair[0]] ||= []
    self[pair[0]] << pair[1]
  end

  def update_with_second_person(pair)
    self[pair[1]] ||= []
    self[pair[1]] << pair[0]
  end

end
