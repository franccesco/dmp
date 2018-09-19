require "test_helper"
require 'dmp'

class DmpTest < Minitest::Test

  def setup
    @unsafe_pass = 'passw0rd'
    @safe_pass = Dmp.gen_passphrase(pass_length = 12)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Dmp::VERSION
  end

  def test_if_gen_passphrase_respects_length
    # gen_passphrase should respect prassphrase length
    passphrase3 = Dmp.gen_passphrase(3)
    passphrase_default = Dmp.gen_passphrase
    passphrase12 = Dmp.gen_passphrase(12)
    assert_equal passphrase3.length, 3, 'Passphrase length != 3'
    assert_equal passphrase_default.length, 7, 'Passphrase length != 7'
    assert_equal passphrase12.length, 12, 'Passphrase length != 12'
  end

  def test_vulnerable_pass
    # check_pwned should flag this password
    vuln_count = Dmp.check_pwned(@unsafe_pass)
    refute_nil vuln_count
  end

  def test_invulnerable_pass
    # check_pwned should not flag this passphrase
    vuln_count = Dmp.check_pwned(@safe_pass)
    assert_nil vuln_count
  end
end
