require 'dmp/version'
require 'net/http'
require 'digest/sha1'

# Module to manage DMP operations
module Dmp
  # default wordlist provided by EFF https://www.eff.org/dice
  @eff_wordlist = File.dirname(__FILE__) + '/dmp/assets/eff_long_wordlist.txt'

  def self.gen_passphrase(pass_length = 7)
    # load eff_wordlist as a list and strip new lines
    pass_list = File.readlines(@eff_wordlist)
    pass_list.map(&:strip!)

    # randomize wordlist and strip it to the desired length
    random_pass = pass_list.shuffle[0...pass_length]
    random_pass
  end

  def check_pwned(passphrase)
    passphrase_string = passphrase.join(' ')
    hex_pass = Digest::SHA1.hexdigest(passphrase_string)
    hex_pass_sample = hex_pass[0...5]
    hex_pass_rest = hex_pass[5..-1]

    # request a sample to HIBP to avoid disclosing the full pwd
    uri = URI("https://api.pwnedpasswords.com/range/#{hex_pass_sample}")
    req = Net::HTTP.get(uri)

    clean_list = req.split("\r\n")
    pass_list = clean_list.map { |hash| hash.split(':') }
    pass_hash = Hash[*pass_list.flatten!]
    pass_hash[hex_pass_rest.upcase]
  end
end
