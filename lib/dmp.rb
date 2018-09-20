require 'dmp/version'
require 'net/http'
require 'digest/sha1'

module Dmp
  # Module to manage DMP operations.
  # gen_passphrase generates a new passphrase of a desired length.
  # check_pwned checks the password string against the HIBP datasets.
  # default wordlist provided by EFF https://www.eff.org/dice
  @eff_wordlist = File.dirname(__FILE__) + '/dmp/assets/eff_long_wordlist.txt'

  def self.gen_passphrase(pass_length = 7)
    wordlist = File.readlines(@eff_wordlist)
    wordlist.map(&:strip!)
    wordlist.shuffle[0...pass_length]
  end

  def self.check_pwned(passphrase)
    # This module follows the k-Anonymity principle described in
    # https://haveibeenpwned.com/API/v2#PwnedPasswords
    # that allows you to search for the first 5 characters of the hash and
    # returns a list of hashes for you to search the rest of the hash locally,
    # followed by the number of times the hash appears in a data set
    # e.g: 0018A45C4D1DEF81644B54AB7F969B88D65:21
    passphrase = passphrase.join(' ') if passphrase.is_a?(Array)

    sha1_pass = Digest::SHA1.hexdigest(passphrase)
    sha1_excerpt = sha1_pass[0...5]
    sha1_to_look_for = sha1_pass[5..-1]

    api_url = URI("https://api.pwnedpasswords.com/range/#{sha1_excerpt}")
    api_request = Net::HTTP.get(api_url)

    # Response is text instead of JSON, needs to format the response
    # to a dictionary so the rest of the hash can be located easier.
    # => String '0018A45C4D1DEF81644B54AB7F969B88D65:21'
    # => Array ['0018A45C4D1DEF81644B54AB7F969B88D65:21', ...]
    # => 2D Array [['0018A45C4D1DEF81644B54AB7F969B88D65', '21'], ...]
    # => Hash {'0018A45C4D1DEF81644B54AB7F969B88D65': 21, ...}
    striped_list = api_request.split("\r\n")
    pass_list = striped_list.map { |hash| hash.split(':') }
    hash_list = Hash[*pass_list.flatten!]
    hash_list[sha1_to_look_for.upcase]
  end
end
