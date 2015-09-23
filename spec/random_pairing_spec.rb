require 'random_pairing'
include RandomPairing

class DummyClass
end

describe DummyClass do

  describe "#update_with" do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(RandomPairing)
    end

    it 'updates the pairs hash when both names exist as keys' do
      existing_pairs = {Adam:[:Joe], Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy],:Zack =>[:Harry]}
      new_pair = [:Adam,:John]
      existing_pairs.update_with(new_pair)
      expect(existing_pairs).to eq({Adam:[:Joe,:John],Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy,:Adam],:Zack =>[:Harry]})
    end

    it 'updates the pairs hash when one name exist as keys' do
      existing_pairs = {Adam:[:Joe], Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy],:Zack =>[:Harry]}
      new_pair = [:Adam,:Tim]
      existing_pairs.update_with(new_pair)
      expect(existing_pairs).to eq({Adam:[:Joe,:Tim],Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy],:Zack =>[:Harry],:Tim => [:Adam]})
    end

    it 'updates the pairs hash when no name exist as keys' do
      existing_pairs = {Adam:[:Joe], Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy],:Zack =>[:Harry]}
      new_pair = [:Sarah,:Tim]
      existing_pairs.update_with(new_pair)
      expect(existing_pairs).to eq({Adam:[:Joe], Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy],:Zack =>[:Harry],:Sarah => [:Tim],:Tim =>[:Sarah]})
    end

    it 'make no change to the pairs hash when pair has only one name' do
      existing_pairs = {Adam:[:Joe], Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy],:Zack =>[:Harry]}
      new_pair = [:Sarah]
      existing_pairs.update_with(new_pair)
      expect(existing_pairs).to eq({Adam:[:Joe], Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy],:Zack =>[:Harry]})
    end
  end

  describe "#current_pairing" do
    before(:each) do
      @dummy_class = DummyClass.new
      @dummy_class.extend(RandomPairing)
    end

    it{expect(@dummy_class).to respond_to(:current_pairing)}

    it 'produces a hash of past pairs example 1' do
      past_pair1 = [[:Joe,:Adam],[:Amy,:John],[:Zack,:Harry]]
      past_pair_hash = @dummy_class.current_pairing(past_pair1)
      expect(past_pair_hash).to eq({Adam:[:Joe], Amy:[:John],:Harry =>[:Zack],
        :Joe =>[:Adam],:John =>[:Amy],:Zack =>[:Harry]})
    end

    it 'produces a hash of past pairs example 2' do
      past_pair1 = [[:Joe,:Adam],[:Amy,:John],[:Zack,:Harry]]
      past_pair2 = [[:Joe,:Amy],[:Zack,:John],[:Adam,:Harry]]
      past_pair_hash = @dummy_class.current_pairing(past_pair1,past_pair2)
      expect(past_pair_hash).to eq({Adam:[:Joe,:Harry], Amy:[:John,:Joe],
        :Harry =>[:Zack,:Adam],:Joe =>[:Adam,:Amy],:John =>[:Amy,:Zack],
        :Zack =>[:Harry,:John]})
    end

    it 'produces a hash of past pairs example 3' do
      past_pair1 = [[:Joe,:Adam],[:Amy,:John],[:Zack,:Harry]]
      past_pair2 = [[:Joe,:Amy],[:Zack,:John],[:Adam,:Harry]]
      past_pair3 = [[:Joe,:John],[:Zack,:Amy],[:Roy]]
      past_pair4 = [[:Joe,:Tom],[:James,:David],[:Adam,:Amy]]
      past_pair_hash = @dummy_class.current_pairing(past_pair1,past_pair2,past_pair3,past_pair4)
      expect(past_pair_hash).to eq({Joe:[:Adam, :Amy, :John, :Tom], Adam:[:Joe, :Harry, :Amy],
        Amy:[:John, :Joe, :Zack, :Adam], John:[:Amy, :Zack, :Joe], Zack:[:Harry, :John, :Amy],
        Harry:[:Zack, :Adam], Tom:[:Joe], James:[:David], David:[:James]})
    end
  end

  describe "#random_pair" do
    it "produce random pairing when given no history" do
      names = [:Joe,:Adam,:Amy,:John]
      srand(100)
      expect(names.random_pairing()).to eq([[:Joe, :Adam], [:Amy, :John]])
    end

    it "produce random pairing when given some history" do
      names = [:Joe,:Adam,:Amy,:John,:Henry,:Alex]
      past_pair1 = [[:Joe,:Adam],[:Amy,:John],[:Alex,:Henry]]
      past_pair2 = [[:Joe,:Amy],[:Adam,:Alex],[:John,:Henry]]
      srand(200)
      expect(names.random_pairing(past_pair1,past_pair2)).to eq([[:Joe, :Alex], [:Adam, :John], [:Amy, :Henry]])
    end

    it "produce the last available pairing" do
      names = [:Joe,:Adam,:Amy,:John]
      past_pair1 = [[:Joe,:Adam],[:Amy,:John]]
      past_pair2 = [[:Joe,:Amy],[:Adam,:John]]
      expect(names.random_pairing(past_pair1,past_pair2)).to eq([[:Joe,:John],[:Adam,:Amy]])
    end

    it "produce an array of solo persons if there are no pairings left" do
      names = [:Joe,:Adam,:Amy,:John]
      past_pair1 = [[:Joe,:Adam],[:Amy,:John]]
      past_pair2 = [[:Joe,:Amy],[:Adam,:John]]
      past_pair3 = [[:Joe,:John],[:Adam,:Amy]]
      expect(names.random_pairing(past_pair1,past_pair2,past_pair3)).to eq([:Joe, :Adam, :Amy, :John])
    end

    it "produce one pair if there are only one pair left rest solo" do
      names = [:Joe,:Adam,:Amy,:John]
      past_pair1 = [[:Joe,:Adam],[:Amy,:John]]
      past_pair2 = [[:Joe,:Amy],[:Adam,:John]]
      past_pair3 = [[:Joe,:John]]
      expect(names.random_pairing(past_pair1,past_pair2,past_pair3)).to eq([[:Adam, :Amy], :Joe, :John])
    end

    it "produce the random_pairing with a solo person" do
      names = [:Joe,:Adam,:Amy,:John,:Harry]
      past_pair1 = [[:Joe,:Adam],[:Amy,:John]]
      past_pair2 = [[:Joe,:Amy],[:Adam,:John]]
      srand(1234)
      expect(names.random_pairing(past_pair1,past_pair2)).to eq([[:Joe, :Harry], [:Adam, :Amy], :John])
    end

    it "produces all possible pairings when given even number of names" do
      names = [:Joe,:Adam,:Amy,:John,:Harry,:David,:Ben,:Ryan]
      srand(100)
      past_pair1 = names.random_pairing
      expect(past_pair1).to eq([[:Joe, :Adam], [:Amy, :John], [:Harry, :David], [:Ben, :Ryan]])
      past_pair2 = names.random_pairing(past_pair1)
      expect(past_pair2).to eq([[:Joe, :Harry], [:Adam, :Ryan], [:Amy, :David], [:John, :Ben]])
      past_pair3 = names.random_pairing(past_pair1,past_pair2)
      expect(past_pair3).to eq([[:Joe, :David], [:Adam, :Harry], [:Amy, :Ben], [:John, :Ryan]])
      past_pair4 = names.random_pairing(past_pair1,past_pair2,past_pair3)
      expect(past_pair4).to eq([[:Joe, :Ben], [:Adam, :John], [:Amy, :Harry], [:David, :Ryan]])
      p current_pairing(past_pair1,past_pair2,past_pair3,past_pair4)
      # srand(233)
      past_pair5 = names.random_pairing(past_pair1,past_pair2,past_pair3,past_pair4)
      expect(past_pair5).to eq([[:Joe, :Ben], [:Adam, :John], [:Amy, :Harry], [:David, :Ryan]])
      #problem....cannot be easily solved.....must RESTART
    end
  end
end
