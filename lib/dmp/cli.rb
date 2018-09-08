require 'thor'
require 'dmp'

module Dmp
  class CLI < Thor
    desc 'gen LENGTH', 'Generate a passphrase of the desired length.'
    def gen_pass(pass_length=nil)
      'Hello World!'
    end
  end
end
