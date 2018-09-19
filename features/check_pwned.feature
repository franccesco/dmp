Feature: Check HIBP Database
  It displays a warning if password is found on
  HIBP database, else it displays that
  it is safe to use it.

  Scenario: dmp warns about an insecure passphrase
    When I run `dmp -H 1`
    Then the output should contain "WARNING:"

  Scenario: dmp checks a secure password
    When I run `dmp gen 12 -H`
    Then the output should contain "Password is safe to use."
