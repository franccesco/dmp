require "test_helper"
require 'dmp'

class DmpTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Dmp::VERSION
  end

  def test_if_gen_passphrase_respects_length
    passphrase_3 = Dmp::gen_passphrase(3)
    passphrase_default = Dmp::gen_passphrase
    passphrase_12 = Dmp::gen_passphrase(12)
    assert passphrase_3.length == 3, 'Passphrase length != 3'
    assert passphrase_default.length == 7, 'Passphrase length != 7'
    assert passphrase_12.length == 12, 'Passphrase length != 12'
  end
end
