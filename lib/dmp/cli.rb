require 'thor'
require 'dmp'
require 'colorize'

module Dmp
  # Command line interface for DMP
  class CLI < Thor
    desc 'gen [length]', 'Generate a passphrase of the desired length.'
    def gen_pass(pass_length = 7)
      passphrase = Dmp.gen_passphrase(pass_length.to_i)

      colors = String.colors
      colors.delete(:black)

      passphrase.map! do |phrase|
        rand_color = colors.sample
        phrase.colorize(rand_color)
      end

      print '[*] Passphrase: '.bold + passphrase.join(' ')
    end

    default_task :gen_pass
  end
end
