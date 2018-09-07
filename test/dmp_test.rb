require "test_helper"
require 'dmp'

class DmpTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Dmp::VERSION
  end

  def test_if_return_hello
    hello = DMP::Hello.salute
    assert(hello == 'Hello, world!', "Didn't returned hello world.")
  end
end
