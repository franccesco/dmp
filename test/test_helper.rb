$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "dmp"
require 'coveralls'
require "minitest/autorun"
require 'minitest/reporters'
Coveralls.wear!
Minitest::Reporters.use!
