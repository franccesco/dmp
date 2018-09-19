$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'simplecov'
SimpleCov.start

require "dmp"
require 'coveralls'
require 'simplecov-console'
require "minitest/autorun"
require 'minitest/reporters'
Coveralls.wear!
Minitest::Reporters.use!
