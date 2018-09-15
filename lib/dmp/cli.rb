require 'thor'
require 'dmp'
require 'colorize'
require 'clipboard'

module Dmp
  # Command line interface for DMP
  class CLI < Thor
    default_task :gen_pass
    desc 'gen [length]', 'Generate a passphrase of the desired length.'
    method_option :clipboard,
                  aliases: '-c',
                  type: :boolean,
                  desc: 'Copy passphrase to clipboard.'
    def gen_pass(pass_length = 7)
      # Generate colored passphrase
      passphrase = Dmp.gen_passphrase(pass_length.to_i)

      # if flag clipboard is 'true' then copy passphrase to clipboard

      # colors array will be used to pick a randomized sample
      # removing black cause it looks ugly in terminals
      colors = String.colors
      colors.delete(:black)

      passphrase.map! do |phrase|
        rand_color = colors.sample
        phrase.colorize(rand_color)
      end
      puts '- Passphrase: '.bold + passphrase.join(' ')
      if options[:clipboard]
        Clipboard.copy(passphrase.join(' '))
        puts '- Copied to clipboard.'.bold.green
      end
    end

    desc 'about', 'Displays version number and information'
    def about
      # Displays banner, version number and author
      puts Dmp::BANNER.bold.red
      puts 'version: '.bold + Dmp::VERSION.green
      puts 'author: '.bold + '@__franccesco'.green
      puts 'homepage: '.bold + 'https://github.com/franccesco/dmp'.green
      puts 'learn more: '.bold + 'https://codingdose.info'.green
      puts # extra line, somehow I like them.
    end
  end
end
