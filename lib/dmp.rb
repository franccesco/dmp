require "dmp/version"

module Dmp
  # default wordlist provided by EFF https://www.eff.org/dice
  @@eff_wordlist = File.dirname(__FILE__) + '/dmp/assets/eff_long_wordlist.txt'

  def self.gen_passphrase(pass_length = 7)
    # load eff_wordlist as a list and strip new lines
    pass_list = File.readlines(@@eff_wordlist)
    pass_list.map(&:strip!)

    # randomize wordlist and strip it to the desired length
    random_pass = pass_list.shuffle[0...pass_length]
    random_pass
  end
end
