require 'thor'
require 'dmp'
require 'colorize'
require 'clipboard'

module Dmp
  # Command line interface for DMP
  class CLI < Thor
    default_task :gen_pass

    # Define option 'gen' that accepts a flag to copy to clipboard ('-c')
    # and another one to check the generated password agains HIBP ('-H')
    # This argument is the default task and it generates a 7 passphrase lenght.
    # Usage:
    # $ dmp gen [optional_length] [optional flags]
    # Example:
    # $ dmp gen 8 -c -H
    # Or:
    # $ dmp 8
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
      new_passphrase = Dmp.gen_passphrase(pass_length.to_i)
      Clipboard.copy(new_passphrase.join(' ')) if options[:clipboard]
      dataset_count = Dmp.check_pwned(new_passphrase) if options[:hibp]

      colors = String.colors
      colors.delete(:black) # black color looks ugly in the terminal
      new_passphrase.map! do |phrase|
        random_color = colors.sample
        phrase.colorize(random_color)
      end

      copy_msg = '- Copied to clipboard.'.bold.green
      vuln_pass_msg = "- WARNING: Passphrase appears in #{dataset_count} datasets!".red.bold
      safe_pass_msg = '- Password was not found in a dataset.'.green.bold

      puts '- Passphrase: '.bold + new_passphrase.join(' ')
      puts copy_msg if options[:clipboard]
      puts dataset_count ? vuln_pass_msg : safe_pass_msg if options[:hibp]
    end

    # Check if passphrase or password is vulnerable interatively
    # This feature disables echo to avoid making the password visible.
    # This feature should not ask for the password in the terminal command line
    # (e.g: dmp check password) as it would be visible in the terminal history.
    # Usage:
    # $ dmp check
    desc 'check', 'Check if a password/passphrase is vulnerable.'
    def check_pass
      puts "Enter your password, press ENTER when you're done."
      password = ask('Password (hidden):'.yellow, echo: false)
      (puts "Aborted.".red.bold; exit) if password.empty?

      dataset_count = Dmp.check_pwned(password)
      vuln_msg = "Your password appears in #{dataset_count} datasets!".red.bold
      safe_msg = "Your password was not found in a dataset.".green.bold
      puts dataset_count ? vuln_msg : safe_msg
    end

    # Displays banner, version number and author
    desc 'about', 'Displays version number and information'
    def about
      puts Dmp::BANNER.bold.red
      puts 'version: '.bold + Dmp::VERSION.green
      puts 'author: '.bold + '@__franccesco'.green
      puts 'homepage: '.bold + 'https://github.com/franccesco/dmp'.green
      puts 'learn more: '.bold + 'https://codingdose.info'.green
      puts # extra line, somehow I like them.
    end
  end
end
