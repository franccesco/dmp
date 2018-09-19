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
    method_option :hibp,
                  aliases: '-H',
                  type: :boolean,
                  desc: 'Check if passphrase is vulnerable in HIBP database.'
    def gen_pass(pass_length = 7)
      # Generate colored passphrase
      passphrase = Dmp.gen_passphrase(pass_length.to_i)

      # if flag clipboard is 'true' then copy passphrase to clipboard
      if options[:clipboard]
        Clipboard.copy(passphrase.join(' '))
      end

      # if flag hibp is 'true' then alert the user
      if options[:hibp]
        vuln_count = Dmp.check_pwned(passphrase)
      end

      # colors array will be used to pick a randomized sample
      # removing black cause it looks ugly in terminals
      colors = String.colors
      colors.delete(:black)

      passphrase.map! do |phrase|
        rand_color = colors.sample
        phrase.colorize(rand_color)
      end
      puts '- Passphrase: '.bold + passphrase.join(' ')
      puts '- Copied to clipboard.'.bold.green if options[:clipboard]
      if vuln_count
        puts "- WARNING: Passphrase vulnerable #{vuln_count} times!".red.bold
      elsif options[:hibp]
        puts '- Password is safe to use.'.green.bold
      end
    end

    desc 'check', 'Check if a password/passphrase is vulnerable.'
    def check_pass
      puts 'Enter your password, press ENTER when you\'re done.'
      password = ask('Password (hidden):'.yellow, echo: false)
      vuln_count = Dmp.check_pwned(password)
      if vuln_count
        puts " Your password appears in #{vuln_count} data sets!".red.bold
      else
        puts " Your password/passphrase is safe to use.".green.bold
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
