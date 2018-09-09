require 'thor'
require 'dmp'

module Dmp
  class CLI < Thor
    desc 'gen [length]', 'Generate a passphrase of the desired length.'
    def gen_pass(pass_length=7)
      passphrase = Dmp.gen_passphrase(pass_length.to_i)
      print passphrase.join(' ')
    end
  end
end
